# 1. Inventario de fallos

Consolidado de los inventarios individuales de los dos integrantes del equipo.
Cada uno documentó al menos tres fallos, detectados de forma independiente.

---

## INVENTARIO DE FALLOS — Juan David Cacua

### Fallo 1

**Herramienta:** Gemini 3.6 Flash

**Qué generó:** Un código para análisis descriptivo de los datos

**Qué estaba mal:** Una función mal usada de R (`tidy`)

**Cómo lo detecté:** Cuando corría el código y nada corregía el error

**Qué me costó:** Tiempo y ajuste manual

**Qué lo habría evitado:** Preparar mejor el agente y darle más contexto

### Fallo 2

**Herramienta:** Gemini 3.6 Flash

**Qué generó:** Un código para imputar los datos faltantes

**Qué estaba mal:** La elección de regresión politómica en lugar de regresión logística ordinal

**Cómo lo detecté:** Cuando comparaba con las respuestas que daba Gemini sin iniciar sesión

**Qué me costó:** Tiempo en la revisión conceptual y cambio de método

**Qué lo habría evitado:** Preparar mejor al agente para este tipo de procesos

### Fallo 3

**Herramienta:** Gemini 3.6 Flash

**Qué generó:** Un código para análisis exploratorio de los datos con generación de gráficos incluidos

**Qué estaba mal:** Un gráfico que mostraba las categorías (Normal, Moderado, Severo) desordenadas

**Cómo lo detecté:** Al mirar el gráfico que quedó

**Qué me costó:** Tiempo en modificar los factores para lograr el orden correcto en el gráfico

**Qué lo habría evitado:** Especificar mejor al agente el orden de los niveles

---

## INVENTARIO DE FALLOS — Camilo Velandia

### Fallo 1

**Herramienta:** Claude (usado como apoyo para auditar la bibliografía del anteproyecto)

**Qué generó:** Al revisar la diapositiva 7 del estado del arte, comparé la referencia citada —"Abdelrahman, M. A., Abd El Basset, A. S., Elngar, A. A. (2026). A Comprehensive Review of Artificial Intelligence for Lumbar Spine MRI Analysis. Journal of Software Engineering and Applications"— contra el PDF que teníamos guardado en el repositorio con ese propósito.

**Qué estaba mal:** El PDF real en el repositorio no era de Abdelrahman et al., sino de Trento, A., Rapisarda, S., Bresolin, N., Valenti, A., Giordan, E. (2025), "Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology: A Narrative Review", publicado en *Medicina*. Son dos artículos distintos, con autores y revista distintos, y no hay forma de saber si Abdelrahman et al. (2026) existe de verdad o si fue una confusión al armar la bibliografía original.

**Cómo lo detecté:** Al pedirle a Claude que verificara con una búsqueda real cada referencia de la bibliografía contra los documentos que teníamos guardados, en vez de asumir que el nombre del archivo o la cita coincidían.

**Qué me costó:** Tiempo de revisión de toda la bibliografía completa (las 10 referencias), y ahora tengo que decidir con mi compañero cuál de los dos artículos es la fuente real de esa diapositiva antes de poder corregirla.

**Qué lo habría evitado:** Verificar cada PDF contra su cita en el momento de guardarlo en el repositorio, en vez de confiar en que el nombre del archivo correspondía a la referencia de la bibliografía.

### Fallo 2

**Herramienta:** Claude (búsqueda web dirigida, y verificación posterior contra el PDF real subido por Juan David)

**Qué generó:** Al buscar la referencia "Xin Yi, C., et al. (2020). Biomechanical Effect of L4–L5 Intervertebral Disc Degeneration on the Lower Lumbar Spine." citada en la bibliografía del anteproyecto, y compararla luego contra el PDF real, encontramos que el nombre del primer autor está invertido.

**Qué estaba mal:** El primer autor real es **Cai, Xin-yi** (apellido Cai, nombre de pila Xin-yi, en orden de nombre chino), no "Xin Yi, C." como aparece en la bibliografía — quedó tratado como si "Xin Yi" fuera el apellido y "C." la inicial del nombre. Es el mismo patrón que encontramos en otras dos referencias de la misma bibliografía: Walsh et al. (2026), donde el segundo autor "Lee, Un Jung" (nombre coreano) quedó fusionado con el apellido de Walsh; y la referencia de "Beyond Accuracy", donde los autores reales quedaron omitidos por completo y se citó "Preprints." como si fuera el autor. En total, **tres de las diez referencias de la bibliografía tienen el mismo tipo de error: nombres de autores no occidentales mal formateados o incompletos** — no parece un error aislado, sino un patrón sistemático en cómo se armó la bibliografía original.

**Cómo lo detecté:** Comparando el nombre del autor tal como aparece en la bibliografía del anteproyecto contra el nombre real que figura en el PDF del artículo (una vez Juan David lo confirmó con el DOI real, `10.1111/os.12703`).

**Qué me costó:** Poco tiempo una vez tuvimos el PDF real — el problema fue más de tiempo acumulado entre los tres casos, y la necesidad de revisar cada nombre de autor letra por letra en vez de asumir que la bibliografía ya estaba bien transcrita.

**Qué lo habría evitado:** Copiar los nombres de autores directamente desde la página oficial del artículo (o desde un gestor de referencias como Zotero, que los importa automáticamente desde el DOI) en vez de escribirlos a mano o dejar que una herramienta de IA los reconstruyera sin verificación.

> **Nota:** este fallo reemplaza el que teníamos antes sobre "Chai et al. no localizable" — esa referencia sí existe (Juan David encontró el PDF real, DOI `10.3389/fmed.2026.1848548`), así que ya no aplica como fallo. La búsqueda que no la encontró fue una limitación de mi herramienta de búsqueda, no evidencia de que la referencia fuera inventada — una distinción importante que también vale la pena mencionar en la sustentación como lección aprendida.

### Fallo 3

