#!/usr/bin/env bash
# Pruebas de aislamiento y funcionamiento del ejecutor de R.
#
# Requisito: los servicios deben estar levantados (docker compose up -d).
# Uso, desde la raíz del repositorio:
#     bash scripts/probar_ejecutor_r.sh
#
# Termina con código 0 si todo pasa, y con código 1 si alguna comprobación falla.
export MSYS_NO_PATHCONV=1   # evita que Git Bash modifique rutas como /opt/...

ok=0
fallos=0
resultado() {  # resultado "descripción" código (0 = pasa)
  if [ "$2" -eq 0 ]; then
    echo "  OK    $1"; ok=$((ok + 1))
  else
    echo "  FALLA $1"; fallos=$((fallos + 1))
  fi
}

echo "== Red y secretos =="

docker compose exec -T r-runner python3 -c \
  "import urllib.request as u; u.urlopen('https://example.com', timeout=5)" >/dev/null 2>&1
if [ $? -ne 0 ]; then resultado "el ejecutor no tiene salida a internet" 0
else resultado "el ejecutor no tiene salida a internet" 1; fi

if docker compose exec -T r-runner env | grep -qi gemini; then
  resultado "el ejecutor no recibe la clave de la API" 1
else
  resultado "el ejecutor no recibe la clave de la API" 0
fi

if curl -s -m 3 -o /dev/null http://localhost:8000/health; then
  resultado "el ejecutor no es accesible desde el equipo anfitrión" 1
else
  resultado "el ejecutor no es accesible desde el equipo anfitrión" 0
fi

echo "== Funcionamiento y límites (desde la app) =="

docker compose exec -T app python - <<'EOF'
import sys
from r_runner_client import runner_disponible, ejecutar_en_r

fallos = []


def comprobar(nombre, condicion, detalle=""):
    print(("  OK    " if condicion else "  FALLA ") + nombre)
    if not condicion:
        print("        detalle:", detalle[:300])
        fallos.append(nombre)


ok, info = runner_disponible()
comprobar("la app alcanza al ejecutor", ok, str(info))

r = ejecutar_en_r('cat("hola")')
comprobar("ejecución simple", bool(r.get("ok")) and r.get("stdout", "").strip() == "hola", str(r))

r = ejecutar_en_r(
    'cat(all(sapply(c("MASS","ordinal","rcompanion","DescTools","tidyverse"),'
    ' requireNamespace, quietly = TRUE)))'
)
comprobar("los paquetes clave cargan", r.get("stdout", "").strip() == "TRUE", str(r))

r = ejecutar_en_r('cat(Sys.getenv("GEMINI_API_KEY") == "")')
comprobar("el código de R no ve la clave", r.get("stdout", "").strip() == "TRUE", str(r))

r = ejecutar_en_r(
    'x <- tryCatch(readLines("https://example.com", n = 1, warn = FALSE),'
    ' error = function(e) "SIN RED"); cat(x[1])'
)
comprobar("el código de R no tiene internet", "SIN RED" in r.get("stdout", ""), str(r))

r = ejecutar_en_r('writeLines("x", "/opt/runner/x.txt")')
comprobar("el código de R no puede escribir fuera de lo temporal", r.get("ok") is False, str(r))

r = ejecutar_en_r('d <- read.csv("a.csv"); cat(nrow(d))', "a.csv", b"x,y\n1,2\n3,4\n5,6\n")
comprobar("el script lee el archivo de datos subido", r.get("stdout", "").strip() == "3", str(r))

sys.exit(1 if fallos else 0)
EOF
resultado "bloque de pruebas desde la app" $?

echo
echo "Resumen: $ok correctas, $fallos con fallas"
[ "$fallos" -eq 0 ]
