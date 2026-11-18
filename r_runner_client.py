"""Cliente del ejecutor de R aislado (servicio `r-runner`).

Usa solo la biblioteca estándar. La dirección del servicio se toma de la
variable de entorno RUNNER_URL (en docker compose: http://r-runner:8000).
"""
import base64
import json
import os
import urllib.error
import urllib.request

RUNNER_URL = os.getenv("RUNNER_URL", "http://r-runner:8000")


def runner_disponible(timeout=2):
    """Devuelve (True, info) si el ejecutor responde; (False, motivo) si no."""
    try:
        with urllib.request.urlopen(f"{RUNNER_URL}/health", timeout=timeout) as r:
            return True, json.loads(r.read().decode("utf-8"))
    except Exception as e:
        return False, str(e)


def ejecutar_en_r(codigo, nombre_archivo=None, contenido=None, timeout=150):
    """Envía el código (y el archivo de datos, si hay) al ejecutor.

    Devuelve un diccionario con: ok, returncode, timed_out, duration_s,
    r_version, stdout, stderr y files. Si algo falla antes de ejecutar,
    devuelve {"ok": False, "error": "..."}.
    """
    carga = {"code": codigo}
    if nombre_archivo and contenido is not None:
        carga["filename"] = nombre_archivo
        carga["data_b64"] = base64.b64encode(contenido).decode("ascii")

    peticion = urllib.request.Request(
        f"{RUNNER_URL}/run",
        data=json.dumps(carga).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(peticion, timeout=timeout) as r:
            return json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        try:
            return json.loads(e.read().decode("utf-8"))
        except Exception:
            return {"ok": False, "error": f"respuesta HTTP {e.code} del ejecutor"}
    except Exception as e:
        return {"ok": False, "error": str(e)}