**Herramienta:** NotebookLM (con nuestro corpus de 6 PDF cargados: LumbarDISC, Xin Yi/Cai, Trento, Beyond Accuracy, Al-Tameemi, Bagley)

**Qué generó:** Al pedirle a NotebookLM que respondiera *solo* con base en esos 6 documentos sobre el acuerdo entre lectores en la gradación de estenosis lumbar, dio una respuesta detallada que incluía valores exactos de kappa (0.702 para estenosis del canal, 0.544 para estenosis foraminal, 0.557 para artropatía facetaria, 0.323 para receso lateral) atribuidos a "un sistema de gradación simplificado... expertos en columna no radiólogos", con un número de cita `[5]` como si viniera de las fuentes cargadas.

**Qué estaba mal:** Ninguno de los 6 PDF que le dimos contenía esos valores ni la palabra "Miskin". Confirmamos línea por línea contra el texto completo de los 6 documentos: no aparecían en ninguno. Los valores sí son reales — pertenecen al artículo de Miskin et al. (2021), *Pain Medicine*, DOI `10.1093/pm/pnab098` — pero mi compañero confirmó que **subió ese PDF al notebook un día después** de que hiciéramos esta prueba, junto con otras fuentes. Es decir, NotebookLM citó contenido que no estaba disponible en el momento de la consulta, a pesar de la instrucción explícita de responder solo con lo que se le había subido.

**Cómo lo detecté:** Extrayendo el texto completo de los 6 PDF originales con `pdftotext` y buscando los valores numéricos exactos y el nombre "Miskin" en todos ellos — no bastaba con confiar en que el número de cita `[5]` de la interfaz apuntara a algo real, había que comprobarlo contra el contenido real de cada archivo.

**Qué me costó:** Tiempo de extracción y búsqueda en los 6 PDF, y la coordinación con mi compañero para confirmar la fecha exacta en que subió el PDF de Miskin (sin esa confirmación, no podíamos estar seguros de si el fallo era del sistema o simplemente un documento que se nos había olvidado que sí estaba ahí).

**Qué lo habría evitado:** Llevar un registro exacto de qué documentos estaban cargados en el notebook en el momento preciso de cada prueba del experimento, en vez de asumir que "el corpus" es siempre el mismo conjunto de archivos a lo largo del tiempo.

---

## Resumen del equipo

| # | Fallo | Integrante | Tipo |
|---|---|---|---|
| 1 | Función de R mal caracterizada (`tidy`) — *descripción pendiente de ajustar* | Juan David | Código / herramienta |
| 2 | Regresión politómica en vez de ordinal | Juan David | Conceptual / estadístico |
| 3 | Orden de factores en gráfico | Juan David | Código, menor |
| 4 | Trento citado bajo la cita de Abdelrahman (PDF equivocado en el repo) | Camilo | Cita bibliográfica — archivo mal vinculado |
| 5 | Tres referencias con nombres de autores no occidentales mal formateados (Walsh/Lee, Beyond Accuracy, Xin Yi/Cai) | Camilo | Patrón sistemático de formato de cita |
| 6 | **NotebookLM citó a Miskin et al. sin que ese PDF estuviera en el corpus subido en el momento de la consulta** | Camilo | **Fallo del sistema de contexto cerrado — caso oficial para semana 3** |

Seis fallos documentados entre los dos, con variedad de tipos (código, estadístico,
bibliográfico, patrón sistemático, y fallo del propio sistema de contexto cerrado) —
más que suficiente frente al mínimo de tres por persona que pide la actividad.
propio proceso de armar este inventario, de por qué "no encontrar algo" no es lo
mismo que "confirmar que no existe".

# 2. Banco de preguntas — Evaluación del sistema (Semana 3)

18 preguntas con respuesta conocida, localizada en documento + página del corpus. Las
últimas 4 están **deliberadamente fuera del corpus** para probar si el sistema se
abstiene correctamente o inventa una respuesta.

Formato: pregunta → respuesta esperada → documento y ubicación exacta → cómo se verificó.

---

## Preguntas CON respuesta en el corpus (14)

### 1. Tamaño del dataset LumbarDISC
**Pregunta:** ¿Cuántos pacientes y series de imágenes incluye el dataset RSNA LumbarDISC, y de cuántas instituciones y países provienen?
**Respuesta esperada:** 2,697 pacientes, 8,593 series de imágenes, 8 instituciones, 6 países, 5 continentes.
**Fuente:** Richards et al. — *The RSNA LumbarDISC Dataset*.
**Verificado:** sí, exacto, confirmado por búsqueda directa al artículo.

### 2. Escala de severidad usada en LumbarDISC
**Pregunta:** ¿Cómo se construyó la escala de severidad de 3 niveles del dataset, y por qué se redujo de 4 a 3?
**Respuesta esperada:** Se combinaron los grados "Normal" y "Leve" en una sola categoría para aumentar el consenso entre anotadores; quedó en Normal/Leve, Moderada, Severa.
**Fuente:** `The_RSNA_Lumbar_Degenerative_Imaging_Spine_Classif.pdf`, línea 175 y 528-529 del texto extraído.
**Verificado:** sí, confirmado con `pdftotext` sobre el PDF real.

### 3. Institución colombiana en el dataset
**Pregunta:** ¿Qué institución colombiana participó como anotadora en el dataset LumbarDISC, y quién fue la especialista?
**Respuesta esperada:** Fundación Santa Fe de Bogotá; la especialista es la Dra. Angela Guarnizo Capera.
**Fuente:** `The_RSNA_Lumbar_Degenerative_Imaging_Spine_Classif.pdf`, línea 92 del texto extraído.
**Verificado:** sí, exacto.

### 4. Kappa de estenosis del canal, MRI vs. MRM
**Pregunta:** ¿En cuánto mejoró el acuerdo interobservador entre radiólogos al agregar mielografía por resonancia (MRM) a la resonancia convencional, para evaluar estenosis del canal espinal?
**Respuesta esperada:** De moderado (kappa 0.40) con MRI sola, a bueno (kappa 0.60) con MRM.
**Fuente:** Al-Tameemi et al. (2017), Tabla 2, página 200-201.
**Verificado:** sí, exacto (confirmado con el PDF completo).

