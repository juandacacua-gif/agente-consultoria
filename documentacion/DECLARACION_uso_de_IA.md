# Declaración de uso de IA — Actividad "Nada sin fuente"

**Juan David Cacua y Camilo Velandia** · Consultoría Bioestadística Aplicada a la Radiología
para el Diagnóstico Lumbar · Universidad Santo Tomás

**Revisión del 17 de octubre de 2026** (corrige afirmaciones que el trabajo posterior mostró demasiado fuertes).

---

## 1. Qué partes del trabajo se hicieron con ayuda de IA

El proyecto usó inteligencia artificial en dos niveles distintos, que conviene no mezclar:

1. **El agente de consultoría bioestadística** (`gemini-3.6-flash`, vía API), construido por el
   equipo como el objeto de estudio del anteproyecto original — recomendó pruebas estadísticas,
   código en R y pasos de análisis para el dataset RSNA LumbarDISC.
2. **Claude (Anthropic)**, usado durante esta actividad como asistente de trabajo para:
   - auditar el anteproyecto y el repositorio del agente contra las fuentes primarias,
   - diseñar y documentar el experimento de tres tratamientos (A/B/C),
   - construir el corpus, la tabla de trazabilidad, el protocolo de prompts y el banco de
     preguntas,
   - correr el análisis estadístico (kappa de Cohen, intervalos de Wilson) y redactar los
     documentos de entrega (inventario de fallos, memoria, exposición, este mismo archivo).
3. **NotebookLM (Google)**, elegido como el sistema final con cita obligatoria — ancla sus
   respuestas a los 10 documentos del corpus y es el sistema evaluado en el experimento y en el
   banco de 18 preguntas.

El equipo contrastó los textos generados por IA contra las fuentes primarias antes de
incluirlos en los entregables. Esa verificación no fue infalible: la auditoría externa y la
revisión del 17 de octubre de 2026 encontraron errores que habían pasado (sección 3, casos 4 y
5), y por eso hoy cada cifra se acompaña de su página.

## 2. Qué controles usamos

- **Verificación documento por documento:** cada referencia de la bibliografía original se abrió y
  se leyó, no se asumió correcta por tener formato de cita.
- **Clasificación doble en el experimento:** en el experimento de 30 referencias, cada integrante
  clasificó por separado y luego se calculó el acuerdo (acuerdo bruto 93,3 %, kappa −0,034; los dos
  nunca coincidieron en un caso no utilizable). **En el banco de 18 preguntas la clasificación no
  fue independiente:** la hizo Camilo y Juan David la revisó, por lo que no se calcula acuerdo.
- **Verificación contra el texto del PDF:** para afirmaciones específicas (cifras, nombres,
  kappas), se extrajo el texto del PDF con `pdftotext` y se buscó la cifra o el nombre citado por
  la IA, en lugar de revisarlo solo a simple vista.
- **Protocolo de cita obligatoria:** se exigió a NotebookLM citar documento y ubicación exacta, y
  se definió una regla explícita de abstención para cuando la respuesta no está en el corpus.
- **Pruebas de estrés deliberadas:** 4 de las 18 preguntas del banco final se diseñaron sin
  respuesta en el corpus, para ver si el sistema inventaba en vez de abstenerse. NotebookLM se
  abstuvo bien en 3 de las 4; la pregunta 17 no cumplió el criterio de abstención.
- **Control:** las mismas 18 preguntas se aplicaron a Claude.ai sin documentos adjuntos y con
  búsqueda web. Obtuvo el mismo resultado (17 de 18), así que el banco no muestra ventaja de
  exactitud del corpus.

## 3. Cuando la IA se equivocó (y qué hicimos)

Documentamos cinco casos distintos, porque cada uno enseña algo diferente:

**Caso 1 — NotebookLM citó contenido fuera de su propio corpus (semana 2).**
Con el corpus en 6 documentos, le pedimos kappas de acuerdo entre lectores. Respondió con valores
específicos (0.702, 0.544, 0.557, 0.323) como si vinieran de las fuentes cargadas. No estaban en
ninguno de los 6 PDF. Resultaron ser reales, pero de un artículo (Miskin et al., 2021) que aún no
estaba en el sistema. Lo agregamos al corpus, y en la pregunta 13 del banco (semana 3) el sistema
citó los cuatro valores de Miskin correctamente. Quedó documentado el ciclo: detectar →
diagnosticar → corregir → volver a probar. El mecanismo del fallo no está demostrado.

**Caso 2 — Claude generó una cita no verificada (autocorregido antes de entregar).**
En un borrador intermedio de uno de los archivos de corpus, Claude incluyó un DOI para una
referencia sin haberlo verificado de verdad. Se detectó al revisar el archivo antes de entregarlo
al equipo, se corrigió, y se informó explícitamente en la conversación en vez de dejarlo pasar.
No llegó a ningún entregable final.

**Caso 3 — Una conclusión de "no localizable" resultó ser un error de búsqueda, no una invención.**
Tras tres búsquedas externas sin resultado, se concluyó que la referencia "Chai et al." era
candidata a fabricación. Juan David encontró después el artículo real (DOI 10.3389/fmed.2026.1848548)
en una fuente que las búsquedas anteriores no habían cubierto. Se corrigió la conclusión en los
documentos afectados y se reemplazó por otro hallazgo real. La lección: una búsqueda fallida no
es evidencia de que algo no exista, y hay que decirlo así en vez de presentar una ausencia como una
prueba.

**Caso 4 — Claude dio una corrección errónea sobre la diapositiva 7 (detectada el 17-oct-2026).**
Una corrección anterior afirmaba que el preprint "Beyond Accuracy" no menciona el desbalance de
datos. Al revisar el PDF, sí lo menciona (pp. 4, 9, 10 y 31); lo que no coincide con la diapositiva
es que el método son Vision Transformers, no modelos estadísticos. Se corrigió en la
trazabilidad y en `correcciones_anteproyecto.md`.

**Caso 5 — Resultados del banco con errores (detectados por la auditoría, corregidos el
17-oct-2026).** Una versión anterior daba 18 de 18, y decía que NotebookLM había aclarado en la
pregunta 17 que no tenía el texto de la guía NASS; esa aclaración no está en la respuesta
literal. También esperaba "30 resonancias" en la pregunta 6, cuando el texto completo dice 30
pacientes. Se corrigió: 17 de 18 y respuesta esperada ajustada.

## 4. Qué no hicimos

- No se garantiza que toda cifra generada por IA esté libre de error: los casos 4 y 5 muestran
  lo contrario. Lo que sí se hace es verificar contra la fuente y corregir en los documentos.
- No se promedian clasificaciones en desacuerdo entre los dos integrantes. En 2 de 30 casos del
  experimento no coincidieron, y la clasificación final registrada fue la de Camilo en ambos.
  [PENDIENTE: no hay acta escrita de una discusión; no se afirma que la hubo.]
- Pendiente: el caso 2 (DOI no verificado) debe comprobarse contra el borrador original antes de
  entregar, porque no consta evidencia en este repositorio.

## 5. Responsables

Documento preparado conjuntamente por Juan David Cacua y Camilo Velandia, con asistencia de
Claude (Anthropic) para la redacción y de NotebookLM (Google) como sistema evaluado. La
verificación de cada afirmación contra las fuentes primarias fue realizada por los integrantes del
equipo.
