# Documentación de la app: Consultor Bioestadístico Clínico AI

Última revisión: 2026-11-18 (incluye el ejecutor de R aislado).

Este documento explica qué hace la app, cómo funciona y cuál es la función de cada una de sus partes. Para instalarla y ejecutarla, ver el [README](../README.md).

## 1. Qué es

Es una aplicación web, hecha con Streamlit, que funciona como un **consultor bioestadístico asistido por IA**. La persona sube una tabla de datos clínicos (CSV o Excel) y conversa con un modelo de lenguaje (Gemini) que:

- identifica los tipos de variables y su nivel de medición;
- recomienda pruebas estadísticas adecuadas y comprueba si se cumplen sus supuestos;
- entrega **código en R** para ejecutar el análisis;
- explica cómo interpretar los resultados (p-valores, odds ratios, intervalos de confianza, pseudo R², etc.);
- puede redactar un informe formal en HTML.

### Lo que la app NO hace

- **El modelo no ejecuta R.** La app recibe el código y lo ofrece como descarga (`script_analisis.R`). Si se levanta con `docker compose`, también ofrece un botón que lo ejecuta en un contenedor aparte, sin internet ni clave, solo después de que la persona lo revise y lo confirme. El resultado se muestra en pantalla y **no se le devuelve al modelo**. Sin ese contenedor, hay que ejecutar el script en el propio R. En ambos casos, la persona debe revisar el resultado.
- **La app no calcula pruebas estadísticas.** Lo único que calcula son resúmenes descriptivos con pandas (conteos, promedios, frecuencias); las pruebas las hace R.
- **No da diagnósticos médicos.** El prompt del agente se lo prohíbe.
- **No imputa datos faltantes** por su cuenta. El prompt le prohíbe hacerlo sin consentimiento del usuario.
- **No guarda datos en un servidor.** El archivo subido y la conversación viven en la memoria de la sesión del navegador.

## 2. Para quién está pensada

Para investigadores y médicos que analizan bases de datos clínicas y necesitan orientación metodológica y código en R. El prompt la especializa en radiología y patologías espinales, y todas las pruebas del proyecto se hicieron con variables de severidad ordinal (estenosis lumbar, reto RSNA 2024). Con otros tipos de datos no se ha probado.

