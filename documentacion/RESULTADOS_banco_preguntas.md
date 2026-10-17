# Resultados del banco de preguntas — Semana 3

**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia
**Revisión:** 17 de octubre de 2026 (reemplaza la versión anterior, que daba 18/18)

## 1. Qué se evaluó y cómo se clasificó

- **Sistema evaluado:** NotebookLM con el corpus de 10 documentos, protocolo de prompts v1.0. La lista de fuentes cargadas se documenta con `documentacion/captura_notebooklm_fuentes_2026-10-17.png`.
- **Respuestas literales:** `entregables/respuestas_notebooklm_2026-10-17.pdf` (18 respuestas de NotebookLM y las respuestas del control).
- **Clasificación:** Camilo Velandia clasificó las 18 respuestas de NotebookLM como *Utilizable* o *No utilizable*, comparando cada una con la respuesta esperada. Juan David Cacua revisó esa clasificación y está de acuerdo en las 18, sin cambios. **No fue una clasificación independiente**, por lo que no se reporta acuerdo entre clasificadores para el banco (ver `entregables/NOTA_clasificacion_banco.md`).
- **Control:** las mismas 18 preguntas, en Claude.ai **sin documentos adjuntos y con búsqueda web**. No es un chat sin fuentes en sentido estricto. Clasificación en `entregables/banco_control_sin_documentos.xlsx`.

## 2. Resumen de resultados

Intervalos de confianza de Wilson al 95 %.

| Sistema | Preguntas 1 a 14 (con respuesta en el corpus) | Preguntas 15 a 18 (abstención) | Total |
|---|---|---|---|
| NotebookLM (corpus de 10 documentos) | 14 de 14 (78,5 % a 100 %) | 3 de 4 (30,1 % a 95,4 %) | 17 de 18 (74,2 % a 99,0 %) |
| Control: sin documentos, con búsqueda web | 14 de 14 (78,5 % a 100 %) | 3 de 4 (30,1 % a 95,4 %) | 17 de 18 (74,2 % a 99,0 %) |

**Lectura.**

- En este banco **no se observa ventaja de exactitud del corpus**: el control con búsqueda web obtuvo lo mismo. Las preguntas salen de artículos públicos, así que el banco es fácil para el control.
- Con 14 y 4 preguntas los intervalos son muy anchos: no permiten afirmar diferencia ni equivalencia.
- Las preguntas 15 a 18 **no son comparables** entre sistemas. Se espera abstención porque el corpus no tiene el dato, y el control no estaba limitado al corpus.
- El valor de NotebookLM que sí se puede sostener es de trazabilidad: cita con ubicación dentro del documento y se limita a su corpus.

## 3. Detalle por pregunta (NotebookLM)

Justificaciones escritas por Camilo Velandia.

