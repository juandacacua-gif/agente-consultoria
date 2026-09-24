# Procedencia del corpus — Actividad "Nada sin fuente"

Este archivo documenta el origen, fecha de verificación y estado de cada fuente usada
en el anteproyecto y en el sistema de consultoría con cita obligatoria. Es distinto del
`README.md` de la raíz del repositorio, que documenta el agente de software en sí.

Última actualización: 22 de septiembre de 2026, por auditoría conjunta del equipo
(Juan David Cacua, Camilo Velandia) con apoyo de búsqueda dirigida.

Convención de estado:
- ✅ **Verificada** — se confirmó la fuente real (autores, título, revista, DOI/enlace) mediante consulta directa a una base o al sitio de la revista.
- ⚠️ **Verificación parcial** — hay evidencia indirecta de que existe, pero no se confirmó la fuente primaria con DOI o enlace directo.
- ❌ **No verificable / candidata a fallo** — no se pudo localizar pese a búsquedas dirigidas; se documenta en el inventario de fallos.

---

## 1. Richards et al. (2026)

- **Título:** The RSNA Lumbar Degenerative Imaging Spine Classification (LumbarDISC) Dataset.
- **Revista:** Radiology: Artificial Intelligence, 8(2), e250480.
- **Archivo local:** `The_RSNA_Lumbar_Degenerative_Imaging_Spine_Classif.pdf`
- **Origen:** Descargado por Juan David Cacua durante la construcción del agente (fecha exacta pendiente de confirmar con él).
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

## 3. ⚠️ Ver inventario de fallos — cita mal atribuida

- **Archivo local:** `medicina-61-01400.pdf`
- **Lo que dice la bibliografía del anteproyecto (diapositiva 17):** Abdelrahman, M. A., Abd El Basset, A. S., Elngar, A. A. (2026). "A Comprehensive Review of Artificial Intelligence for Lumbar Spine MRI Analysis." Journal of Software Engineering and Applications, 5(2).
- **Lo que realmente es el PDF:** Trento, A., Rapisarda, S., Bresolin, N., Valenti, A., Giordan, E. (2025). "Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology: A Narrative Review." Medicina, 61(1400).
- **Estado:** ❌ Cita mal atribuida — dos artículos distintos. Ver Hallazgo 1 del inventario de fallos.
- **Acción pendiente:** decidir cuál es la fuente real de la diapositiva 7, corregir la bibliografía del anteproyecto, y confirmar si el artículo de Abdelrahman et al. existe de forma independiente.
- **Verificado por:** Equipo, 22-sep-2026.

## 4. "Beyond Accuracy" (Preprints, 2026)

- **Título:** Beyond Accuracy: Multi-Level Ordinal Assessment of Lumbar Spine Degeneration from Multiplanar MRI Using the RSNA 2024 (LumbarDISC) Dataset and Condition-Specific ViTs.
- **Fuente:** Preprints.org, manuscrito 202608.1250. Enviado 17-ago-2026, publicado 18-ago-2026.
- **Archivo local:** _pendiente de descargar_
- **Licencia/acceso:** Acceso abierto, descarga directa.
- **⚠️ Importante:** es un **preprint sin revisión por pares** ("This version is not peer-reviewed"). Al citarlo en el estado del arte, debe quedar claro que no ha pasado revisión de pares.
- **Estado:** ✅ Verificada (existencia y contenido del abstract).
- **Verificado por:** Búsqueda dirigida, 22-sep-2026. Falta que alguien del equipo lo descargue y confirme que el cuerpo del artículo coincide con lo citado en la diapositiva 7.

## 5. Miskin et al. (2021)

- **Título:** Simplified Universal Grading of Lumbar Spine MRI Degenerative Findings: Inter-Reader Agreement of Non-Radiologist Spine Experts.
- **Archivo local:** _no disponible_
- **Estado:** ⚠️ Verificación parcial. Encontramos evidencia indirecta de que el sistema de gradación "Miskin et al." existe y se usa en otros estudios (por ejemplo, una tesis de la Universiteit Leiden lo describe en detalle con las mismas siglas CCS/FS/LRS/FA), pero no se localizó la fuente primaria con DOI o enlace verificable.
- **Acción pendiente:** buscar directamente en PubMed por el título exacto y confirmar DOI antes de citarla con seguridad.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026 (parcial).

## 6. Al-Tameemi et al. (2017)

