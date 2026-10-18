# Procedencia del corpus — Actividad "Nada sin fuente"

Este archivo documenta el origen, fecha de verificación y estado de cada fuente usada
en el anteproyecto y en el sistema de consultoría con cita obligatoria. Es distinto del
`README.md` de la raíz del repositorio, que documenta el agente de software en sí.

Última actualización: 17 de octubre de 2026. La auditoría original es del 22 de septiembre
de 2026 (Juan David Cacua, Camilo Velandia, con apoyo de búsqueda dirigida); esta revisión
corrige los estados que quedaron desactualizados. Los PDF del corpus (10 documentos) están
en `fuentes/`; la captura de las fuentes cargadas en NotebookLM está en
`documentacion/captura_notebooklm_fuentes_2026-10-17.png`.

> Pendiente de esta revisión: los nombres exactos de archivo y las fechas de descarga
> de cada PDF (marcados [PENDIENTE]) deben tomarse del contenido real de `fuentes/`.

Convención de estado:
- ✅ **Verificada** — se confirmó la fuente real (autores, título, revista, DOI/enlace) mediante consulta directa a una base o al sitio de la revista.
- ⚠️ **Verificación parcial** — hay evidencia indirecta de que existe, pero no se confirmó la fuente primaria con DOI o enlace directo.
- ❌ **No verificable / candidata a fallo** — no se pudo localizar pese a búsquedas dirigidas; se documenta en el inventario de fallos.

---

## 1. Richards et al. (2026)

- **Título:** The RSNA Lumbar Degenerative Imaging Spine Classification (LumbarDISC) Dataset.
- **Revista:** Radiology: Artificial Intelligence, 8(2), e250480.
- **Archivo local:** `The_RSNA_Lumbar_Degenerative_Imaging_Spine_Classif.pdf`
- **Origen:** Descargado por Juan David Cacua durante la construcción del agente. [PENDIENTE: fecha de descarga.]
- **Licencia/acceso:** Acceso abierto. Preprint gemelo también disponible en `arxiv.org/pdf/2506.09162`.
- **Estado:** ✅ Verificada. Es el paper que describe el dataset de Kaggle usado en el proyecto.
- **Verificado por:** Equipo, 22-sep-2026.

## 2. Xin Yi et al. (2020)

- **Título:** Biomechanical Effect of L4–L5 Intervertebral Disc Degeneration on the Lower Lumbar Spine: A Finite Element Study.
- **Revista:** Chinese Orthopaedic Association / Wiley (Orthopaedic Surgery).
- **Archivo local:** `OS-12-917.pdf`
- **Origen:** Descargado por Juan David Cacua (fecha pendiente de confirmar).
- **Licencia/acceso:** Acceso abierto.
- **Estado:** ✅ Verificada.
- **Verificado por:** Equipo, 22-sep-2026.

## 3. Trento et al. (2025) — PDF guardado bajo la cita de Abdelrahman

- **Archivo local:** `medicina-61-01400.pdf`
- **Lo que dice la bibliografía del anteproyecto (diapositiva 17):** Abdelrahman, M. A., Abd El Basset, A. S., Elngar, A. A. (2026). "A Comprehensive Review of Artificial Intelligence for Lumbar Spine MRI Analysis." Journal of Software Engineering and Applications, 5(2). (Revista errónea; ver referencia 11.)
- **Lo que realmente es el PDF:** Trento, A., Rapisarda, S., Bresolin, N., Valenti, A., Giordan, E. (2025). "Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology: A Narrative Review." Medicina, 61(1400).
- **Estado:** ✅ Trento et al. (2025) es un artículo real, DOI 10.3390/medicina61081400. ⚠️ El fallo fue de atribución: este PDF se guardó bajo la cita de Abdelrahman et al., que es otro artículo (ver referencia 11). Ver Hallazgo 1 del inventario de fallos.
- **Acción pendiente:** la frase de la diapositiva 7 mezcla las dos fuentes (ver `TRAZABILIDAD_estado_del_arte.md`, fila 7.2). Decidir si se citan ambas o se divide la frase (propuesta en `correcciones_anteproyecto.md`).
- **Verificado por:** Equipo, 22-sep-2026; revisado 17-oct-2026.

