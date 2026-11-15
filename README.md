# Agente Bioestadístico Clínico (Proyecto RSNA Lumbar Spine)

Consultor bioestadístico asistido por IA para investigación clínica. El usuario escribe una consulta o sube un CSV/Excel; el agente identifica tipos de variables, revisa supuestos, recomienda pruebas y entrega código en R con su interpretación. No da diagnósticos médicos.

**Importante:** el agente no ejecuta R ni calcula sobre el archivo completo. Entrega scripts que la persona debe ejecutar y verificar. Ver [Limitaciones conocidas](#limitaciones-conocidas).

## Requisitos

- Python 3.12.10 (versión con la que se probó)
- Git
- Una clave de la API de Gemini (Google AI Studio)
- Docker Desktop (opcional, solo para la ejecución en contenedor)
- R 4.6.0 (2026-04-24, ucrt). Solo se necesita para ejecutar los scripts de `scripts/` y los que genera el agente.

## Ejecución desde un clon limpio

```bash
git clone https://github.com/juandacacua-gif/agente-consultoria.git
cd agente-consultoria

python -m venv .venv
source .venv/Scripts/activate      # Windows (Git Bash). En Linux/macOS: source .venv/bin/activate
pip install -r requirements.lock.txt

cp .env.example .env               # luego abre .env y pega tu clave
streamlit run app.py
```

La app abre en http://localhost:8501. Si `.env` tiene la clave, no la pide; si no, la solicita en el menú lateral.

Versión de consola: `python main.py` (requiere `GEMINI_API_KEY` en `.env`). Pide el nombre de un archivo `.csv`, `.xlsx` o `.xls` (o Enter para omitir) y se cierra con `salir`. Si el agente entrega código R, `main.py` lo guarda como `script_analisis.R` (archivo ignorado por git).

## Ejecución con Docker

La imagen empaqueta solo la app de Streamlit (`app.py`, `main.py` y `.streamlit/config.toml`). No incluye `.env` ni los datos: la clave se pasa al ejecutar y el CSV se sube desde la interfaz.

```bash
cp .env.example .env               # pega tu clave en .env (sin comillas)
docker build -t agente-consultoria:dev .
docker run -d --rm -p 127.0.0.1:8501:8501 --env-file .env --name agente agente-consultoria:dev
```

Abre http://localhost:8501. Para detenerlo: `docker stop agente`.

Detalles del `Dockerfile`:

- Imagen base fija: `python:3.12.10-slim-bookworm` (no `latest`).
- Multi-etapa: las dependencias se instalan en una etapa de construcción con `requirements.lock.txt` y se copian a la imagen final.
- Corre como usuario sin privilegios (`appuser`).
- `HEALTHCHECK` contra el endpoint de salud de Streamlit; `docker ps` debe mostrar `(healthy)` en unos 30 segundos.
- `.dockerignore` funciona como lista blanca: solo entran los archivos que la imagen necesita.
- El puerto se publica solo en `127.0.0.1`, porque la app no tiene autenticación y el contenedor lleva la clave de la API.

Comprobaciones usadas al validar la imagen:

```bash
docker ps --format "{{.Names}}  {{.Status}}"    # (healthy)
docker exec agente whoami                       # appuser
docker exec agente ls -a //app                  # app.py, main.py, .streamlit (sin .env ni CSV)
```

La primera construcción tarda unos 15 minutos (descarga e instalación de paquetes) y la imagen pesa alrededor de 1 GB en disco. Las siguientes son rápidas si solo cambia `app.py`.

### Variables de entorno

| Variable | Uso |
| --- | --- |
| `GEMINI_API_KEY` | Clave de la API de Gemini. Va en `.env`, que está en `.gitignore`. Nunca se sube. |

`.env.example` solo contiene un marcador. No pongas claves reales en él. Si una clave se expone, se revoca en Google AI Studio y se crea otra.

### Dependencias de Python

- `requirements.txt`: dependencias directas, con rangos.
- `requirements.lock.txt`: versiones exactas. Se generó en Windows con Python 3.12.10 y se verificó también en Linux, al construir la imagen de Docker. Úsalo para reproducir el entorno.

### Configuración de Streamlit

`.streamlit/config.toml` desactiva la telemetría y evita que Streamlit pida un correo en el primer arranque.

## Datos

| Archivo | Descripción |
| --- | --- |
| `train.csv` | Base original del reto Kaggle RSNA 2024 Lumbar Spine Degenerative Classification. El dataset lo describen Richards et al. (2026), *The RSNA LumbarDISC Dataset*, Radiol AI, doi:10.1148/ryai.250480. Licencia de redistribución: [completar] |
| `train_limpio_imputado.csv` | Generado a partir de `train.csv` por `scripts/analisis_preliminar_exploratorio.R`. Los datos faltantes se imputan con MICE (`mice`, `method = 'polr'`, `m = 1`, `set.seed(123)`). |

Notas sobre la imputación:

- Con `m = 1` se hace una sola imputación, así que los análisis posteriores no reflejan la incertidumbre de los datos imputados. Es una limitación.
- Al usar el archivo imputado, los valores faltantes originales ya no son visibles.
- El agente no imputa datos por su cuenta ni sin consentimiento.

## Scripts de R

Se ejecutan desde la raíz del repositorio, porque leen los CSV desde el directorio de trabajo.

| Orden | Script | Entrada | Salida |
| --- | --- | --- | --- |
| 1 | `scripts/analisis_preliminar_exploratorio.R` | `train.csv` | `train_limpio_imputado.csv` |
| 2 | `scripts/analisis_hipotesis_clusters_regresion.R` | `train_limpio_imputado.csv` | Pruebas de hipótesis, clusters y regresión |

El archivo imputado ya está versionado, así que no hace falta regenerarlo para correr el segundo script.

### Paquetes de R

| Script | Paquetes |
| --- | --- |
| `analisis_preliminar_exploratorio.R` | tidyverse, janitor, naniar, mice, rstatix, ggcorrplot (el script instala los que falten) |
| `analisis_hipotesis_clusters_regresion.R` | tidyverse, factoextra, FactoMineR, vcd, MASS, ordinal, performance, cluster (no instala nada) |

Para instalar los del segundo script:

```r
install.packages(c("tidyverse", "factoextra", "FactoMineR", "vcd",
                   "MASS", "ordinal", "performance", "cluster"))
```

Las versiones de los paquetes de R no están fijadas, y los resultados pueden variar entre versiones.

En Windows, R puede no estar en el PATH de Git Bash. Se puede correr un script desde RStudio, o con la ruta completa, por ejemplo `"/c/Program Files/R/R-4.6.0/bin/Rscript.exe" scripts/analisis_preliminar_exploratorio.R` (comprueba la ruta en tu equipo).

## Arquitectura y decisiones

- **Modelo:** API de Gemini (`gemini-3.6-flash`). Se descartó la cuantización local (por ejemplo Mistral Q4_K_M) por la alta latencia en hardware estándar y la posible pérdida de precisión al generar código en R. La API no consume VRAM local y se usan bases anonimizadas (Kaggle RSNA), por lo que el riesgo de exponer datos personales de salud es nulo.
- **Interfaz:** dashboard en Streamlit (`app.py`) y versión de consola (`main.py`).
- **Capa de datos (RAG tabular):** indexación local. El agente recibe nombres de columnas, un resumen estadístico y frecuencias de las primeras variables según la consulta, no el archivo completo.
- **Errores:** en `main.py`, límite de tasa con espera de 10 segundos y reintento, y validación del archivo (existencia y formato). Si el agente devuelve texto en vez de código, se le pide corregir.
- **Credenciales:** en `.env`, leídas con `python-dotenv`.

### Versionado de prompts

- **v1:** rol estadístico general. Problema: el agente se negaba a responder al detectar la palabra "pacientes" por filtros de seguridad.
- **v2:** rol específico de Bioestadístico Clínico con directivas explícitas para asumir escenarios teóricos de investigación. Resultado: flujo continuo sin ruptura de personaje. Problema detectado después: los informes HTML traían p-valores, odds ratios, intervalos, pseudo R² y MAE con tres decimales sin que el agente hubiera ejecutado nada, y uno se basaba en un dataset sintético presentado como "120 pacientes".
- **v3:** regla de veracidad. El agente no puede ejecutar R ni calcular sobre el archivo completo; se le prohíbe inventar resultados numéricos, generar datos sintéticos sin que se pida, usar predictores ordenados en `polr` y hablar de progresión en datos transversales. Resultado en una corrida de cuatro pruebas (informe HTML, p-valores, código `polr`, interpretación de un OR): el informe marcó las cifras como `[pendiente: ejecutar el script]` y no contenía resultados numéricos, y el agente no dio cifras en las demás. Corridas registradas desde la v3: informe HTML en 2 corridas (la segunda desde el contenedor de Docker), sin cifras de resultados; petición de p-valores y OR en 2 corridas (app y consola), sin cifras; código `polr` e interpretación de un OR en 1 corrida cada una, sin cifras inventadas y con predictores no ordenados. En una respuesta sobre pseudo R² el agente dio un "0.25" como ejemplo de MAE, un valor hipotético muy cercano al real. Con tan pocas corridas, esto indica que la regla ayuda pero no demuestra que sea fiable.
- **v4:** se agrega "no finjas recordar conversaciones anteriores", porque en una prueba el agente saludó como si ya hubiera hablado con el usuario. En la primera prueba posterior no lo repitió, pero en una corrida del 14 de noviembre volvió a abrir con "qué gusto saludarte de nuevo", así que la regla no es fiable (1 de 4 corridas registradas de las preguntas de simetría y pseudo R² lo repitió).
- **v5:** se agrega una regla sobre la prueba de simetría bilateral, tras verificar en R el código que entregó el agente (ver [Verificación de resultados](#verificación-de-resultados)): debe usar `mcnemar.test(tabla)` (en tablas k x k es la prueba de simetría de Bowker) y no `MHChisqTest`, que es una prueba de tendencia lineal. Resultado (n = 2 corridas de la pregunta de simetría): las dos usaron `mcnemar.test` y ninguna `MHChisqTest`, y su código reprodujo χ² = 0.59109, df = 3, p = 0.8985 (la segunda solo se ejecuta tras cargar `df`).
- **v6:** regla sobre el pseudo R², tras verificar que `rcompanion::nagelkerke()` no admite modelos `MASS::polr` y devuelve `NA`: debe ajustar el mismo modelo con `ordinal::clm` y aplicar `nagelkerke()` sobre él, o calcular los índices a mano con `logLik`. Resultado (n = 2 corridas de la pregunta de pseudo R²): las dos evitaron `nagelkerke()` sobre `polr` y usaron `clm` y `logLik`; su código reprodujo McFadden 0.358489, Cox-Snell 0.409133, Nagelkerke 0.531651 y MAE 0.2537.
- **v7:** reglas sobre el código R y sobre el saludo, tras las corridas con n = 2: (1) al convertir variables de severidad a factor, fijar `levels` con `Normal/Mild` primero, sin `ordered` en los predictores, y decir cuál es la categoría base al interpretar los OR; (2) el script debe leer el CSV sin dejar la línea comentada y no suponer objetos como `df`; (3) si instala paquetes, indicar el mirror de CRAN; y se prohíben expresiones como "de nuevo" o "como recordarás". Resultado (n = 1 corrida de la pregunta de pseudo R²): sin saludo de "de nuevo"; código autosuficiente que se ejecutó sin cargar `df` y con mirror; referencia `Normal/Mild`, con OR de 5.286 y 27.555 (izquierda) y 4.829 y 19.514 (derecha); y los mismos pseudo R² (0.358489 / 0.409133 / 0.531651) y MAE de 0.2537. Falta repetir la prueba para saber si es consistente.

Las reglas están en `app.py` y en `main.py` (dos copias que deben mantenerse iguales).

## Habilidades y restricciones del agente

Habilidades: identificar variables y su nivel de medición, evaluar datos faltantes o inconsistentes, validar supuestos (normalidad, homocedasticidad), elegir pruebas paramétricas o no paramétricas, interpretar p-valores e intervalos de confianza en contexto clínico, y generar código en R (tidyverse).

Rutas: si el usuario no especifica el tipo de variable, el agente debe detener el análisis y preguntar; si se violan supuestos, busca pruebas no paramétricas; termina cuando entrega código R con su interpretación.

Restricciones: no da consejos médicos ni diagnósticos, no imputa sin consentimiento, no sugiere pruebas paramétricas sin comprobar supuestos, no sugiere promedios para variables ordinales o cualitativas, y los códigos que entrega deben verificarse manualmente.

## Limitaciones conocidas

- **El agente no ejecuta R ni calcula sobre el archivo completo.** Las cifras de un informe generado por el agente no están respaldadas por una corrida real salvo que se hayan ejecutado y pegado. Los informes de `informes/` generados con versiones anteriores del prompt (v2) pueden contener cifras no verificadas.
- La regla de veracidad reduce el problema, pero un modelo de lenguaje puede incumplirla. Verifica antes de citar.
- A veces el agente asume predictores o contexto sin preguntar, o responde con un script cuando faltaba información.
- **El código R del agente puede no ejecutarse o no hacer lo que dice.** Ejemplo verificado: llamó "McNemar-Bowker" a una función que no acepta el argumento usado y que además es otra prueba. Ejecuta y revisa cada script antes de usarlo.
- **Nivel de referencia de los factores.** En las dos corridas de la pregunta de pseudo R² el agente convirtió los predictores con `factor()` sin fijar `levels`, así que R tomó `Moderate` como referencia (orden alfabético) y los OR no coinciden con la explicación escrita. Al leer una tabla de `polr`, comprueba cuál es la categoría base. La regla v7 lo corrigió en la única corrida probada.
- **El código del agente no siempre es autosuficiente.** En una corrida dejó comentada la línea que lee el CSV y usó un objeto `df` que no existía (en R base `df` es una función, y el error resultante es confuso). En otra instaló paquetes con `install.packages()` sin indicar el mirror de CRAN, lo que falla en sesiones no interactivas (`Rscript`, contenedores) aunque funcione en RStudio. La v7 corrigió ambos casos en la única corrida probada.
- La librería `google-generativeai` ya no recibe actualizaciones; el reemplazo es `google-genai`. Migración pendiente.
- El tiempo de respuesta varía (a veces tarda varios segundos), porque cada consulta viaja a la API con el historial de la conversación.
- Las versiones de los paquetes de R no están fijadas, y la imputación usa `m = 1`.
- Docker: la imagen cubre solo la app de Streamlit. La versión de consola (`main.py`) es interactiva y pide un archivo por ruta, así que no está pensada para el contenedor. No hay pruebas automáticas ni integración continua.

## Verificación de resultados

Antes de citar una cifra del agente, ejecútala en R con el archivo correspondiente y anota la comparación:

| Fecha | Archivo | Cifra del informe | Valor al ejecutar en R | ¿Coincide? |
| --- | --- | --- | --- | --- |
| 2026-11-13 | train_limpio_imputado.csv | Simetría L4-L5 foraminal (informe v2): χ² = 4.12, df = 3, p = 0.248 | `mcnemar.test`: χ² = 0.591, df = 3, p = 0.8985 | No |
| 2026-11-13 | train_limpio_imputado.csv | OR subarticular izquierda (informe v2): Moderate 3.86, Severe 17.99 | 5.286 y 27.555 (`polr`, predictores no ordenados) | No |
| 2026-11-13 | train_limpio_imputado.csv | OR subarticular derecha (informe v2): Moderate 2.94, Severe 11.59 | 4.829 y 19.514 | No |
| 2026-11-13 | train_limpio_imputado.csv | MAE (informe v2): 0.26 | 0.2537 (predecir siempre la moda da 0.3782) | Aproximado; el informe no daba línea base |
| 2026-11-13 | train_limpio_imputado.csv | Código del agente: `MHChisqTest(tabla, fitted = TRUE)` como "McNemar-Bowker" | Error `unused argument`; la función es la prueba de tendencia lineal de Mantel-Haenszel (X² = 290.75, df = 1) | No |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente: `nagelkerke(modelo)` sobre un modelo `MASS::polr` | `rcompanion::nagelkerke` no admite `polr` (solo `lm`, `glm`, `clm`, `clmm`, etc.); la tabla de pseudo R² devolvió `NA` y no hubo advertencia. El elemento `$PseudoR2` que usaba el agente tampoco existe (se llama `Pseudo.R.squared.for.model.vs.null`) | No |
| 2026-11-14 | train_limpio_imputado.csv | Pseudo R² (informe v2): McFadden 0.284, Nagelkerke 0.387 | Cálculo manual con `logLik` del modelo y del modelo nulo: McFadden 0.358, Cox-Snell 0.409, Nagelkerke 0.532. Confirmado con `nagelkerke()` sobre un modelo `ordinal::clm` equivalente (mismo `logLik`, −929.7964): 0.358489, 0.409133, 0.531651 | No |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente para la pregunta de simetría (prompt v5): `mcnemar.test(tabla)` | Ejecutado de extremo a extremo: χ² = 0.59109, df = 3, p = 0.8985, igual al valor verificado | Sí |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente para la pregunta de pseudo R² (prompt v6): índices vía `clm` y MAE | Ejecutado de extremo a extremo: 0.358489 / 0.409133 / 0.531651 y MAE 0.2537, iguales a los valores verificados | Sí |
| 2026-11-14 | train_limpio_imputado.csv | Mismo código: coeficientes y OR de `polr` | `factor()` sin `levels` ordena alfabéticamente y la referencia queda en `Moderate` (OR de `Normal/Mild` 0.19 y de `Severe` 5.21 respecto a `Moderate`), no en `Normal/Mild` como supone la explicación del agente. El ajuste es equivalente, pero la interpretación escrita no corresponde a la tabla | No |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente, segunda corrida de la pregunta de simetría | Ejecutado cargando `df` antes (el código deja comentada la lectura del CSV): χ² = 0.59109, df = 3, p = 0.8985; Kappa 0.2510 sin ponderar y 0.3076 ponderado, iguales a un cálculo manual sobre la misma tabla | Sí |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente, segunda corrida de la pregunta de pseudo R² | Ejecutado cargando `df`: McFadden 0.3585 (0.358489 con `clm`), Cox-Snell 0.409133, Nagelkerke 0.531651 y MAE 0.2537; los OR salen otra vez respecto a `Moderate` | Sí en los índices; No en la referencia |
| 2026-11-14 | train_limpio_imputado.csv | Código del agente con el prompt v7 (pregunta de pseudo R², n = 1) | Ejecutado sin cargar `df` antes: referencia `Normal/Mild`; OR 5.286 y 27.555 (izquierda), 4.829 y 19.514 (derecha); McFadden 0.3585 (0.358489 con `clm`), Cox-Snell 0.409133, Nagelkerke 0.531651; MAE 0.2537; deviance 1859.593 y AIC 1871.593, iguales a los del modelo con otra referencia | Sí |

Los pseudo R² se calcularon aparte, en la consola de RStudio (fórmulas: McFadden = 1 − ll1/ll0; Cox-Snell = 1 − exp(2/n·(ll0 − ll1)); Nagelkerke = Cox-Snell / (1 − exp(2/n·ll0)), con n = 1 975).

El script que hizo la parte restante de esta verificación es `scripts/verificacion_codigo_agente.R` (R 4.6.0, DescTools 0.99.60, rcompanion 2.5.4, MASS 7.3.65). Las cifras del informe v2 salen de `informe_clinico (1).html`, generado con la versión v2 del prompt; el modelo del informe usaba predictores ordenados y el de la verificación no, así que la comparación de los OR es indicativa.

## Estructura del repositorio

| Carpeta o archivo | Contenido |
| --- | --- |
| `app.py`, `main.py` | Dashboard en Streamlit y versión de consola |
| `scripts/` | Scripts de R de análisis exploratorio, imputación y modelado |
| `train.csv`, `train_limpio_imputado.csv` | Datos |
| `informes/` | Informes y anteproyecto |
| `documentacion/` | Protocolo, corpus, banco de preguntas y configuración de NotebookLM (actividad "Nada sin fuente") |
| `fuentes/` | PDF del corpus de estado del arte |
| `experimento/` | Análisis del experimento de fuentes (clasificación de referencias) |
| `entregables/`, `archivo/` | Entregables y memorias consolidadas |
| `referencias/` | Referencias bibliográficas (`referencias.bib`) |
| `Dockerfile`, `.dockerignore` | Imagen de la app de Streamlit |
| `.env.example`, `.gitattributes`, `.gitignore`, `.streamlit/` | Configuración reproducible |

## Problemas frecuentes

- **"Falta GEMINI_API_KEY":** revisa que `.env` exista en la raíz y que la línea sea `GEMINI_API_KEY=tu-clave`, sin comillas ni espacios.
- **Aviso `FutureWarning` de `google.generativeai`:** esperado; ver Limitaciones.
- **"No se pudo leer el archivo" en `main.py`:** el nombre debe existir en la carpeta actual y terminar en `.csv`, `.xlsx` o `.xls`.
- **Error al subir un archivo en la app:** acepta `.csv`, `.xlsx` y `.xls`.
- **`R: command not found` en Git Bash:** usa RStudio o la ruta completa de `Rscript.exe`.
- **`docker exec ... ls /app` falla en Git Bash con una ruta de `C:/Program Files/Git/...`:** Git Bash convierte las rutas que empiezan con `/`. Usa `//app` o antepón `MSYS_NO_PATHCONV=1`.
- **La clave no llega al contenedor:** `--env-file` no quita comillas; la línea de `.env` debe ser `GEMINI_API_KEY=tu-clave`.
- **`docker exec` dice `No such container`:** el contenedor se ejecutó en primer plano y se detuvo con Ctrl+C. Usa `docker run -d`.