- **Título real:** Using Magnetic Resonance Myelography to Improve Interobserver Agreement in the Evaluation of Lumbar Spinal Canal Stenosis **and Root Compression**.
- **Nota:** la bibliografía del anteproyecto omite "and Root Compression" del título.
- **Revista:** Asian Spine Journal, 11(2), 198-203.
- **DOI:** 10.4184/asj.2017.11.2.198
- **Archivo local:** _pendiente de descargar_
- **Licencia/acceso:** Acceso abierto (Creative Commons), confirmado en el sitio de la revista y en DOAJ.
- **Estado:** ✅ Verificada.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 7. Bagley et al. (2019)

- **Título:** Current concepts and recent advances in understanding and managing lumbar spine stenosis.
- **Revista:** F1000Research, 8, F1000 Faculty Rev-137.
- **DOI:** 10.12688/f1000research.16082.1
- **Archivo local:** _pendiente de descargar_
- **Licencia/acceso:** Acceso abierto (Creative Commons), PDF directo disponible.
- **Estado:** ✅ Verificada.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 8. ❌ Chai et al. (2026) — candidata a fallo de invención

- **Cómo aparece en la bibliografía del anteproyecto:** Chai, Z., Liu, C., Qin, R., Zhao, D., Shi, A. (2026). "Anatomy-guided context-aware deep learning for lumbar degenerative disease grading and burden-aware risk assessment on MRI." Frontiers in Medicine.
- **Archivo local:** _no disponible_
- **Estado:** ❌ No verificable. Después de tres búsquedas dirigidas con términos distintos, no se encontró este artículo con ese título, esos autores ni esa revista. Frontiers in Medicine es de acceso abierto por defecto, así que de existir debería ser fácilmente localizable, como ocurrió con las referencias 6 y 7.
- **Acción pendiente:** buscar directamente en `frontiersin.org` con el buscador del sitio. Si tampoco aparece, documentar como fallo de invención en el inventario de fallos (candidato ya anotado).
- **Verificado por:** Búsqueda dirigida, 22-sep-2026 (sin éxito).

## 9. Walsh et al. (2026) — error de formato de cita

- **Cómo aparece en la bibliografía del anteproyecto:** "Walsh, J. Un, J.L., Lipetz, J., Walz, D.M."
- **Autores reales:** Walsh, P.J., Lee, U.J., Lipetz, J.S., Walz, D.M.
- **Título:** Improving Reliability of MRI Lumbar Spinal Stenosis Assessment Across Radiology and Spine Specialties: Impact of a Structured Education Intervention.
- **Revista:** Academic Radiology, 2026 (Elsevier).
- **Archivo local:** _no disponible — posible barrera de acceso institucional_
- **Estado:** ✅ Existencia verificada, pero la cita en la bibliografía tiene los nombres de autores mal separados (el segundo autor, "Lee, Un Jung", quedó fusionado con el apellido de Walsh). El contenido citado en la diapositiva 8 sí coincide con el resumen real del artículo.
- **Acción pendiente:** corregir el formato de la cita en la bibliografía; conseguir el PDF vía biblioteca institucional de la Universidad Santo Tomás.
- **Verificado por:** Búsqueda dirigida, 22-sep-2026.

## 10. Furman (2024) — fuente terciaria con barrera de acceso

- **Título:** Spinal Stenosis.
- **Fuente:** Medscape.
- **Archivo local:** _no disponible_
- **Estado:** Medscape es una fuente terciaria (artículo de referencia clínica, no un estudio con hallazgos originales) y pide cuenta gratuita para ver el texto completo.
- **Acción pendiente:** decidir en equipo si se mantiene como fuente del estado del arte o se sustituye por una fuente primaria equivalente.

## 11. Abdelrahman et al. (2026) — pendiente de confirmar existencia independiente

- Ver referencia 3. Pendiente de buscar de forma independiente para determinar si existe como artículo distinto de Trento et al. (2025) o si fue una confusión/invención al armar la bibliografía.

---

## Resumen de estado (22-sep-2026)

| Estado | Cantidad | Referencias |
|---|---|---|
| ✅ Verificada, con archivo o enlace confirmado | 6 | 1, 2, 4, 6, 7, 9 (cita a corregir) |
| ⚠️ Verificación parcial | 1 | 5 |
| ❌ No verificable / candidata a fallo | 2 | 3 (mal atribuida), 8 (no localizable) |
| Fuente terciaria / barrera de acceso | 1 | 10 |
| Pendiente de resolución | 1 | 11 |

**Próximos pasos:** descargar los PDF de las referencias 4, 6 y 7 a esta carpeta; buscar
directamente la referencia 5 en PubMed y la 8 en Frontiers; decidir el destino de las
referencias 3, 9, 10 y 11 antes del visto bueno de la semana 1.
