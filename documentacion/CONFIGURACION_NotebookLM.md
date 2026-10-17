# Configuración de NotebookLM usada en el banco de preguntas

**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia
**Fecha de esta hoja:** 17 de octubre de 2026

Esta hoja describe con qué se ejecutó el banco de 18 preguntas, para que se pueda reproducir. Los datos marcados [PENDIENTE] solo los pueden completar los integrantes; no se inventan.

## 1. Cuenta y entorno

* **Cuenta de Google usada:** [PENDIENTE: cuenta (correo) con la que se creó el notebook].
* **Plan de NotebookLM:** [PENDIENTE: gratuito o de pago].
* **Nombre del notebook:** [PENDIENTE].
* **Quién ejecutó las 18 preguntas y cuándo:** Camilo Velandia, 17 de octubre de 2026 (las respuestas literales están en `entregables/respuestas_notebooklm_2026-10-17.pdf`). [PENDIENTE: hora o confirmar que todas fueron el mismo día].

## 2. Documentos cargados durante la ejecución

Total: 10 fuentes. Captura de la lista: `documentacion/captura_notebooklm_fuentes_2026-10-17.png`.

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

* NotebookLM no tiene un "prompt de sistema" como un agente propio. Las instrucciones del protocolo v1.1 (`documentacion/PROTOCOLO_v1.1_NotebookLM.md`) se aplican por [PENDIENTE: indicar si se pegaron en la configuración del chat del notebook o al inicio de cada conversación].
* **Texto exacto usado:** [PENDIENTE: pegar aquí el texto tal como se escribió].

## 5. Control

Las mismas 18 preguntas se aplicaron en Claude.ai **sin documentos adjuntos y con búsqueda web**. No es un chat sin fuentes en sentido estricto. Clasificación en `entregables/banco_control_sin_documentos.xlsx`.

## 6. Cambios hechos al notebook después de la ejecución

Ninguno hasta la fecha de esta hoja. Si se reemplaza el PDF de Miskin en NotebookLM por el completo, se debe anotar aquí la fecha y no repetir el banco sin declararlo.