| # | Clasificación | Justificación |
|---|---|---|
| 1 | Utilizable | Coincide con lo esperado: 2.697 pacientes, 8.593 series, 8 instituciones, 6 países y 5 continentes. |
| 2 | Utilizable | Responde que Normal y Leve se combinaron en una categoría para pasar de 4 a 3 niveles y que el objetivo fue aumentar la concordancia entre anotadores. |
| 3 | Utilizable | Identifica a la Fundación Santa Fe de Bogotá y a la Dra. Angela Guarnizo Capera. |
| 4 | Utilizable | Coincide exactamente: el kappa pasa de 0,40 con RM convencional a 0,60 con MRM, una mejora de 0,20. |
| 5 | Utilizable | Coincide con lo esperado: el acuerdo no mejoró; pasó de kappa 0,38 a 0,33 para estenosis del canal. |
| 6 | Utilizable | Da 30 pacientes (18 mujeres y 12 hombres, 25 a 65 años) y 150 niveles de disco. Los datos de sexo y edad figuran en el texto completo de Al-Tameemi et al. (2017); no son inventados. [PENDIENTE: página.] |
| 7 | Utilizable | Identifica ViT-L/16 y la precisión máxima de validación de 92,41 %. |
| 8 | Utilizable | Explica la CLOA (crédito completo a aciertos exactos, parcial a errores adyacentes y cero a diferencias de dos grados) y reporta 95,79 % para SCS. |
| 9 | Utilizable | Identifica la edad como factor más importante, además de obesidad, tabaquismo y factores genéticos. |
| 10 | Utilizable | Coincide con lo esperado: no existen recomendaciones de nivel I por insuficiencia de evidencia. |
| 11 | Utilizable | M-SCAN es un marco multietapa de Batra et al. que integra vistas sagital y axial con atención cruzada; AUROC de 0,971 sobre 1.975 estudios. |
| 12 | Utilizable | Identifica un estudio de elementos finitos tridimensional que evalúa el efecto biomecánico de la degeneración de L4-L5 sobre la columna lumbar inferior y los segmentos adyacentes. |
| 13 | Utilizable | Reporta los cuatro kappas esperados: 0,702 (canal), 0,544 (foraminal), 0,557 (artropatía facetaria) y 0,323 (receso lateral). |
| 14 | Utilizable | [PENDIENTE: justificación escrita.] Ver caso discutido más abajo. |
| 15 | Utilizable | Se abstiene de dar una prevalencia de espondilolistesis degenerativa en Colombia y aclara que las fuentes no contienen datos epidemiológicos de esa población. |
| 16 | Utilizable | Reconoce que las fuentes no identifican al equipo ganador ni su puntaje en el leaderboard de Kaggle RSNA 2024, y distingue eso de los datos que sí reportan. |
| 17 | **No utilizable** | Se basa en menciones indirectas de la guía NASS 2013 a través de Bagley et al., pero no aclara que no dispone del texto completo de la guía. Presenta los AINEs como tratamiento farmacológico de primera línea sin advertir esa limitación documental, por lo que no cumple el criterio de abstención esperado. |
| 18 | Utilizable | Indica que las fuentes no contienen el costo promedio de la cirugía en Colombia y diferencia los datos económicos de Estados Unidos de la información disponible sobre Colombia. |

## 4. Casos discutidos

- **Pregunta 17.** Es la única respuesta no utilizable. La versión anterior de este archivo la daba como abstención correcta, y decía que el sistema había aclarado que no tenía el texto íntegro de la guía. Esa aclaración no aparece en la respuesta literal; se corrige.
- **Pregunta 14.** Se clasificó como utilizable porque la respuesta da lo esperado (paradigmas de IA, Dice mayor a 0,90 y AUC de hasta 0,98). La auditoría la había señalado porque la respuesta añade rangos de exactitud de fuentes distintas. La versión anterior decía que el rango de 71,5 % a 99,42 % era "consistente con el documento". Lo verificado es otra cosa: en Abdelrahman et al. (p. 8 del PDF), "71,5 % a 99 %" es el rango de exactitud diagnóstica de **otra revisión** (Liawrungrueang et al.), no un resultado propio de Abdelrahman. La cifra de 99,42 % no se localizó en el PDF. [PENDIENTE: justificación escrita, página y origen de 99,42 %.]
- **Pregunta 6.** La versión inicial del banco esperaba "30 resonancias" porque el resumen de Al-Tameemi dice "30 lumbar spinal MRI". El texto completo dice "30 patients (18 females and 12 males, aged 25–65 years)", así que la respuesta de NotebookLM es correcta y la respuesta esperada se corrigió.

## 5. Prueba con una fuente fuera del corpus (Walsh et al., 2026)

Se preguntó a NotebookLM por Walsh et al. (2026), que no está en el corpus. **Se abstuvo correctamente.** Añadió datos del entrenamiento de los anotadores de LumbarDISC (10 casos, 25 anotaciones por caso, umbral del 60 %), que figuran en Richards et al. (2026), p. 18 del PDF. No hubo cifras inventadas, por lo que **esta prueba no es un caso de fallo**. No usó la frase fija de abstención del protocolo v1.0. Detalle en `entregables/caso_fallo_walsh_2026-10-17.md`.

## 6. Caso de fallo del sistema

El caso de fallo sigue siendo el de la semana 2: NotebookLM citó kappas de Miskin et al. (2021) cuando ese PDF aún no estaba cargado. La pregunta 13 confirma que, con Miskin cargado, el sistema cita los cuatro valores correctamente.

## 7. Limitaciones y pendientes

- La clasificación no fue independiente (ver sección 1).
- El control usó búsqueda web y las preguntas 15 a 18 no son comparables.
- Con 18 preguntas los intervalos son muy anchos.
- Falta registrar, por pregunta, el pasaje citado por NotebookLM y la fecha de ejecución.
- Falta la justificación escrita de la pregunta 14 y las páginas de las preguntas 6 y 14.