Requiere criterio estadístico: el código que entrega el agente puede tener errores que solo se detectan sabiendo de estadística (ver [Límites y verificación](#9-límites-y-verificación)). Por eso es una herramienta de apoyo para profesionales, no un reemplazo del análisis.

## 3. Cómo funciona, de principio a fin

```
Persona ──► Interfaz Streamlit (app.py) ──► API de Gemini
   ▲              │  ▲                          │
   │              │  └────── respuesta ◄────────┘
   │              ├─ pandas: lee el CSV/Excel y calcula resúmenes descriptivos
   │              ├─ indexación local ("RAG tabular"): añade resúmenes del dataset al mensaje
   │              ├─ extrae los bloques ```r y ```html de la respuesta → botones de descarga
   │              └─ (opcional, con docker compose) envía el código R al ejecutor aislado: R sin red
   │
   └─ revisa el código, lo ejecuta (en el ejecutor aislado o en su R) y VERIFICA los resultados
```

Paso a paso:

1. **Arranque.** La app lee la clave `GEMINI_API_KEY` del archivo `.env`. Si no hay clave, muestra un aviso y se detiene hasta que se escriba en el menú lateral.
2. **Carga de datos.** La persona sube un archivo en el menú lateral. La app lo lee con pandas (`read_csv` o `read_excel`).
3. **Exploración opcional.** Un panel plegable muestra la tabla y un resumen visual del dataset (ver sección 4).
4. **Consulta.** La persona escribe una pregunta o pulsa uno de los botones de sugerencias.
5. **Armado del mensaje.** La app construye el texto que se envía al modelo: la pregunta, más (si hay datos) el contexto del dataset (ver sección 6).
6. **Respuesta.** Gemini responde con explicación y, normalmente, código en R. La app muestra la respuesta, la guarda en la conversación y busca bloques de código.
7. **Descarga.** Si hay un bloque de R, aparece el botón de descarga de `script_analisis.R`; si hay un bloque HTML, el de `informe_clinico.html`.
8. **Ejecución opcional en el contenedor aislado.** Si la app se levantó con `docker compose`, bajo el chat aparece el panel "Ejecutar el código R": la persona lee el código, pulsa el botón y la app lo envía, junto con el archivo cargado, al ejecutor. Allí corre sin internet y sin la clave, con límites de tiempo y memoria, y la app muestra la salida, los errores y los archivos generados.
9. **Verificación.** La persona revisa el código y los resultados antes de usarlos: que el ejecutor devuelva una salida sin errores no garantiza que el análisis sea correcto.

## 4. Las partes de la interfaz

| Parte | Dónde | Qué hace |
| --- | --- | --- |
| Título y descripción | Parte superior | Presenta la app: "Consultor Bioestadístico Clínico AI" |
| Campo de clave de API | Menú lateral, "Configuración" | Campo de contraseña. Si `.env` tiene `GEMINI_API_KEY`, aparece ya rellenado |
| Cargador de archivos | Menú lateral, "Datos" | Acepta `.csv`, `.xlsx` y `.xls` |
| Exportar sesión | Menú lateral, aparece tras el primer mensaje | Botón "Descargar Historial (.md)": baja la conversación como Markdown, con fecha y nombre del dataset |
| Exploración preliminar | Panel plegable (cerrado por defecto) | Dos pestañas: tabla de datos y resumen visual |
| Pestaña "Tabla de Datos" | Dentro de la exploración | Primeras 10 filas del dataset |
| Pestaña "Resumen Visual" | Dentro de la exploración | Métricas generales (filas, columnas, datos faltantes) y, para la variable elegida en un selector, su distribución |
| Historial del chat | Centro | Muestra los mensajes de la sesión |
| Sugerencias de análisis | Sobre la caja de texto | Tres botones con consultas predefinidas (sección 5) |
| Caja de consulta | Parte inferior | "Escribe tu propia consulta estadística..." |
| Botones de descarga | Bajo cada respuesta con código | "Descargar script_analisis.R" y "Descargar informe.html" |
| Panel "Ejecutar el código R" | Al final de la página, tras una respuesta con código R | Muestra el código, el botón "Ejecutar en R (sin red)" y el resultado (salida, mensajes de R y archivos generados). Si no hay ejecutor, avisa y deja el script para descargar |

### Resumen visual de una variable

- Si la variable es **numérica**: promedio, mediana, mínimo y máximo.
- Si es **categórica**: categoría más frecuente (moda), número de categorías y porcentaje de la moda.
- En ambos casos: gráfico de barras con las frecuencias (hasta 20 categorías).

## 5. Botones de sugerencias

| Botón | Consulta que envía |
| --- | --- |
| Sugerir prueba estadística | Recomienda la prueba de hipótesis adecuada para la variable principal de los datos |
| Validar normalidad | Genera el código en R para verificar el supuesto de normalidad de las variables numéricas |
| Generar informe HTML | Hace un análisis completo, interpreta los resultados y redacta el informe formal en HTML |

Nota: las variables de severidad del reto RSNA son ordinales, no numéricas, y por eso las pruebas de normalidad no les aplican. El agente suele advertirlo.

## 6. Qué se envía al modelo (indexación local o "RAG tabular")

El modelo **no recibe el archivo completo**. La app arma, para cada mensaje, un contexto resumido:

| Cuándo | Qué se agrega al mensaje |
| --- | --- |
| Primer mensaje de la sesión con un dataset cargado | Nombre del archivo, número de filas y lista de columnas |
| La consulta contiene palabras como *resumen, estadística, distribución, descriptiva, frecuencia, tabla* | Resumen estadístico (`describe` de pandas) y frecuencias de las cinco primeras columnas |
| La consulta contiene palabras como *columnas, variables, estructura, datos, niveles, lumbares* | Lista de columnas del dataset |

La detección de palabras es una búsqueda simple de texto en minúsculas, así que una palabra común como "datos" activa el contexto de columnas con frecuencia.

El modelo conserva el historial de la conversación dentro de la sesión, y por eso cada consulta nueva viaja con el contexto anterior. Es una de las razones por las que a veces tarda varios segundos.

## 7. El agente: su prompt

El comportamiento del agente se define en un texto de instrucciones (el *system prompt*) que vive en `app.py` y, con diferencias, en `main.py`. Se compone de:

- **Rol:** consultor bioestadístico senior, con tono cálido y cercano, especializado en radiología y patologías espinales.
- **Salida:** código reproducible en R (tidyverse), con la instalación y carga de paquetes; informes en un bloque HTML cuando se piden.
- **Pautas estadísticas:** para variables ordinales recomienda métodos no paramétricos (chi-cuadrada, McNemar-Bowker para simetría bilateral, análisis de correspondencias múltiples, K-medoides y regresión logística ordinal de odds proporcionales), con interpretación de odds ratios, pseudo R² y MAE.
- **Restricciones:** no dar diagnósticos médicos; no imputar sin consentimiento; no sugerir pruebas paramétricas sin comprobar supuestos.
- **Reglas añadidas tras las pruebas (v3 a v7):** no inventar cifras de resultados; no fingir memoria de conversaciones anteriores; usar `mcnemar.test` para simetría; calcular el pseudo R² con `ordinal::clm` o a mano con `logLik`; fijar el nivel de referencia de los factores en `Normal/Mild`; escribir código autosuficiente que lea el CSV y use un mirror de CRAN.

La historia de cada versión, con sus resultados, está en el apartado "Versionado de prompts" del [README](../README.md).

## 8. Piezas del repositorio y su función

| Archivo | Función |
| --- | --- |
| `app.py` | La app de Streamlit: interfaz, indexación local, chat con el modelo, descargas y panel de ejecución de R |
| `main.py` | Versión de consola del mismo agente. Pide un archivo por ruta, mantiene el chat, guarda el código R en `script_analisis.R` y el HTML en `informe_clinico.html`, y espera 10 segundos si la API responde con límite de tasa. Su prompt es más corto que el de `app.py` |
| `requirements.txt` / `requirements.lock.txt` | Dependencias con rangos y con versiones exactas, respectivamente |
| `.env` / `.env.example` | La clave de la API (nunca se sube) y su plantilla |
| `.streamlit/config.toml` | Desactiva la telemetría y la pregunta de correo de Streamlit |
| `Dockerfile` / `.dockerignore` | Imagen de la app: Python 3.12.10, multi-etapa, usuario sin privilegios y chequeo de salud. Incluye `app.py`, `main.py`, `r_runner_client.py` y la configuración de Streamlit; no incluye R |
| `docker-compose.yml` | Levanta la app y el ejecutor de R, y define el aislamiento (red interna sin internet, sistema de archivos de solo lectura, límites de recursos) |
| `r-runner/` | Imagen del ejecutor: R 4.6.0 (`rocker/r-ver`) con los paquetes de R que ha usado el agente (`install_packages.R`) y un pequeño servidor (`runner.py`) que ejecuta el script con `Rscript` |
| `r_runner_client.py` | Cliente con el que la app envía el código y los datos al ejecutor |
| `scripts/probar_ejecutor_r.sh` | Comprueba el aislamiento del ejecutor y su funcionamiento |
| `scripts/analisis_preliminar_exploratorio.R` | Exploración y limpieza de `train.csv`; imputa los faltantes con MICE y escribe `train_limpio_imputado.csv` |
| `scripts/analisis_hipotesis_clusters_regresion.R` | Análisis con `train_limpio_imputado.csv`: pruebas de hipótesis, clusters y regresión (según los paquetes que carga) |
| `scripts/verificacion_codigo_agente.R` | Comprueba en R el código que entregó el agente y reproduce las cifras verificadas |
| `train.csv`, `train_limpio_imputado.csv` | Datos del reto RSNA 2024 y su versión imputada |

El resto del repositorio (`documentacion/`, `fuentes/`, `experimento/`, `entregables/`, `archivo/`, `referencias/`, `linea-base.md`) corresponde a la parte documental y de investigación del proyecto, incluida la actividad "Nada sin fuente" con NotebookLM. No forma parte de la app.

## 9. Límites y verificación

Lo que debe saber quien use la app:

1. **El código del agente no es confiable sin revisar.** En las pruebas se encontraron, entre otros, una función equivocada presentada como prueba de simetría, un modelo cuyo nivel de referencia invertía la lectura de los odds ratios, y scripts que asumían un objeto inexistente. Los detalles y las cifras verificadas están en la tabla "Verificación de resultados" del README.
2. **Que un script corra sin error no prueba que esté bien.** El código con la referencia equivocada corría perfectamente.
3. **El modelo puede incumplir sus propias reglas.** Las reglas del prompt reducen los errores, pero no los eliminan (por ejemplo, volvió a saludar "de nuevo" en una de cuatro corridas registradas).
4. **Los resultados numéricos deben salir de R.** Las cifras que el agente escriba en un informe sin haberlas calculado no valen. Con la regla de veracidad, el agente debe dejarlas como `[pendiente: ejecutar el script]`.
5. **Privacidad.** El contexto descrito en la sección 6 viaja a la API de Gemini. Usa solo datos anonimizados.
6. **Reiniciar la página borra la sesión.** Al recargar el navegador se pierden la conversación y el archivo cargado; conviene descargar el historial antes.
7. **Solo se ofrece el primer bloque de código.** Si la respuesta trae varios bloques de R, el botón de descarga entrega solo el primero.
8. **Formatos.** Solo `.csv`, `.xlsx` y `.xls`. Aunque `pyreadstat` figura en `requirements.txt`, la app no lo usa, así que no lee archivos de SPSS, Stata ni SAS.
9. **El agente puede escribir códigos distintos para la misma pregunta.** Uno puede correr y otro no (por ejemplo, porque pide un paquete que el ejecutor no tiene). Si el ejecutor dice que no puede instalar un paquete, hay que añadirlo a `r-runner/install_packages.R` y reconstruir la imagen.
10. **El ejecutor reduce el riesgo, no lo elimina.** Corre sin internet, sin la clave y con el sistema de archivos de solo lectura, pero comparte una red interna con la app. Por eso el código se muestra y se ejecuta solo cuando la persona lo confirma.

## 10. Flujo de trabajo recomendado

1. Arranca la app (ver el README) y sube el dataset anonimizado.
2. Abre la exploración preliminar y revisa tipos de variables y datos faltantes.
3. Pregunta por el análisis que necesitas, indicando las variables.
4. Descarga `script_analisis.R` y lee el código **antes** de ejecutarlo.
5. Ejecútalo en R, desde la carpeta donde está el CSV.
6. Revisa lo que no se ve a simple vista: qué función usa, cuál es la categoría de referencia de los factores y si los resultados tienen sentido.
7. Para cifras que vayas a citar, compáralas con una segunda vía (por ejemplo, el script `scripts/verificacion_codigo_agente.R` muestra cómo se hizo con las del proyecto) y anótalas en la tabla de verificación del README.
8. Descarga el historial de la sesión si necesitas conservar la conversación.

## 11. Ampliaciones posibles

Se consideraron tres formas de ejecutar el código R desde la app: dentro de la propia app (descartada: el código del modelo correría con los permisos de la app y podría leer la clave de la API), en un contenedor aparte y sin red (la elegida, ver las secciones anteriores) y reemplazar el código libre por funciones propias verificadas que el modelo solo invoque (pendiente).

Mejoras posibles sobre lo implementado: mostrar los gráficos como imagen en la app, devolver el resultado de R al modelo para que lo interprete (solo con confirmación explícita, porque saldrían datos hacia la API de Gemini) y permitir varias ejecuciones seguidas con el mismo archivo.
