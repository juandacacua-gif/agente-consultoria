# Correcciones al anteproyecto — listas para pegar

Cada bloque tiene el texto ORIGINAL (lo que dice la diapositiva ahora) y el CORREGIDO
(lo que debería decir), con la razón del cambio. La diapositiva 7.2 (Abdelrahman)
queda pendiente a propósito — el equipo decidió no resolverla todavía.

---

## Diapositiva 4 — "Acerca de los datos"

**ORIGINAL:**
> "para recopilar datos e imágenes de ocho centros médicos en cinco continentes"

**CORREGIDO (agregar cifra exacta, ya verificada):**
> "para recopilar datos e imágenes de 2,697 pacientes (8,593 series de imágenes) en
> ocho instituciones de seis países en cinco continentes"

**Razón:** la frase original ya era correcta, solo le faltaba la cifra exacta que
ahora tenemos verificada contra el paper de Richards et al.

---

## Diapositiva 5 — "Complejidad del análisis"

**ORIGINAL:**
> "Las bases de datos del reto RSNA contienen miles de registros donde los errores de
> interpretación..."

**CORREGIDO:**
> "Las bases de datos del reto RSNA contienen 8,593 series de imágenes (2,697
> pacientes) donde los errores de interpretación..."

**Razón:** reemplaza la cifra vaga ("miles de registros") por el dato exacto.

---

## Diapositiva 7 — "Estado del arte" (primera parte)

### Sobre "Beyond Accuracy"

**ORIGINAL:**
> "Explica que evaluar estas condiciones con métodos básicos es insuficiente por el
> enorme desbalance de datos. Propone modelos estadísticos para evaluar los perfiles
> completos de los pacientes."

**CORREGIDO:**
> "Explica que la exactitud de clasificación convencional es insuficiente para
> evaluar el comportamiento clínico de los modelos, dado que hay múltiples
> condiciones, niveles vertebrales y categorías de severidad ordenadas en juego.
> Propone un framework de cinco pipelines de Vision Transformers (deep learning),
> complementado con métricas de exactitud ordinal (CLOA, PLOA) para evaluar el perfil
> completo de degeneración de cada paciente."

**Razón:** el método real es deep learning (Vision Transformers), no "modelos
estadísticos", y la motivación real es la complejidad multi-nivel, no "desbalance de
datos". Verificado línea por línea contra el PDF completo.

### Sobre la segunda referencia (Trento / Abdelrahman)

**PENDIENTE — no modificar todavía.** El equipo decidió posponer la resolución de
cuál es la fuente correcta de esta frase (Trento et al. 2025 vs. Abdelrahman et al.
2026). Ver Hallazgo 1 del inventario de fallos para el detalle completo cuando se
retome.

---

## Diapositiva 8 — "Estado del arte" (segunda parte)

### Sobre Walsh et al.

No requiere cambio en el texto de la diapositiva (el contenido descrito ya es
correcto), pero sí en la **bibliografía** — ver más abajo.

---

## Diapositiva 9 — "Estado del arte" (tercera parte)

### Sobre Chai et al.

**Sin cambios en el contenido de la diapositiva** — ya se verificó que es correcto
("Introduce Deep Learning guiado por la anatomía del paciente para la clasificación
de la patología y la evaluación del riesgo" coincide con el framework real de 3
etapas que reporta Macro F1=0.783, kappa=0.765, AUC=0.891).

---

## Bibliografía completa corregida (reemplazar la diapositiva 17-19 completa)

Usar la exportación de Zotero en formato APA 7. Referencias ya confirmadas con DOI
real:

> Al-Tameemi, H. N., Al-Essawi, S., Shukri, M., & Naji, F. K. (2017). Using Magnetic
> Resonance Myelography to Improve Interobserver Agreement in the Evaluation of
> Lumbar Spinal Canal Stenosis and Root Compression. *Asian Spine Journal*, *11*(2),
> 198-203. https://doi.org/10.4184/asj.2017.11.2.198
>
> Bagley, C., MacAllister, M., Dosselman, L., Moreno, J., Aoun, S. G., & El Ahmadieh,
> T. Y. (2019). Current concepts and recent advances in understanding and managing
> lumbar spine stenosis. *F1000Research*, *8*, 137.
> https://doi.org/10.12688/f1000research.16082.1
>
> Cai, X., Sun, M., Huang, Y., et al. (2020). Biomechanical Effect of L4–L5
> Intervertebral Disc Degeneration on the Lower Lumbar Spine: A Finite Element
> Study. *Orthopaedic Surgery*. https://doi.org/10.1111/os.12703
>
> Chai, Z., Liu, C., Qin, R., Zhao, D., & Shi, A. (2026). Anatomy-guided
> context-aware deep learning for lumbar degenerative disease grading and
> burden-aware risk assessment on MRI. *Frontiers in Medicine*, *13*, 1848548.
> https://doi.org/10.3389/fmed.2026.1848548
>
> Miskin, N., Isaac, Z., Lu, Y., Makhni, M. C., Sarno, D. L., Smith, T. R.,
> Zampini, J. M., & Mandell, J. C. (2021). Simplified Universal Grading of Lumbar
> Spine MRI Degenerative Findings: Inter-Reader Agreement of Non-Radiologist Spine
> Experts. *Pain Medicine*, *22*(7), 1485-1495. https://doi.org/10.1093/pm/pnab098
>
> Richards, T. J., Flanders, A. E., Colak, E., Prevedello, L. M., Ball, R. L., et al.
> (2026). The RSNA Lumbar Degenerative Imaging Spine Classification (LumbarDISC)
> Dataset. *Radiology: Artificial Intelligence*, *8*(2), e250480.
> https://doi.org/10.1148/ryai.250480
>
> Trento, A., Rapisarda, S., Bresolin, N., Valenti, A., & Giordan, E. (2025).
> Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative
> Pathology: A Narrative Review. *Medicina*, *61*(8), 1400.
> https://doi.org/10.3390/medicina61081400
>
> Trînc, E. C., Ancuți, C., Ancuți, C., & Iacob, E. R. (2026). Beyond Accuracy:
> Multi-Level Ordinal Assessment of Lumbar Spine Degeneration from Multiplanar MRI
> Using the RSNA 2024 (LumbarDISC) Dataset and Condition-Specific ViTs. *Computer
> Science and Mathematics*. https://doi.org/10.20944/preprints202608.1250.v1
>
> Walsh, P. J., Lee, U. J., Lipetz, J. S., & Walz, D. M. (2026). Improving
> Reliability of MRI Lumbar Spinal Stenosis Assessment Across Radiology and Spine
> Specialties: Impact of a Structured Education Intervention. *Academic Radiology*.

**Pendiente:** Abdelrahman et al. — se agrega cuando el equipo decida cómo
resolverlo (ver nota de la diapositiva 7 arriba).

**Nota:** Furman (2024), *Spinal Stenosis*, Medscape, queda fuera de esta lista
corregida — es fuente terciaria sin DOI y con barrera de acceso; el equipo debe
decidir si la retira definitivamente o la reemplaza.