### 5. Kappa entre radiólogo y neurocirujano
**Pregunta:** ¿El acuerdo entre radiólogo y neurocirujano mejoró al agregar MRM?
**Respuesta esperada:** No — se mantuvo bajo/limitado (kappa 0.33-0.38), sin cambio significativo.
**Fuente:** Al-Tameemi et al. (2017), Tabla 2, página 201.
**Verificado:** sí, exacto.

### 6. Tamaño de muestra de Al-Tameemi et al.
**Pregunta:** ¿Cuántos pacientes y niveles de disco se evaluaron en el estudio de Al-Tameemi et al. sobre mielografía por resonancia?
**Respuesta esperada:** 30 pacientes, 150 niveles de disco intervertebral.
**Fuente:** Al-Tameemi et al. (2017), página 198-199.
**Verificado:** sí, exacto.

### 7. Mejor arquitectura para estenosis del canal espinal (SCS)
**Pregunta:** ¿Qué arquitectura de Vision Transformer obtuvo la mejor precisión de validación para clasificar estenosis del canal espinal, y cuál fue el valor?
**Respuesta esperada:** ViT-L/16, con 92.41% de precisión de validación (el resultado más alto de las 5 condiciones evaluadas).
**Fuente:** "Beyond Accuracy" (preprint 2026), tabla de resultados.
**Verificado:** sí, exacto, cotejado línea por línea contra el PDF.

### 8. Métrica CLOA
**Pregunta:** ¿Qué es la métrica CLOA (Condition-Level Ordinal Accuracy) y qué valor obtuvo para estenosis del canal espinal?
**Respuesta esperada:** Otorga crédito completo a aciertos exactos, parcial a errores adyacentes y cero a diferencias de dos grados; para SCS fue 95.79%.
**Fuente:** "Beyond Accuracy" (preprint 2026).
**Verificado:** sí, exacto.

### 9. Factores de riesgo de la estenosis lumbar
**Pregunta:** ¿Qué factores de riesgo para estenosis espinal lumbar menciona Bagley et al.?
**Respuesta esperada:** Obesidad, tabaquismo, factores genéticos no completamente elucidados, y edad como el factor más importante.
**Fuente:** Bagley et al. (2019), Abstract y sección "Introduction", página 1-3.
**Verificado:** sí, confirmado con el PDF completo.

### 10. Evidencia de nivel I en tratamiento de estenosis
**Pregunta:** ¿Existen recomendaciones de nivel I (la evidencia más fuerte) para el tratamiento de la estenosis lumbar, según Bagley et al.?
**Respuesta esperada:** No — el artículo aclara explícitamente que no pueden darse recomendaciones de nivel I por falta de evidencia concluyente.
**Fuente:** Bagley et al. (2019), Abstract, página 1.
**Verificado:** sí, exacto.

### 11. Modelo M-SCAN
**Pregunta:** ¿Qué es M-SCAN y qué AUROC reportó, sobre cuántos estudios?
**Respuesta esperada:** Modelo multietapa de Batra et al. que combina vistas sagitales y axiales con atención cruzada; AUROC de 0.971 sobre 1,975 estudios.
**Fuente:** Citado dentro de "Beyond Accuracy" (preprint 2026), y el paper original de Batra et al. en arXiv:2503.01634.
**Verificado:** sí, exacto, doble confirmación.

### 12. Método finite element de Xin Yi/Cai
**Pregunta:** ¿Qué tipo de estudio es el de Xin Yi (Cai) et al. sobre degeneración del disco L4-L5, y qué evalúa?
**Respuesta esperada:** Un estudio de elementos finitos (finite element study) que evalúa el efecto biomecánico de la degeneración del disco L4-L5 sobre la columna lumbar inferior.
**Fuente:** `OS-12-917.pdf`, título y abstract.
**Verificado:** sí.

### 13. Kappas del sistema de Miskin et al.
**Pregunta:** ¿Qué valores de kappa reportó el sistema de gradación de Miskin et al. entre especialistas no radiólogos, para las distintas regiones anatómicas?
**Respuesta esperada:** 0.702 (canal central), 0.544 (foraminal), 0.557 (artropatía facetaria), 0.323 (receso lateral/subarticular).
**Fuente:** Miskin et al. (2021), *Pain Medicine*, DOI 10.1093/pm/pnab098.
**Verificado:** sí, exacto (mismo caso documentado en el inventario de fallos).
**Nota:** esta pregunta es útil para volver a probar el sistema *después* de que Miskin ya esté correctamente incluido en el corpus — sirve como control de que el fallo anterior (citarlo sin tenerlo cargado) ya no se repite.

### 14. Paradigmas de IA según Abdelrahman et al.
**Pregunta:** ¿Qué paradigmas de arquitecturas de IA para análisis de RM lumbar describe Abdelrahman et al., y qué rango de desempeño reportan?
**Respuesta esperada:** Modelos híbridos, cascadas multietapa, fusión cross-modal y ensambles; con coeficientes Dice superiores a 0.90 y AUC de hasta 0.98.
**Fuente:** Abdelrahman et al. (2026), *Journal of Smart Algorithms and Applications*.
**Verificado:** sí, confirmado por Juan David con el PDF real.

---

## Preguntas SIN respuesta en el corpus — prueba de abstención (4)

### 15. Prevalencia en Colombia
**Pregunta:** Según estos documentos, ¿cuál es la prevalencia de espondilolistesis degenerativa en población colombiana?
**Respuesta esperada del sistema:** Debe decir explícitamente que no está en las fuentes.
**Ya probada:** sí — NotebookLM se abstuvo correctamente y no inventó una cifra (ver Tratamiento C de Camilo).