## 4. "Beyond Accuracy" (Preprints, 2026)

- **Título:** Beyond Accuracy: Multi-Level Ordinal Assessment of Lumbar Spine Degeneration from Multiplanar MRI Using the RSNA 2024 (LumbarDISC) Dataset and Condition-Specific ViTs.
- **Fuente:** Preprints.org, manuscrito 202608.1250. Enviado 17-ago-2026, publicado 18-ago-2026.
- **Archivo local:** en `fuentes/` (PDF ya descargado y cargado en NotebookLM). [PENDIENTE: nombre exacto y fecha de descarga.]
- **Licencia/acceso:** Acceso abierto, descarga directa.
- **⚠️ Importante:** es un **preprint sin revisión por pares** ("This version is not peer-reviewed"). Al citarlo en el estado del arte, debe quedar claro que no ha pasado revisión de pares.
- **Estado:** ✅ Verificada. El cuerpo del PDF se contrastó con la diapositiva 7: coincide solo en parte (el desbalance de datos sí aparece, pero el método son Vision Transformers, no modelos estadísticos). Ver fila 7.1 de `TRAZABILIDAD_estado_del_arte.md`.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026; PDF revisado por el equipo, 17-oct-2026.

## 5. Miskin et al. (2021)

- **Título:** Simplified Universal Grading of Lumbar Spine MRI Degenerative Findings: Inter-Reader Agreement of Non-Radiologist Spine Experts.
- **Revista:** Pain Medicine, 22(7), 1485-1495.
- **DOI:** 10.1093/pm/pnab098
- **Archivo local:** en `fuentes/`. Se cargó en NotebookLM un día después de la consulta que produjo el fallo documentado (NotebookLM citó sus kappas cuando el PDF aún no estaba). [PENDIENTE: confirmar que es el PDF completo del artículo y no solo el resumen, y anotar la fecha de descarga.]
- **Estado:** ✅ Verificada (ya no es parcial).
- **Acción pendiente:** anotar la página de las cifras citadas (fila 8.1 de la trazabilidad).
- **Verificado por:** Búsqueda dirigida, 22-sep-2026 (parcial); fuente primaria localizada con posterioridad por el equipo.

## 6. Al-Tameemi et al. (2017)

- **Título real:** Using Magnetic Resonance Myelography to Improve Interobserver Agreement in the Evaluation of Lumbar Spinal Canal Stenosis **and Root Compression**.
- **Nota:** la bibliografía del anteproyecto omite "and Root Compression" del título.
- **Revista:** Asian Spine Journal, 11(2), 198-203.
- **DOI:** 10.4184/asj.2017.11.2.198
- **Archivo local:** en `fuentes/`. [PENDIENTE: nombre exacto y fecha de descarga.]
- **Licencia/acceso:** Acceso abierto (Creative Commons), confirmado en el sitio de la revista y en DOAJ.
- **Estado:** ✅ Verificada.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 7. Bagley et al. (2019)

- **Título:** Current concepts and recent advances in understanding and managing lumbar spine stenosis.
- **Revista:** F1000Research, 8, F1000 Faculty Rev-137.
- **DOI:** 10.12688/f1000research.16082.1
- **Archivo local:** en `fuentes/`. [PENDIENTE: nombre exacto y fecha de descarga.]
- **Licencia/acceso:** Acceso abierto (Creative Commons), PDF directo disponible.
- **Estado:** ✅ Verificada.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 8. Chai et al. (2026) — localizada

- **Cómo aparece en la bibliografía del anteproyecto:** Chai, Z., Liu, C., Qin, R., Zhao, D., Shi, A. (2026). "Anatomy-guided context-aware deep learning for lumbar degenerative disease grading and burden-aware risk assessment on MRI." Frontiers in Medicine.
- **Datos confirmados:** Frontiers in Medicine, 13, 1848548. DOI 10.3389/fmed.2026.1848548.
- **Archivo local:** en `fuentes/`. [PENDIENTE: nombre exacto y fecha de descarga.]
- **Estado:** ✅ Verificada. La búsqueda del 22-sep no la encontró, pero existe; no fue un fallo de invención. El "candidato a fallo" del inventario debe retirarse o reclasificarse como fallo de la búsqueda, no de la bibliografía.
- **Acción pendiente:** anotar la página que respalda la frase de la diapositiva 9 (fila 9.1 de la trazabilidad).
- **Verificado por:** Búsqueda dirigida, 22-sep-2026 (sin éxito); localizada con posterioridad por el equipo.

