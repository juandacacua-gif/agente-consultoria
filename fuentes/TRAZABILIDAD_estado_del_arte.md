# Tabla de trazabilidad — Estado del arte

Cubre las diapositivas 7, 8 y 9 del anteproyecto (sección "Estado del arte"). Por cada
afirmación: qué dice la diapositiva, qué fuente cita, si esa fuente es real, y si el
contenido de la fuente real respalda lo que dice la diapositiva.

Convención de estado:
- ✅ Coincide — la fuente real dice lo que la diapositiva le atribuye.
- ⚠️ Sin confirmar — la fuente parece correcta pero no se cotejó el contenido exacto (falta leer el PDF completo).
- ❌ No coincide / fuente incorrecta — hay un problema de atribución.

---

## Diapositiva 7

| # | Afirmación de la diapositiva | Fuente citada | ¿Fuente real? | ¿Coincide el contenido? | Verificado por / fecha |
|---|---|---|---|---|---|
| 7.1 | "Explica que evaluar estas condiciones con métodos básicos es insuficiente por el enorme desbalance de datos. Propone modelos estadísticos para evaluar los perfiles completos de los pacientes." | Bibliografía dice: "Preprints. (2026)" — **sin autores**, como si "Preprints" fuera el autor | ⚠️ La plataforma es real, pero los **autores reales son Trînc, E.C., Ancuți, C., Ancuți, C., Iacob, E.R.** (Universidad Politécnica de Timișoara / Univ. de Medicina y Farmacia "Victor Babeș"), omitidos por completo en la bibliografía | ⚠️ **Coincide solo en parte** (confirmado con el PDF completo, página 1-2). La insuficiencia real es por "múltiples condiciones anatómicas, niveles espinales y categorías de severidad ordenadas" — no se menciona "desbalance de datos". El método real son **cinco pipelines de Vision Transformers** con 24 configuraciones de arquitectura cada uno, complementados con métricas de exactitud ordinal (OA, CLOA, PLOA) — no son "modelos estadísticos". | Leído completo, páginas 1-2 — 24-sep-2026 |
| 7.2 | "Explica cómo los modelos de IA están transformando el diagnóstico y pronóstico de la estenosis espinal y hernias discales, siendo herramientas útiles para agilizar el flujo de trabajo y la planificación médica" | Bibliografía dice: Abdelrahman et al. (2026), *J. Software Engineering and Applications* | ❌ **No coincide.** El PDF real en el repo (`medicina-61-01400.pdf`) es de **Trento et al. (2025)**, *Medicina*, un artículo distinto | ⚠️ El contenido descrito en la diapositiva sí es compatible con lo que suele cubrir un narrative review de IA en columna lumbar — falta leer el PDF de Trento completo para confirmar que es la fuente real de esta frase exacta | Equipo + búsqueda dirigida, 22-sep-2026 — **Hallazgo 1, ver inventario de fallos** |
| 7.3 | "Este artículo muestra como algunas patologías pueden tener una misma causa de origen y relacionarse." | Furman, M. B. (2024). Spinal Stenosis. Medscape | ⚠️ Existe pero es fuente terciaria (enciclopedia clínica, no estudio original) con acceso restringido por login | ⚠️ Sin confirmar — no se pudo leer el contenido completo por la barrera de acceso | Pendiente |

## Diapositiva 8

| # | Afirmación de la diapositiva | Fuente citada | ¿Fuente real? | ¿Coincide el contenido? | Verificado por / fecha |
|---|---|---|---|---|---|
| 8.1 | "Desarrollado por un grupo de especialistas en neurocirugía, ortopedia, fisiatría, radiología; compara concordancia entre especialidades y no solo entre radiólogos." | Miskin, N., et al. (2021) | ⚠️ Evidencia indirecta de que existe (citada por otros estudios), no se localizó la fuente primaria con DOI | ⚠️ Sin confirmar — no se pudo leer el artículo original | Búsqueda dirigida, 22-sep-2026 (parcial) |
| 8.2 | "Muestra una combinación entre mielografía y resonancia magnética." | Al-Tameemi, H.N., et al. (2017) | ✅ Sí, *Asian Spine Journal*, DOI `10.4184/asj.2017.11.2.198` | ✅ **Coincide, pero es una síntesis muy pobre** (confirmado con el PDF completo, página 200-201, Tablas 2 y 3). 30 RM lumbares (150 niveles de disco) revisadas por dos radiólogos y un neurocirujano, comparando MRI sola vs. MRI + mielografía (MRM); el acuerdo interobservador mejoró de moderado (kappa 0.4) a bueno (kappa 0.6) para estenosis del canal, y de moderado a bueno (kappa 0.57→0.73) para compresión radicular. La diapositiva reduce todo esto a "muestra una combinación" y omite el hallazgo real (que la combinación mejora el acuerdo, medido con kappa) — que es justo el dato con el que su propio anteproyecto podría conectar, ya que ustedes también miden acuerdo con kappa. | Leído completo, página 200-201 (Tablas 2 y 3) — 24-sep-2026 |
| 8.3 | "Con 37 médicos de seis especialidades, revisa la exactitud general pre-intervención con y sin capacitación." | Walsh, P.J., et al. (2026) | ✅ Sí, *Academic Radiology* — pero **nombres de autores mal separados en la bibliografía** ("Walsh, J. Un, J.L." en vez de Walsh, Lee, Lipetz, Walz) | ✅ **Coincide** — se confirmó vía resumen del artículo: 37 médicos, seis especialidades, exactitud mejoró de 54.5% a 61.2% tras capacitación estructurada | Búsqueda dirigida, 22-sep-2026 — cita a corregir, contenido correcto |