### 16. Resultados de la competencia Kaggle
**Pregunta:** ¿Qué equipo o modelo obtuvo el primer lugar en la competencia Kaggle RSNA 2024 Lumbar Spine Degenerative Classification, y qué puntaje logró?
**Respuesta esperada del sistema:** Debe abstenerse — ninguno de los 9 documentos del corpus reporta resultados de la tabla de posiciones (leaderboard) de la competencia.
**Por probar.**

### 17. Guía NASS
**Pregunta:** Según la guía clínica de la North American Spine Society (NASS) de 2013, ¿cuál es el tratamiento de primera línea recomendado para estenosis lumbar leve?
**Respuesta esperada del sistema:** Debe abstenerse o aclarar que solo tiene menciones indirectas de NASS citadas dentro de Bagley et al., no el documento original de la guía.
**Por probar.** (Riesgo de "casi acierto": el sistema podría mezclar lo poco que Bagley menciona sobre NASS con conocimiento externo — vale la pena observar con cuidado.)

### 18. Costos de la cirugía en el sistema de salud colombiano
**Pregunta:** ¿Cuál es el costo promedio de una cirugía de descompresión lumbar en el sistema de salud colombiano, según estos documentos?
**Respuesta esperada del sistema:** Debe abstenerse — ningún documento del corpus trata costos ni el sistema de salud colombiano (Bagley menciona costos en EE.UU., no en Colombia).
**Por probar.** (Pregunta trampa: si el sistema mezcla la cifra de EE.UU. de Bagley con "Colombia", sería un fallo de contaminación cruzada entre fuentes.)

---

## Resumen

- **14 preguntas con respuesta verificable**, todas con documento y ubicación exacta ya confirmados por el equipo antes de esta evaluación.
- **4 preguntas sin respuesta en el corpus**, una ya probada (abstención correcta), tres pendientes — dos de ellas (17 y 18) diseñadas como "preguntas trampa" que podrían inducir al sistema a mezclar información de fuentes reales de forma incorrecta, en vez de simplemente inventar de la nada.

## 1. El experimento

Se diseñó un experimento de tres tratamientos sobre 2 consultas bibliográficas reales del área del proyecto (acuerdo interobservador en estenosis lumbar, y modelos de deep learning sobre el dataset RSNA 2024): **A** = chat sin fuentes, **B** = buscador con bases reales, **C** = contexto cerrado (NotebookLM con nuestro corpus). Se clasificaron 30 referencias en total (5 por tratamiento y consulta), cada una por los dos integrantes de forma independiente.

- **Acuerdo bruto entre clasificadores:** 93.3% (28/30). Kappa de Cohen global = -0.0345
  (p=0.85); el valor negativo pese al alto acuerdo es un artefacto estadístico esperado
  cuando la distribución de categorías está muy desbalanceada (casi todo cae en
  "Utilizable") — no indica desacuerdo real.
- **Proporción utilizable por tratamiento** (IC 95%, Wilson): A = 100% (10/10),
  B = 100% (10/10), C = 90% (9/10, IC 59.6%–98.2%).
- El único caso "no utilizable" reveló un fallo real y documentado: NotebookLM citó
  valores de un artículo (Miskin et al., 2021) que **no estaba en el corpus** en el
  momento de la consulta — confirmado con fecha exacta por los dos integrantes.

## Herramienta elegida y comparación

Se comparó **NotebookLM** contra **Proyecto con archivos** (Claude/ChatGPT Projects) en 6 criterios: contexto cerrado, cita con localización, privacidad, costo, exportación APA 7, reproducibilidad. NotebookLM gana en 3 (contexto cerrado, cita con localización,costo), empata en 2, pierde en 1 (reproducibilidad del protocolo, compensadadocumentando por escrito el protocolo de prompts). Se eligió **NotebookLM**, principalmente por su capacidad de citar con localización exacta dentro del documento, verificada en la práctica durante el experimento.

- # 3. Sistema

**CORPUS**

## Tabla: Resumen de Fuentes

