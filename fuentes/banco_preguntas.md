# Banco de preguntas — Evaluación del sistema (Semana 3)

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
