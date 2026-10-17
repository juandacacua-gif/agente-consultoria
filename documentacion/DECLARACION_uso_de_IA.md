# Declaración de uso de IA — Actividad "Nada sin fuente"

**Juan David Cacua y Camilo Velandia** · Consultoría Bioestadística Aplicada a la Radiología
para el Diagnóstico Lumbar · Universidad Santo Tomás

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

Ningún texto generado por IA se usó sin que un integrante del equipo lo contrastara contra la
fuente primaria antes de incluirlo en un entregable. Esa verificación —no la generación— es el
trabajo que hizo el equipo.

## 2. Qué controles usamos

- **Verificación documento por documento:** cada referencia de la bibliografía original se abrió y
  se leyó, no se asumió correcta por tener formato de cita.
- **Clasificación independiente y doble:** en el experimento de 30 referencias, cada integrante
  clasificó sin ver la clasificación del otro; solo después se compararon y se calculó el acuerdo
  (kappa de Cohen).
- **Verificación línea por línea con `pdftotext`:** para afirmaciones específicas (cifras, nombres,
  kappas), se extrajo el texto exacto del PDF y se comparó carácter por carácter con lo citado por
  la IA, no solo "a simple vista".
- **Protocolo de cita obligatoria:** se exigió a NotebookLM citar documento y ubicación exacta, y
  se definió una regla explícita de abstención para cuando la respuesta no está en el corpus.
- **Pruebas de estrés deliberadas:** 4 de las 18 preguntas del banco final se diseñaron sin
  respuesta en el corpus, específicamente para ver si el sistema inventaba en vez de abstenerse.

## 3. Cuando la IA se equivocó (y qué hicimos)

Documentamos tres casos distintos, porque cada uno enseña algo diferente:

**Caso 1 — NotebookLM citó contenido fuera de su propio corpus (semana 2).**
Con el corpus en 6 documentos, le pedimos kappas de acuerdo entre lectores. Respondió con valores
específicos (0.702, 0.544, 0.557, 0.323) como si vinieran de las fuentes cargadas. No estaban en
ninguno de los 6 PDF. Resultaron ser reales, pero de un artículo (Miskin et al., 2021) que aún no
estaba en el sistema. Lo agregamos al corpus, repetimos la pregunta, y en la semana 3 el sistema
citó a Miskin correctamente, con ubicación exacta. Quedó documentado el ciclo completo:
detectar → diagnosticar → corregir → volver a probar.

**Caso 2 — Claude generó una cita no verificada (autocorregido antes de entregar).**
En un borrador intermedio de uno de los archivos de corpus, Claude incluyó un DOI para una
referencia sin haberlo verificado de verdad. Se detectó al revisar el archivo antes de entregarlo
al equipo, se corrigió, y se informó explícitamente en la conversación en vez de dejarlo pasar.
No llegó a ningún entregable final.

**Caso 3 — Una conclusión de "no localizable" resultó ser un error de búsqueda, no una invención.**
Tras tres búsquedas externas sin resultado, se concluyó que la referencia "Chai et al." era
candidata a fabricación. Juan David encontró después el artículo real (DOI 10.3389/fmed.2026.1848548)
en una fuente que las búsquedas anteriores no habían cubierto. Se corrigió la conclusión en todos
los documentos afectados y se reemplazó por otro hallazgo real. La lección: una búsqueda fallida no
es evidencia de que algo no exista, y hay que decirlo así en vez de presentar una ausencia como una
prueba.

## 4. Qué no hicimos

- No se usó ninguna cifra, cita o afirmación generada por IA sin verificarla contra una fuente
  primaria accesible al equipo.
- No se corrigió ningún fallo "hacia adentro" (ocultándolo o suavizándolo) — los tres casos
  anteriores están documentados con fecha, evidencia y quién lo verificó.
- No se promedian clasificaciones en desacuerdo entre los dos integrantes: cuando Juan David y
  Camilo no coincidieron (2 de 30 casos en el experimento), se resolvió con una discusión razonada
  y documentada, no con un criterio automático.

## 5. Responsables

Documento preparado conjuntamente por Juan David Cacua y Camilo Velandia, con asistencia de
Claude (Anthropic) para la redacción y de NotebookLM (Google) como sistema evaluado. La
verificación de cada afirmación contra las fuentes primarias fue realizada por los integrantes del
equipo.
