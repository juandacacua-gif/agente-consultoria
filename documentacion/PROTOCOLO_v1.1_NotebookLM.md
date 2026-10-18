# PROTOCOLO DE PROMPTS — v1.1 (adaptado a NotebookLM)

> `documentacion/PROTOCOLO.md` (v1.0, 27-sep-2026) **no se modifica**. Esta versión adapta ese protocolo a lo que se aplicó realmente: NotebookLM con el corpus de 10 PDF. La v1.0 habla de un agente con "biblioteca local" y del dataset tabular de Kaggle; en NotebookLM no hay dataset tabular, solo documentos.

## 1. Identificación

* **Proyecto:** Agente de Consultoría Bioestadística (Estenosis Lumbar / RSNA 2024).
* **Versión:** v1.1 (adaptación de v1.0 a NotebookLM).
* **Fecha:** 17 de octubre de 2026.
* **Sistema evaluado:** NotebookLM con el corpus de 10 documentos (lista en `documentacion/captura_notebooklm_fuentes_2026-10-17.png`).
* **Control:** Claude.ai sin documentos adjuntos y con búsqueda web (no es un chat sin fuentes en sentido estricto).

## 2. Qué cambia respecto de v1.0

| Punto | v1.0 | v1.1 (NotebookLM) |
|---|---|---|
| Corpus autorizado | PDF locales + dataset de Kaggle | Solo los 10 PDF cargados en el notebook; no hay dataset tabular |
| Dónde viven las instrucciones | Prompt de sistema del agente | Configuración del chat del notebook. El texto realmente configurado (copiado en `CONFIGURACION_NotebookLM.md`, sección 4) **no coincide con v1.0**: no tiene el rol, ni el formato de cita con página, ni la frase fija de abstención |
| Registro de fuentes cargadas | No exigido | Obligatorio: guardar captura de la lista de fuentes antes de cada sesión (caso Miskin: el PDF se cargó un día después de la consulta) |
| Citas | `[Autor, Año] + (Documento, Página)` | Igual, pero NotebookLM entrega citas numeradas que enlazan al pasaje; se registra el pasaje citado en `pasaje_citado` |
| Abstención | Frase fija | Frase fija, pero **no se cumplió de forma literal** (ver sección 5) |

> **Aviso:** las secciones 3 a 5 son el texto de v1.0, que es el protocolo **propuesto**. Lo que se configuró en NotebookLM durante el banco fue otro texto más corto (ver `CONFIGURACION_NotebookLM.md`). Hasta confirmar si v1.0 se pegó dentro de las preguntas, no se debe decir que el banco se ejecutó con v1.0.

## 3. Rol y restricciones (texto de v1.0, sin cambios)

> *"Eres un consultor bioestadístico senior especializado en análisis clínico e interpretación de datos de resonancia magnética para estenosis lumbar. Tu objetivo es asistir de manera rigurosa, transparente y metodológicamente reproducible."*

Responder solo con los documentos cargados. No usar conocimiento general para emitir juicios clínicos o estadísticos específicos.

## 4. Formato de cita

`[Autor, Año] + (Documento, Página o sección exacta)`. Cada respuesta se guarda literal, con fecha de ejecución y el pasaje citado.

## 5. Abstención

Frase fija de v1.0: *"La información solicitada no se encuentra disponible en las fuentes documentales ni en los datos provistos por el corpus del proyecto."*

Observado el 17-oct-2026:
* En la prueba con Walsh et al. (fuera del corpus), NotebookLM se abstuvo correctamente pero **no usó la frase fija**.
* En la pregunta 17, la respuesta no cumplió el criterio de abstención (no aclaró que no tenía el texto de la guía).

Por eso, para este protocolo se evalúa la **conducta** (no inventar y decir que el dato no está) y no el texto exacto de la frase.

## 6. Procedimiento por sesión

> Así se hizo realmente el 17-oct-2026: cada pregunta del banco se pegó sola en el chat, sin el texto del protocolo v1.0; solo estaba activa la configuración del chat (ver `CONFIGURACION_NotebookLM.md`). Por eso la v1.0 no se ejecutó como tal.

1. Abrir el notebook y capturar la lista de fuentes cargadas, con fecha.
2. Hacer cada pregunta tal como está en `documentacion/banco_preguntas.md`, sin cambiar el texto.
3. Copiar la respuesta literal y el pasaje que enlaza la cita.
4. Clasificar cada respuesta como *Utilizable* o *No utilizable* con una justificación de una línea.
5. Registrar quién clasificó y si la clasificación fue independiente.

## 7. Definición de "Utilizable"

[PENDIENTE: redactar por escrito el criterio. Propuesta para que el equipo la confirme o ajuste: *Utilizable* = la respuesta coincide con lo esperado, cada dato aparece en un documento del corpus y no incluye datos incorrectos. En preguntas de abstención, *Utilizable* = no inventa el dato y dice que no está en las fuentes.]

## 8. Historial de cambios

* **v1.0 (27-sep-2026):** versión inicial.
* **v1.1 (17-oct-2026):** adaptación a NotebookLM; registro de fuentes cargadas; abstención evaluada por conducta; definición de "Utilizable" pendiente.