## 9. Walsh et al. (2026) — error de formato de cita

- **Cómo aparece en la bibliografía del anteproyecto:** "Walsh, J. Un, J.L., Lipetz, J., Walz, D.M."
- **Autores reales:** Walsh, P.J., Lee, U.J., Lipetz, J.S., Walz, D.M.
- **Título:** Improving Reliability of MRI Lumbar Spinal Stenosis Assessment Across Radiology and Spine Specialties: Impact of a Structured Education Intervention.
- **Revista:** Academic Radiology, 2026 (Elsevier).
- **Archivo local:** _no disponible_ (no está en el corpus; solo se leyó el resumen)
- **Estado:** ✅ Existencia verificada, pero la cita en la bibliografía tiene los nombres de autores mal separados (el segundo autor, "Lee, Un Jung", quedó fusionado con el apellido de Walsh). El contenido citado en la diapositiva 8 sí coincide con el resumen real del artículo.
- **Acción pendiente:** la cita ya está corregida en `correcciones_anteproyecto.md`. Conseguir el PDF vía biblioteca institucional de la Universidad Santo Tomás para anotar la página (fila 8.3). Prueba con NotebookLM (17-oct-2026): se abstuvo correctamente al preguntarle por Walsh (`entregables/caso_fallo_walsh_2026-10-17.md`).
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 10. Furman (2024) — RETIRADA de la bibliografía (17-oct-2026)

- **Título:** Spinal Stenosis.
- **Fuente:** Medscape.
- **Archivo local:** _no disponible_ (no está en el corpus)
- **Estado:** Medscape es una fuente terciaria (artículo de referencia clínica, no un estudio con hallazgos originales) y pide cuenta gratuita para ver el texto completo.
- **Decisión del equipo (17-oct-2026):** se retira de la bibliografía. La frase de la diapositiva 7 que la citaba se elimina (ver fila 7.3 de `TRAZABILIDAD_estado_del_arte.md`).

## 11. Abdelrahman et al. (2026) — existe

- **Autores:** Abdelrahman, Abd El Basset, Elngar (confirmado por Juan David).
- **Revista:** *Journal of Smart Algorithms and Applications* (no "Journal of Software Engineering and Applications").
- **DOI:** 10.66279/r8h6j935
- **Archivo local:** en `fuentes/`. [PENDIENTE: nombre exacto, título exacto y fecha de descarga.]
- **Estado:** ✅ Verificada. Es un artículo distinto de Trento et al. (2025); no fue una invención. El fallo original fue guardar el PDF de Trento bajo esta cita.
- **Verificado por:** Juan David Cacua, 26-sep-2026.

## 12. Zhao et al.

- **Estado:** forma parte del corpus de 10 documentos cargado en NotebookLM, pero esta ficha no existía. [PENDIENTE: título, revista, DOI, licencia, archivo y fecha de descarga; completar con los datos reales antes de entregar.]

---

## Resumen de estado (17-oct-2026)

| Estado | Cantidad | Referencias |
|---|---|---|
| ✅ Verificada y con PDF en el corpus | 9 | 1, 2, 3, 4, 5, 6, 7, 8, 11 |
| Ficha por completar | 1 | 12 (Zhao et al.) |
| ✅ Existe, sin PDF en el corpus | 1 | 9 (Walsh; cita corregida, falta el PDF) |
| Retirada de la bibliografía | 1 | 10 (Furman; fuente terciaria con barrera de acceso) |

Nota: el corpus tiene 10 documentos (referencias 1 a 8, 11 y 12). Walsh no está en el corpus y Furman se retiró.

**Pendientes:** nombres de archivo y fechas de descarga; ficha de Zhao et al.; página de la trazabilidad 8.3 (Walsh).