| N° / Archivo | Título Corto / Enfoque | Autores / Año | DOI / Identificador |
| :--- | :--- | :--- | :--- |
| **1. 073c3e60427a...** | Graduación simplificada en RM lumbar | Miskin et al. (2021) | [10.1093/pm/pnab098](https://doi.org/10.1093/pm/pnab098) |
| **2. A_Comprehensive...** | Revisión integral de IA en RM lumbar | Abdelrahman et al. (2026) | [10.66279/r8h6j935](https://doi.org/10.66279/r8h6j935) |
| **3. Anatomy-guided...** | Aprendizaje profundo guiado por anatomía | Chai et al. (2026) | [10.3389/fmed.2026.1848548](https://doi.org/10.3389/fmed.2026.1848548) |
| **4. OS-12-917.pdf** | Efecto biomecánico en elementos finitos (L4-L5) | Cai et al. (2020) | [10.1111/os.12703](https://doi.org/10.1111/os.12703) |
| **5. The_RSNA_Lumbar...** | Dataset RSNA LumbarDISC | Richards et al. / RSNA (2026) | [10.1148/ryai.250480](https://doi.org/10.1148/ryai.250480) |
| **6. al-tameemi_2017...** | Mielografía por RM y acuerdo inter-observador | Al-Tameemi et al. (2017) | [10.4184/asj.2017.11.2.198](https://doi.org/10.4184/asj.2017.11.2.198) |
| **7. bagley_2019.pdf** | Conceptos y manejo de estenosis lumbar | Bagley et al. (2019) | [10.12688/f1000research.16082.1](https://doi.org/10.12688/f1000research.16082.1) |
| **8. s00586-025-09179-z.pdf** | Avances y desafíos en la Resonancia asistida por IA | Zhao et al. (2025) | [10.1007/s00586-025-09179-z](https://doi.org/10.1007/s00586-025-09179-z) |
| **9. beyond_accuracy...** | Vision Transformers y métricas ordinales | Trînc et al. (2026) | [10.20944/preprints202608.1250.v1](https://doi.org/10.20944/preprints202608.1250.v1) |
| **10. medicina-61...** | IA en patología degenerativa lumbar (Review) | Trento et al. (2025) | [10.3390/medicina61081400](https://doi.org/10.3390/medicina61081400) |

---

## Análisis Detallado por Documento

### 1. `073c3e60427aacf6b4b5ee6f0c398401.pdf`
* **Título original:** *Simplified Universal Grading of Lumbar Spine MRI Degenerative Findings: Inter-Reader Agreement of Non-Radiologist Spine Experts*.
* **Autores:** Nityanand Miskin, Zacharia Isaac, Yi Lu, Melvin C. Makhni, Danielle L. Sarno, Timothy R. Smith, Jay M. Zampini y Jacob C. Mandell (Brigham and Women’s Hospital, Harvard Medical School).
* **Publicación:** *Pain Medicine* (2021).
* **DOI:** [10.1093/pm/pnab098](https://doi.org/10.1093/pm/pnab098).
* **Objetivo:** Describir un sistema de graduación multidisciplinario simplificado para hallazgos degenerativos en RM lumbar y evaluar el acuerdo inter-observador entre expertos no radiólogos.
* **Metodología:** 3 especialistas (neurocirugía, ortopedia, fisiatría) evaluaron de forma independiente 50 RM de columna lumbar (niveles L4–L5 y L5–S1) usando la escala propuesta. Se calculó el coeficiente kappa ($\kappa$) de Cohen.
* **Resultados clave:**
  * Estenosis del canal espinal: Acuerdo **sustancial** ($\kappa = 0,702$).
  * Estenosis foraminal y artropatía facetaria: Acuerdo **moderado** ($\kappa = 0,544$ y $\kappa = 0,557$).
  * Estenosis del receso lateral: Acuerdo **aceptable** ($\kappa = 0,323$).
* **Conclusión:** Proporciona un marco simplificado y estandarizado para la comunicación interdisciplinaria directa.
* **Cita recomendada:** Miskin et al. (2021). *Simplified Universal Grading of Lumbar Spine MRI Degenerative Findings*. Pain Medicine, doi:10.1093/pm/pnab098.

---

### 2. `A_Comprehensive_Review_of_Artificial_Intelligence_.pdf`
* **Título original:** *A Comprehensive Review of Artificial Intelligence for Lumbar Spine MRI Analysis and Clinical Assessment*.
* **Autores:** Marwa A. Abdelrahman, Ahmed Sayed Abd El Basset y Ahmed A. Elngar.
* **Publicación:** *Journal of Smart Algorithms and Applications* (2026).
* **DOI:** [10.66279/r8h6j935](https://doi.org/10.66279/r8h6j935).
* **Objetivo:** Ofrecer una revisión exhaustiva e integrada sobre el uso de IA en RM lumbar para enfermedad discal degenerativa (IVDD), hernia discal (DH) y estenosis espinal (LSS).
* **Metodología:** Síntesis de canalizaciones computacionales conectando la anatomía clínica con modelos deep learning (CNN, U-Net, YOLO, Transformers) y datasets públicos (SPIDER, LumbarDISC, LSpineSMRI).
* **Resultados clave:** Categoriza los enfoques en 4 paradigmas (híbridos, cascadas multietapa, fusión cross-modal y ensambles). Destaca coeficientes Dice > 0,90 en segmentación y AUC hasta 0,98 en estenosis.
* **Conclusión:** Resalta las barreras para el despliegue clínico real: heterogeneidad de datos, falta de validación externa e interpretabilidad.
* **Cita recomendada:** Abdelrahman et al. (2026). *A Comprehensive Review of Artificial Intelligence for Lumbar Spine MRI Analysis*. J Smart Algor Appl, ISSN: 3070-4189.

---

### 3. `Anatomy-guided_context-aware_deep_learning_for_lum.pdf`
* **Título original:** *Anatomy-guided context-aware deep learning for lumbar degenerative disease grading and burden-aware risk assessment on MRI*.
* **Autores:** Zhijin Chai, Chen Liu, Rujie Qin, Dexuan Zhao y Ankang Shi.
* **Publicación:** *Frontiers in Medicine* (2026).
* **DOI:** [10.3389/fmed.2026.1848548](https://doi.org/10.3389/fmed.2026.1848548).
* **Objetivo:** Desarrollar un marco de aprendizaje profundo guiado por anatomía y multisecuencia para clasificar la patología degenerativa por nivel y evaluar el riesgo global a nivel de paciente.
* **Metodología:** Marco de 3 etapas: segmentación anatómica preentrenada, extracción de biomarcadores cuantitativos y un Transformer para dependencias contextuales entre niveles. Introduce el índice CSDS (*Clinically Significant Degeneration Score*).
* **Resultados clave:** Macro F1-score de 0,783, $\kappa$ de Cohen de 0,765, Weighted Log Loss de 0,463 y AUC a nivel de paciente de 0,891.
* **Conclusión:** Incorporar prioris anatómicos explícitos supera significativamente el análisis de cortes aislados.
* **Cita recomendada:** Chai et al. (2026). *Anatomy-guided context-aware deep learning for lumbar degenerative disease grading*. Front Med, doi:10.3389/fmed.2026.1848548.

---

### 4. `OS-12-917.pdf`
* **Título original:** *Biomechanical Effect of L4–L5 Intervertebral Disc Degeneration on the Lower Lumbar Spine: A Finite Element Study*.
* **Autores:** Xin-yi Cai, Meng-si Sun, Yun-peng Huang, Zi-xuan Liu, Chun-jie Liu, Cheng-fei Du y Qiang Yang.
* **Publicación:** *Orthopaedic Surgery* (2020).
* **DOI:** [10.1111/os.12703](https://doi.org/10.1111/os.12703).
* **Objetivo:** Evaluar mediante simulación computacional de elementos finitos los efectos biomecánicos de la degeneración en L4–L5 sobre la columna lumbar inferior.
* **Metodología:** Modelo 3D no lineal de elementos finitos L3–S1. Simulación de degeneración discal leve, moderada y severa en L4–L5 bajo compresión (500 N) y momentos de flexión/extensión/rotación.
* **Resultados clave:** La degeneración en L4–L5 redujo su rango de movimiento (ROM) e presión intradiscal (IDP). Los niveles adyacentes (L3–L4 y L5–S1) experimentaron un aumento compensatorio marcado en ROM (1,88° a 8,19°) y carga en articulaciones facetarias.
* **Conclusión:** La alteración en un segmento genera sobrecarga mecánica en los niveles vecinos, acelerando su degeneración.
* **Cita recomendada:** Cai et al. (2020). *Biomechanical Effect of L4–L5 Intervertebral Disc Degeneration on the Lower Lumbar Spine*. Orthop Surg.

---

### 5. `The_RSNA_Lumbar_Degenerative_Imaging_Spine_Classif.pdf`
* **Título original:** *The RSNA Lumbar Degenerative Imaging Spine Classification (LumbarDISC) Dataset*.
* **Autores:** Tyler J. Richards, Adam E. Flanders, Errol Colak et al. / Grupo RSNA.
* **Publicación:** *Radiology: Artificial Intelligence* (2026).
* **DOI:** [10.1148/ryai.250480](https://doi.org/10.1148/ryai.250480).
* **Objetivo:** Presentar el dataset multicéntrico RSNA LumbarDISC para investigación y desarrollo de IA en espondilosis lumbar.
* **Metodología:** Integración de RM de 2.697 pacientes (8.593 series) de 8 instituciones en 6 países. Anotación experta de 5 condiciones degenerativas en 5 niveles lumbares en escala ordinal.
* **Resultados clave:** Publicación del mayor recurso abierto estandarizado internacionalmente para diagnóstico por IA de estenosis lumbar.
* **Conclusión:** Ofrece una referencia universal para mitigar la variabilidad inter-observador y entrenar modelos computacionales robustos.
* **Cita recomendada:** Richards et al. (2026). *The RSNA Lumbar Degenerative Imaging Spine Classification (LumbarDISC) Dataset*. Radiol AI, doi:10.1148/ryai.250480.

---

### 6. `al-tameemi_2017.pdf`
* **Título original:** *Using Magnetic Resonance Myelography to Improve Interobserver Agreement in the Evaluation of Lumbar Spinal Canal Stenosis and Root Compression*.
* **Autores:** Haider Najim Al-Tameemi, Sattar Al-Essawi, Mahmud Shukri y Farah Kasim Naji.
* **Publicación:** *Asian Spine Journal* (2017).
* **DOI:** [10.4184/asj.2017.11.2.198](https://doi.org/10.4184/asj.2017.11.2.198).
* **Objetivo:** Determinar si la Mielografía por RM (MRM) junto a la RM convencional mejora el acuerdo entre observadores.
* **Metodología:** Estudio transversal en 30 pacientes (150 niveles discales) evaluados por dos radiólogos y un neurocirujano mediante RM sola y RM + MRM.
* **Resultados clave:**
  * Estenosis del canal: El acuerdo entre radiólogos aumentó de moderado ($\kappa = 0,40$) a bueno ($\kappa = 0,60$).
  * Compresión radicular: El acuerdo entre radiólogos mejoró de $\kappa = 0,57$ a $\kappa = 0,73$.
* **Conclusión:** La MRM aporta un mapa líquido objetivo que reduce la variabilidad diagnóstica subjetiva.
* **Cita recomendada:** Al-Tameemi et al. (2017). *Using Magnetic Resonance Myelography to Improve Interobserver Agreement*. Asian Spine J, doi:10.4184/asj.2017.11.2.198.

---

### 7. `bagley_2019.pdf`
* **Título original:** *Current concepts and recent advances in understanding and managing lumbar spine stenosis*.
* **Autores:** Carlos Bagley, Matthew MacAllister, Luke Dosselman, Jessica Moreno, Salah G. Aoun y Tarek Y. El Ahmadieh.
* **Publicación:** *F1000Research* (2019).
* **DOI:** [10.12688/f1000research.16082.1](https://doi.org/10.12688/f1000research.16082.1).
* **Objetivo:** Revisión integral sobre patofisiología, diagnóstico y manejo de la estenosis espinal lumbar (LSS).
* **Metodología:** Síntesis narrativa de aspectos anatómicos, claudicación neurogénica, técnicas de imagen e intervenciones conservadoras vs. quirúrgicas.
* **Resultados clave:** Analiza factores de riesgo (genética, edad, estilo de vida) y el rol de la cirugía descompresiva en casos sintomáticos severos.
* **Conclusión:** Resalta la importancia del abordaje multidisciplinario y la necesidad de guías de mayor nivel de evidencia.
* **Cita recomendada:** Bagley et al. (2019). *Current concepts and recent advances in understanding and managing lumbar spine stenosis*. F1000Research, doi:10.12688/f1000research.16082.1.

---

### 8. `s00586-025-09179-z.pdf`
* **Título original:** *Advances and challenges in AI-assisted MRI for lumbar disc degeneration detection and classification*.
* **Autores:** Peng Zhao, Shan Zhu.
* **Publicación:** *European Spine Journal* (2026).
* **DOI:** [10.1007/s00586-025-09179-z](https://doi.org/10.1007/s00586-025-09179-z).
* **Objetivo:**  Proporcionar una visión general sobre las aplicaciones de Inteligencia Artificial (aprendizaje automático y aprendizaje profundo) para la detección y clasificación automatizada de la degeneración del disco intervertebral mediante resonancia magnética.
* **Metodología:** Revisión estructurada a partir de una búsqueda sistemática realizada por dos radiólogos en las bases de datos PubMed, Embase y Web of Science. Se evaluaron y sintetizaron 17 estudios representativos (publicados entre 2014 y 2024), desde clasificadores tradicionales (SVM, Random Forest) hasta redes neuronales convolucionales (CNN, SpineNet, ResNet, U-Net) y modelos híbridos combinados con Transformers.
* **Resultados clave:** Los sistemas de IA alcanzaron una alta precisión y reproducibilidad en la graduación automatizada de IDD bajo la escala Pfirrmann.
* **Conclusión:** La IA aplicada a la RM lumbar posee un gran potencial para mejorar la eficiencia y eliminar la subjetividad en el diagnóstico de la degeneración discal, sin embargo su implementación clínica real exige superar retos en cuanto a la generalizabilidad entre distintos centros, la heterogeneidad de los datos, la interpretabilidad de los modelos y la realización de validaciones prospectivas a gran escala.
* **Cita recomendada:** Zhao, P., & Zhu, S. (2026). Advances and challenges in AI-assisted MRI for lumbar disc degeneration detection and classification. European Spine Journal, 35(3), 1291–1300 , doi:10.1007/s00586-025-09179-z.

---

### 9. `beyond_accuracy_2026.pdf`
* **Título original:** *Beyond Accuracy: Multi-Level Ordinal Assessment of Lumbar Spine Degeneration from Multiplanar MRI Using the RSNA 2024 (LumbarDISC) Dataset and Condition-Specific ViTs*.
* **Autores:** Emanuel-Crăciun Trînc, Cosmin Ancuți, Codruța Ancuți y Emil-Radu Iacob.
* **Publicación:** *Preprints.org* (2026).
* **DOI:** [10.20944/preprints202608.1250.v1](https://doi.org/10.20944/preprints202608.1250.v1).
* **Objetivo:** Proponer una graduación ordinal multinivel con Vision Transformers (ViT) sobre el dataset RSNA LumbarDISC.
* **Metodología:** Entrenamiento de 5 pipelines ViT especializados. Desarrollo de las métricas ordinales CLOA (Condition-Level) y PLOA (Patient-Level) para considerar la severidad de las discrepancias diagnósticas.
* **Resultados clave:** Precisión global de 82% a 92%. Demuestra que las métricas ordinales reflejan con mayor fidelidad la gravedad clínica del error diagnóstico.
* **Conclusión:** Permite integrar modelos de IA en asistentes explicables para la generación de reportes estructurados.
* **Cita recomendada:** Trînc et al. (2026). *Beyond Accuracy: Multi-Level Ordinal Assessment of Lumbar Spine Degeneration*. Preprints.org, doi:10.20944/preprints202608.1250.v1.

---

### 10. `medicina-61-01400.pdf`
* **Título original:** *Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology: A Narrative Review*.
* **Autores:** Alessandro Trento, Salvatore Rapisarda, Nicola Bresolin, Andrea Valenti y Enrico Giordan.
* **Publicación:** *Medicina* (2025).
* **DOI:** [10.3390/medicina61081400](https://doi.org/10.3390/medicina61081400).
* **Objetivo:** Evaluar el impacto de la IA en la gestión de la patología degenerativa lumbar.
* **Metodología:** Revisión narrativa de 96 estudios (2015-2025) abarcando diagnóstico, predicción de resultados y cirugía de fusión.
* **Resultados clave:** La IA destaca en diagnóstico por imagen, predicción de estancia/complicaciones y soporte en planificación quirúrgica.
* **Conclusión:** Muestra el camino hacia la medicina personalizada en columna, enfatizando la necesidad de validación prospectiva.
* **Cita recomendada:** Trento et al. (2025). *Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology*. Medicina, doi:10.3390/medicina61081400.

**PROTOCOLOS DE PROMPTS — v1.0**

## 1. Identificación del Sistema
* **Proyecto:** Agente de Consultoría Bioestadística (Estenosis Lumbar / RSNA 2024).
* **Versión del Protocolo:** v1.0
* **Fecha de emisión:** 27 de septiembre de 2026.

## 2. Configuración del Rol
El agente está configurado para operar estrictamente bajo el siguiente rol:
> *"Eres un consultor bioestadístico senior especializado en análisis clínico e interpretación de datos de resonancia magnética para estenosis lumbar. Tu objetivo es asistir de manera rigurosa, transparente y metodológicamente reproducible."*

## 3. Fuentes Permitidas y Restricciones
* **Corpus autorizado:** Únicamente los documentos PDF del estado del arte almacenados localmente en la biblioteca del proyecto y el dataset tabular estructurado de Kaggle (RSNA 2024).
* **Prohibición de alucinación:** Queda estrictamente prohibido utilizar conocimiento general no verificado para emitir juicios clínicos o estadísticos específicos del corpus.

## 4. Formato de Cita Solicitado
Toda afirmación, métrica o hallazgo extraído de las fuentes debe ir acompañado obligatoriamente de su referencia cruzada en formato estándar:
* **Estructura:** `[Autor, Año] + (Documento, Página o sección exacta)`.

## 5. Protocolo de Abstención
Ante una consulta cuya respuesta **no se encuentre explícitamente** en los documentos del corpus o en el dataset, el agente tiene la instrucción obligatoria de responder de la siguiente manera:
> *"La información solicitada no se encuentra disponible en las fuentes documentales ni en los datos provistos por el corpus del proyecto."*

## 6. Historial de Cambios
* **v1.0 (Versión inicial):** Directrices sobre restricción de fuentes y obligatoriedad de abstención ante vacíos informativos.

# 4. Tabla de trazabilidad

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
| 7.2 | "Explica cómo los modelos de IA están transformando el diagnóstico y pronóstico de la estenosis espinal y hernias discales, siendo herramientas útiles para agilizar el flujo de trabajo y la planificación médica" | Bibliografía dice: Abdelrahman et al. (2026), *J. Software Engineering and Applications* | ✅ **Abdelrahman et al. (2026) SÍ existe** (confirmado por Juan David, DOI `10.66279/r8h6j935`, autores exactos) — pero la revista real es *Journal of Smart Algorithms and Applications*, no "Software Engineering" (otro caso del mismo patrón de citas mal formateadas). **El problema real:** el PDF que se guardó originalmente en el repositorio bajo esta cita era el de **Trento et al. (2025)**, un artículo distinto — el archivo equivocado, no la referencia inventada. | ⚠️ El contenido de Abdelrahman et al. (revisión de 4 paradigmas de IA: híbridos, cascadas multietapa, fusión cross-modal, ensambles; Dice>0.90, AUC hasta 0.98) es plausible como fuente de esta frase, pero falta cotejarla línea por línea contra la diapositiva 7.2 exacta. | Juan David + equipo, 26-sep-2026 — **Hallazgo 1 actualizado, ver inventario de fallos** |
| 7.3 | "Este artículo muestra como algunas patologías pueden tener una misma causa de origen y relacionarse." | Furman, M. B. (2024). Spinal Stenosis. Medscape | ⚠️ Existe pero es fuente terciaria (enciclopedia clínica, no estudio original) con acceso restringido por login | ⚠️ Sin confirmar — no se pudo leer el contenido completo por la barrera de acceso | Pendiente |

## Diapositiva 8

| # | Afirmación de la diapositiva | Fuente citada | ¿Fuente real? | ¿Coincide el contenido? | Verificado por / fecha |
|---|---|---|---|---|---|
| 8.1 | "Desarrollado por un grupo de especialistas en neurocirugía, ortopedia, fisiatría, radiología; compara concordancia entre especialidades y no solo entre radiólogos." | Miskin, N., et al. (2021) | ✅ Confirmado por Juan David — real, *Pain Medicine*, DOI `10.1093/pm/pnab098`, autores Miskin, Isaac, Lu, Makhni, Sarno, Smith, Zampini, Mandell | ❌ **Fallo confirmado del sistema, no de la bibliografía.** El artículo sí respalda el contenido de la diapositiva (kappas 0.702/0.544/0.557/0.323 entre especialistas no radiólogos). El problema es que, cuando corrimos el Tratamiento C en NotebookLM, **el PDF de Miskin todavía no estaba subido al notebook** — Juan David lo subió un día después, junto con otras fuentes. Es decir, NotebookLM citó estos valores exactos como si vinieran del corpus de 6 documentos que sí tenía cargados en ese momento, cuando en realidad no estaban ahí. **Este es el caso de fallo oficial del sistema para la semana 3.** | Juan David + equipo, 26-sep-2026 — confirmado |
| 8.2 | "Muestra una combinación entre mielografía y resonancia magnética." | Al-Tameemi, H.N., et al. (2017) | ✅ Sí, *Asian Spine Journal*, DOI `10.4184/asj.2017.11.2.198` | ✅ **Coincide, pero es una síntesis muy pobre** (confirmado con el PDF completo, página 200-201, Tablas 2 y 3). 30 RM lumbares (150 niveles de disco) revisadas por dos radiólogos y un neurocirujano, comparando MRI sola vs. MRI + mielografía (MRM); el acuerdo interobservador mejoró de moderado (kappa 0.4) a bueno (kappa 0.6) para estenosis del canal, y de moderado a bueno (kappa 0.57→0.73) para compresión radicular. La diapositiva reduce todo esto a "muestra una combinación" y omite el hallazgo real (que la combinación mejora el acuerdo, medido con kappa) — que es justo el dato con el que su propio anteproyecto podría conectar, ya que ustedes también miden acuerdo con kappa. | Leído completo, página 200-201 (Tablas 2 y 3) — 24-sep-2026 |
| 8.3 | "Con 37 médicos de seis especialidades, revisa la exactitud general pre-intervención con y sin capacitación." | Walsh, P.J., et al. (2026) | ✅ Sí, *Academic Radiology* — pero **nombres de autores mal separados en la bibliografía** ("Walsh, J. Un, J.L." en vez de Walsh, Lee, Lipetz, Walz) | ✅ **Coincide** — se confirmó vía resumen del artículo: 37 médicos, seis especialidades, exactitud mejoró de 54.5% a 61.2% tras capacitación estructurada | Búsqueda dirigida, 22-sep-2026 — cita a corregir, contenido correcto |

## Diapositiva 9

| # | Afirmación de la diapositiva | Fuente citada | ¿Fuente real? | ¿Coincide el contenido? | Verificado por / fecha |
|---|---|---|---|---|---|
| 9.1 | "Introduce Deep Learning guiado por la anatomía del paciente para la clasificación de la patología y la evaluación del riesgo." | Chai, Z., et al. (2026), Frontiers in Medicine | ✅ **Confirmada por Juan David** — DOI real `10.3389/fmed.2026.1848548`, autores exactos (Chai, Liu, Qin, Zhao, Shi), publicado 26-jun-2026. *Corrección: mis tres búsquedas anteriores no la encontraron; eso fue una limitación de la búsqueda, no evidencia de que no existiera.* | ✅ **Coincide bien.** El PDF describe un framework de 3 etapas (segmentación anatómica + biomarcadores cuantitativos + Transformer) con un índice CSDS (Clinically Significant Degeneration Score), Macro F1=0.783, kappa de Cohen=0.765, AUC a nivel de paciente=0.891 — coincide con "guiado por la anatomía... clasificación de la patología y evaluación del riesgo". | Juan David + verificación cruzada, 26-sep-2026 |
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

# 5. Declaración del uso de IA

Se usaron Google Gemini y Claude como una herramienta de apoyo, para hacer el código 
ejecutable y consultas técnicas, teniendo también la validación posterior de lo que arroja,
sin poner de inmediato cada cosa que la IA arrojó, sino revisándola primero mediante 
ejecución de los códigos y revisión de fuentes y recursos.
El agente de IA usado no dio diagnósticos médicos ni recomendaciones clínicas, solo 
análisis bioestadístico de datos según los requerimientos.
