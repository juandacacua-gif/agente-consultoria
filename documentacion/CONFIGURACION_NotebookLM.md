# Configuración de NotebookLM usada en el banco de preguntas

**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia
**Fecha de esta hoja:** 17 de octubre de 2026

Esta hoja describe con qué se ejecutó el banco de 18 preguntas, para que se pueda reproducir. Los datos marcados [PENDIENTE] solo los pueden completar los integrantes; no se inventan.

## 1. Cuenta y entorno

* **Cuenta de Google usada:** cuenta personal.
* **Plan de NotebookLM:** gratuito.
* **Nombre del notebook:** "MRM Enhanced Evaluation of Lumbar Stenosis and Root Compression" (parece el título del primer documento cargado, Al-Tameemi et al., y no un nombre elegido para este proyecto).
* **Quién ejecutó las 18 preguntas y cuándo:** Camilo Velandia, 17 de octubre de 2026 (las respuestas literales están en `entregables/respuestas_notebooklm_2026-10-17.pdf`). [PENDIENTE: hora o confirmar que todas fueron el mismo día].

## 2. Documentos cargados durante la ejecución

Total: 10 fuentes (confirmado por Camilo el 17-oct-2026). Captura de la lista: `documentacion/captura_notebooklm_fuentes_2026-10-17.png`.

| # | Fuente | Observación |
|---|---|---|
| 1 | Richards et al. (2026), LumbarDISC | PDF completo |
| 2 | Cai et al. (2020), biomecánica L4–L5 | PDF completo |
| 3 | Trento et al. (2025), *Medicina* | PDF completo |
| 4 | Trînc et al. (2026), "Beyond Accuracy" | Preprint sin revisión por pares |
| 5 | Al-Tameemi et al. (2017) | PDF completo |
| 6 | Bagley et al. (2019) | PDF completo |
| 7 | Miskin et al. (2021) | **El notebook tenía una versión de una sola página (el resumen), no el artículo de 11 páginas.** El PDF completo está en `fuentes/` desde el commit `deecb27`, pero no se cargó de nuevo en NotebookLM |
| 8 | Abdelrahman et al. (2026) | PDF completo |
| 9 | Chai et al. (2026) | PDF completo |
| 10 | Zhao y Zhu (2026), *European Spine Journal* | PDF completo |

[PENDIENTE: confirmar en la captura que las demás fuentes (1 a 6 y 8 a 10) son los PDF completos y no resúmenes.]

**Consecuencia para los resultados:** las respuestas de NotebookLM que citan a Miskin (por ejemplo, la pregunta 13) se basan en el resumen de una página. Los cuatro kappas (0,702, 0,544, 0,557 y 0,323) están en ese resumen, así que la respuesta es correcta, pero las páginas de la revista que aparecen en `TRAZABILIDAD_estado_del_arte.md` (1490 impresa, p. 6 del PDF completo) vienen del PDF completo y no de lo que NotebookLM tenía cargado.

## 3. Desde cuándo está cargado cada documento

* Miskin et al.: la primera versión se cargó **un día después** de la consulta de la semana 2 que produjo el fallo documentado (NotebookLM citó los kappas cuando el PDF aún no estaba). Confirmado por Juan David.
* Las demás fuentes: [PENDIENTE: fecha de carga de cada una; en NotebookLM se ve en el panel de fuentes o en el historial].

## 4. Dónde van las instrucciones

* Las instrucciones están en la **configuración del chat del notebook**. Texto exacto, copiado tal cual por Camilo el 17-oct-2026:

> La configuración del chat en Gemini Notebook opera bajo los siguientes parámetros y principios fundamentales:
> Idioma y estilo de respuesta: Responde en el mismo idioma en el que realizas la consulta (en este caso, español de América Latina) con un formato estructurado, claro y sin textos de relleno.
> Anclaje estricto en fuentes (Source Grounding): Todas las explicaciones y afirmaciones sobre el tema de estudio se fundamentan exclusivamente en los 11 documentos cargados en este cuaderno, acreditando la información mediante citas explícitas [i].
> Veracidad y no extrapolación: Si un dato o cifra específica no está presente en los documentos cargados, el sistema lo declara de forma transparente en lugar de complementar con información externa no verificable.
> Capacidades integradas:
> Búsqueda semántica cruzada: Localización precisa de pasajes y tablas tanto en texto como en representaciones visuales dentro del cuaderno.
> Creación de artefactos (Content Studio): Capacidad para estructurar e independizar entregables como reportes detallados, presentaciones de diapositivas, infografías, mapas mentales, pódcasts de audio o guías de estudio.
> Análisis y computación cuantitativa: Entorno de ejecución para procesamiento de datos o generación de gráficos de alta precisión cuando se requiera.

**Diferencias con el protocolo v1.0 (importante):**
* El texto configurado **no es el protocolo v1.0**: no contiene el rol de consultor bioestadístico, ni el formato de cita `[Autor, Año] + (Documento, Página)`, ni la frase fija de abstención. Pide citas `[i]` (numeradas) y que se declare cuando un dato no está.
* Dice **11 documentos**, pero el corpus evaluado es de **10**. Camilo confirmó (17-oct-2026) que el notebook tiene 10 fuentes y que no se agregó nada fuera de los 10 documentos de `fuentes/`. El "11" del texto de instrucciones está desactualizado.
* **Cómo se hicieron las preguntas:** Camilo tomó cada una de las 18 del banco de preguntas y la pegó sola en el chat de NotebookLM, sin el texto del protocolo v1.0. Por lo tanto **el protocolo v1.0 no se ejecutó**: se aplicó solo la configuración del chat de arriba. Las respuestas del banco no se deben presentar como "protocolo v1.0 aplicado", y el protocolo v1.1 describe este procedimiento real.

## 5. Control

Las mismas 18 preguntas se aplicaron en Claude.ai **sin documentos adjuntos y con búsqueda web**. No es un chat sin fuentes en sentido estricto. Clasificación en `entregables/banco_control_sin_documentos.xlsx`.

## 6. Cambios hechos al notebook después de la ejecución

Ninguno hasta la fecha de esta hoja. Si se reemplaza el PDF de Miskin en NotebookLM por el completo, se debe anotar aquí la fecha y no repetir el banco sin declararlo.
