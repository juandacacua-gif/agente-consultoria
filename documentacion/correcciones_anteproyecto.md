# Correcciones al anteproyecto — listas para pegar

Cada bloque tiene el texto ORIGINAL (lo que dice la diapositiva ahora) y el CORREGIDO
(lo que debería decir), con la razón del cambio.

> **Revisión del 17 de octubre de 2026:** se corrigió la diapositiva 7 (el preprint *sí* menciona el desbalance de datos), se propone una corrección para la segunda referencia de la diapositiva 7 (Trento / Abdelrahman), que antes estaba pendiente, y se actualizó la bibliografía. Detalle y páginas en `TRAZABILIDAD_estado_del_arte.md`.

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
> evaluar estas condiciones, por el fuerte desbalance de clases y por la presencia de
> múltiples condiciones, niveles vertebrales y categorías de severidad ordenadas.
> Propone cinco pipelines de Vision Transformers (deep learning), complementados con
> métricas de exactitud ordinal (OA, CLOA, PLOA), para evaluar el perfil completo de
> degeneración de cada paciente."

**Razón:** el método real es deep learning (Vision Transformers), no "modelos
estadísticos". El desbalance de datos **sí** lo menciona el preprint (Trînc et al.,
2026, pp. 4, 9, 10 y 31; página del PDF o impresa por confirmar), y la versión
anterior de este bloque, que lo eliminaba, era errónea. La complejidad multi-nivel es
un motivo adicional, no el único.

### Sobre la segunda referencia (Trento / Abdelrahman)

**ORIGINAL:**
> "Explica cómo los modelos de IA están transformando el diagnóstico y pronóstico de
> la estenosis espinal y hernias discales, siendo herramientas útiles para agilizar el
> flujo de trabajo y la planificación médica"
> (cita: Abdelrahman et al. (2026), *J. Software Engineering and Applications*)

**PROPUESTA (a decidir por el equipo):** la frase mezcla dos fuentes, así que hay dos
opciones: citar las dos, o dividir la frase.
> "Explican cómo la IA puede apoyar el diagnóstico y pronóstico de la estenosis
> espinal y las hernias discales y la planificación preoperatoria (Trento et al.,
> 2025), y mejorar los flujos de trabajo de imagen (Abdelrahman et al., 2026)."

**Razón:** "diagnosis and prognosis of lumbar disc herniation and spinal stenosis"
está en Trento et al. (pp. 1–2) y "prognosis" no aparece en Abdelrahman; "workflow"
está en Abdelrahman (p. 2 del PDF) y no aparece en Trento. Además, Abdelrahman **sí
existe** (DOI 10.66279/r8h6j935); lo que estaba mal era el nombre de la revista (es
*Journal of Smart Algorithms and Applications*) y el PDF guardado, que era el de Trento.

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

Cuando la bibliografía esté en Zotero, exportarla en formato APA 7. Referencias con
DOI localizado (la lista de autores de Cai y de Richards, que aquí aparece con
"et al.", debe completarse en Zotero, porque APA 7 pide listar los autores):

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
> *Preprints.org*. https://doi.org/10.20944/preprints202608.1250.v1
>
> Walsh, P. J., Lee, U. J., Lipetz, J. S., & Walz, D. M. (2026). Improving
> Reliability of MRI Lumbar Spinal Stenosis Assessment Across Radiology and Spine
> Specialties: Impact of a Structured Education Intervention. *Academic Radiology*.
> (Solo se leyó el resumen; no está en el corpus.)

**Agregar:** Abdelrahman et al. (2026) — autores Abdelrahman, Abd El Basset y Elngar;
*Journal of Smart Algorithms and Applications*; https://doi.org/10.66279/r8h6j935.
[PENDIENTE: iniciales y título exacto, tomarlos del PDF o de la página del DOI.]

**Nota:** Furman (2024), *Spinal Stenosis*, Medscape, queda fuera de esta lista
corregida — es fuente terciaria sin DOI y con barrera de acceso; el equipo debe
decidir si la retira definitivamente o la reemplaza.