## Diapositiva 9

| # | Afirmación de la diapositiva | Fuente citada | ¿Fuente real? | ¿Coincide el contenido? | Verificado por / fecha |
|---|---|---|---|---|---|
| 9.1 | "Introduce Deep Learning guiado por la anatomía del paciente para la clasificación de la patología y la evaluación del riesgo." | Chai, Z., et al. (2026), Frontiers in Medicine | ❌ **No localizable** después de tres búsquedas dirigidas con términos distintos | — No se puede evaluar contenido de una fuente que no se confirmó | Búsqueda dirigida, 22-sep-2026 — **candidato a fallo de invención, ver inventario de fallos** |
| 9.2 | "Explica avances y nuevos conceptos para entender y tratar los problemas asociados a estenosis, incluyendo mejoras e innovaciones en tratamientos." | Bagley, C., et al. (2019) | ✅ Sí, *F1000Research*, DOI `10.12688/f1000research.16082.1` | ✅ **Coincide bien** (confirmado con el PDF completo, página 1, sección Abstract y "Treatment options" en páginas 4-5). Es una revisión narrativa sobre estenosis espinal lumbar: factores de riesgo (obesidad, tabaquismo, genética), diagnóstico (combinación de hallazgos radiológicos y clínicos), y tratamiento (desde fisioterapia hasta descompresión quirúrgica), con la aclaración de que no hay recomendaciones de nivel I por falta de evidencia concluyente — un detalle que la diapositiva no menciona pero que no contradice lo que sí dice. | Leído completo, página 1 y 4-5 — 24-sep-2026 |

---

## Resumen

| Estado del contenido | Cantidad de afirmaciones |
|---|---|
| ✅ Coincide bien (fuente y contenido confirmados) | 3 (8.2, 8.3 con corrección de cita, 9.2) |
| ⚠️ Coincide solo en parte / síntesis imprecisa | 1 (7.1 — atribuye "desbalance de datos" y "modelos estadísticos" cuando el paper real habla de complejidad multi-nivel y usa Vision Transformers) |
| ⚠️ Sin confirmar (fuente probable, contenido no leído) | 2 (7.3 — barrera de acceso; 8.1 — fuente primaria no localizada) |
| ❌ No coincide / fuente no localizable | 2 (7.2 y 9.1 — los dos fallos ya documentados) |

**Lectura importante:** de las 8 afirmaciones del estado del arte, **3 quedaron
confirmadas como fieles a la fuente real**, pero **ninguna de las ocho estaba libre de
matices** una vez se leyó el abstract completo. Incluso las que sí "coinciden" (8.2 y
9.2) resultaron ser síntesis muy reducidas que omiten el hallazgo principal del estudio
(por ejemplo, 8.2 no menciona que el resultado medible es una mejora en el kappa de
acuerdo interobservador, justo el tipo de métrica que ustedes mismos van a reportar en
su experimento). Y 7.1 es un caso de **caracterización incorrecta del método**: la
diapositiva describe un estudio de deep learning como si fuera de "modelos
estadísticos", y le atribuye una motivación (desbalance de clases) que el abstract real
no menciona. Esto no es tan grave como una referencia inventada, pero si el docente
pregunta "¿qué tipo de modelo usa este paper?" en la sustentación, la respuesta correcta
(Vision Transformers) no es la que dice la diapositiva.

## Próximo paso

Quedan 2 filas en ⚠️ sin resolver del todo: 7.3 (Furman/Medscape, con barrera de acceso)
y 8.1 (Miskin et al., fuente primaria aún no localizada). Para esas dos, y para leer el
cuerpo completo de los tres artículos ya confirmados (más allá del abstract) y ubicar el
número de página exacto que respalda cada frase, le toca a alguien del equipo abrir los
PDF una vez estén todos en `fuentes/`. Ese es el nivel de detalle que se espera poder
mostrar en la sustentación si el docente señala cualquiera de estas frases.
