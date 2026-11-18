#!/usr/bin/env python3
"""Ejecutor de R aislado.

Recibe por HTTP un script de R (y, opcionalmente, un archivo de datos), lo
ejecuta con Rscript en un directorio temporal y devuelve la salida.

Corre en un contenedor sin red, sin secretos y con el sistema de archivos de
solo lectura (salvo /work y /tmp). Solo usa la biblioteca estándar de Python.

Endpoints:
  GET  /health  -> estado y versión de R
  POST /run     -> {"code": str, "filename": str|null, "data_b64": str|null}
"""
import base64
import json
import os
import re
import signal
import shutil
import subprocess
import tempfile
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(os.getenv("PORT", "8000"))
WORK_ROOT = os.getenv("WORK_ROOT", "/work")
RUN_TIMEOUT = int(os.getenv("RUN_TIMEOUT", "120"))

MAX_BODY = 30 * 1024 * 1024        # tamaño máximo de la solicitud
MAX_CODE = 200_000                 # caracteres de código
MAX_OUT = 200_000                  # caracteres de salida devueltos
MAX_FILE = 2 * 1024 * 1024         # tamaño máximo de cada archivo generado
MAX_FILES_TOTAL = 5 * 1024 * 1024  # tamaño total de archivos generados
NAME_RE = re.compile(r"^[A-Za-z0-9._() -]{1,100}$")
DATA_EXT = (".csv", ".xlsx", ".xls")

_lock = threading.Lock()  # una ejecución a la vez


def _r_version():
    try:
        out = subprocess.run(
            ["R", "--version"], capture_output=True, text=True, timeout=20
        ).stdout
        return out.splitlines()[0].strip() if out else "desconocida"
    except Exception:
        return "desconocida"


R_VERSION = _r_version()


def _truncar(texto):
    if len(texto) > MAX_OUT:
        return texto[:MAX_OUT] + "\n[... salida truncada ...]"
    return texto


def ejecutar(codigo, nombre_datos, datos):
    workdir = tempfile.mkdtemp(dir=WORK_ROOT)
    try:
        with open(os.path.join(workdir, "script.R"), "w", encoding="utf-8") as f:
            f.write(codigo)
        if nombre_datos:
            with open(os.path.join(workdir, nombre_datos), "wb") as f:
                f.write(datos)

        entorno = {
            "PATH": "/usr/local/bin:/usr/bin:/bin",
            "HOME": workdir,
            "TMPDIR": workdir,
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8",
        }
        inicio = time.time()
        proc = subprocess.Popen(
            ["Rscript", "--vanilla", "script.R"],
            cwd=workdir,
            env=entorno,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            start_new_session=True,
        )
        timed_out = False
        try:
            salida, errores = proc.communicate(timeout=RUN_TIMEOUT)
        except subprocess.TimeoutExpired:
            timed_out = True
            os.killpg(proc.pid, signal.SIGKILL)
            salida, errores = proc.communicate()
        duracion = round(time.time() - inicio, 2)

        archivos, total = [], 0
        for nombre in sorted(os.listdir(workdir)):
            ruta = os.path.join(workdir, nombre)
            if nombre == "script.R" or nombre == nombre_datos or not os.path.isfile(ruta):
                continue
            tam = os.path.getsize(ruta)
            if tam > MAX_FILE or total + tam > MAX_FILES_TOTAL:
                continue
            with open(ruta, "rb") as f:
                archivos.append(
                    {"name": nombre, "data_b64": base64.b64encode(f.read()).decode()}
                )
            total += tam

        return {
            "ok": proc.returncode == 0 and not timed_out,
            "returncode": proc.returncode,
            "timed_out": timed_out,
            "duration_s": duracion,
            "r_version": R_VERSION,
            "stdout": _truncar(salida.decode("utf-8", errors="replace")),
            "stderr": _truncar(errores.decode("utf-8", errors="replace")),
            "files": archivos,
        }
    finally:
        shutil.rmtree(workdir, ignore_errors=True)


class Handler(BaseHTTPRequestHandler):
    server_version = "RRunner/1.0"

    def _responder(self, codigo_http, cuerpo):
        datos = json.dumps(cuerpo).encode("utf-8")
        self.send_response(codigo_http)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(datos)))
        self.end_headers()
        self.wfile.write(datos)

    def do_GET(self):
        if self.path == "/health":
            self._responder(
                200, {"status": "ok", "r_version": R_VERSION, "timeout_s": RUN_TIMEOUT}
            )
        else:
            self._responder(404, {"error": "no encontrado"})

    def do_POST(self):
        if self.path != "/run":
            return self._responder(404, {"ok": False, "error": "no encontrado"})
        try:
            largo = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            return self._responder(400, {"ok": False, "error": "Content-Length inválido"})
        if largo <= 0 or largo > MAX_BODY:
            return self._responder(
                413, {"ok": False, "error": "tamaño de solicitud no permitido"}
            )
        try:
            cuerpo = json.loads(self.rfile.read(largo))
        except Exception:
            return self._responder(400, {"ok": False, "error": "JSON inválido"})

        codigo = cuerpo.get("code")
        if not isinstance(codigo, str) or not codigo.strip() or len(codigo) > MAX_CODE:
            return self._responder(
                400, {"ok": False, "error": "código ausente o demasiado largo"}
            )

        nombre = cuerpo.get("filename")
        datos = b""
        if nombre is not None:
            if (
                not isinstance(nombre, str)
                or not NAME_RE.match(nombre)
                or nombre.startswith(".")
                or not nombre.lower().endswith(DATA_EXT)
            ):
                return self._responder(
                    400,
                    {
                        "ok": False,
                        "error": "nombre de archivo no permitido: usa solo letras, "
                        "números, punto, guion y espacio, con extensión .csv, .xlsx o .xls",
                    },
                )
            try:
                datos = base64.b64decode(cuerpo.get("data_b64", ""), validate=True)
            except Exception:
                return self._responder(
                    400, {"ok": False, "error": "datos del archivo inválidos"}
                )

        if not _lock.acquire(blocking=False):
            return self._responder(
                429, {"ok": False, "error": "ya hay una ejecución en curso"}
            )
        try:
            resultado = ejecutar(codigo, nombre, datos)
        except Exception as e:  # error del ejecutor, no del script de R
            return self._responder(
                500, {"ok": False, "error": f"error interno del ejecutor: {e}"}
            )
        finally:
            _lock.release()
        self._responder(200, resultado)


if __name__ == "__main__":
    print(f"Ejecutor de R en el puerto {PORT} · {R_VERSION} · tiempo límite {RUN_TIMEOUT} s")
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
