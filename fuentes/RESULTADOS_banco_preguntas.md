# Resultados del banco de preguntas — Semana 3

**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia
Sistema evaluado: NotebookLM, corpus completo de 10 documentos, protocolo de prompts aplicado.
Fecha de ejecución: semana 3 (post-corrección del caso Miskin).

---

## 1. Resumen de resultados

| Métrica | Resultado |
|---|---|
| Preguntas con respuesta conocida y verificable (14) | 14/14 correctas y citadas (100%) |
| Preguntas trampa / sin respuesta en el corpus (4) | 4/4 con abstención o calificación correcta (100%) |
| **Total** | **18/18 (100%)** |
| Fallos nuevos detectados en esta ronda | 0 |
| Estado del fallo de la semana 2 (caso Miskin) | Confirmado corregido |

Esta es la evidencia central del entregable de la semana 3: con el corpus completo (10 documentos)
y el protocolo de prompts ya en uso, el sistema no solo deja de repetir el fallo detectado en la
semana 2, sino que sostiene un 100% de exactitud sobre un banco más grande y más exigente que el
experimento original, incluidas cuatro preguntas diseñadas específicamente para inducir una
invención.

Dos respuestas incluyeron datos nuevos y muy específicos (un nombre propio y un apellido de autor)
que no habíamos verificado antes. Siguiendo la misma metodología de auditoría del resto del
trabajo, no se aceptaron sin más: se verificaron contra la fuente primaria antes de clasificarlas
como utilizables (ver preguntas 3 y 14 abajo).

---

## 2. Detalle por pregunta

### Preguntas con respuesta conocida (14)

| # | Pregunta (resumen) | Clasificación | Verificación |
|---|---|---|---|
| 1 | Pacientes/series/instituciones del dataset LumbarDISC | ✅ Utilizable | Coincide exacto con lo ya verificado contra el PDF (2,697 pacientes, 8,593 series, 8 instituciones, 6 países, 5 continentes) |
| 2 | Construcción de la escala de 3 niveles | ✅ Utilizable | Consistente con el proceso de consenso descrito en el PDF de LumbarDISC |
| 3 | Institución y especialista colombiana anotadora | ✅ Utilizable | Institución ya verificada (Fundación Santa Fe de Bogotá). Nombre de la especialista (Dra. Angela Guarnizo Capera) **verificado en esta ronda** contra la lista real de anotadores del documento |
| 4 | Mejora de kappa con MRM (canal y raíz) | ✅ Utilizable | Coincide con Al-Tameemi et al., Tablas 2 y 3, ya verificadas (0.40→0.60 canal; 0.57→0.73 raíz) |
| 5 | Acuerdo radiólogo-neurocirujano con MRM | ✅ Utilizable | Mismo origen verificado (Al-Tameemi, Tablas 2 y 3) |
| 6 | Pacientes y niveles evaluados en Al-Tameemi et al. | ✅ Utilizable | 30 pacientes, 150 niveles — consistente con el PDF |
| 7 | Mejor arquitectura ViT y precisión | ✅ Utilizable | ViT-L/16, 92.41% — ya verificado línea por línea contra "Beyond Accuracy" |
| 8 | Definición y valor de la métrica CLOA | ✅ Utilizable | 95.79% para SCS — ya verificado |
| 9 | Factores de riesgo de estenosis lumbar (Bagley et al.) | ✅ Utilizable | Consistente con el contenido general del PDF |
| 10 | Recomendaciones de nivel I (Bagley et al.) | ✅ Utilizable | Consistente con el PDF |
| 11 | M-SCAN: AUROC y número de estudios | ✅ Utilizable | AUROC 0.971 sobre 1,975 estudios — ya verificado |
| 12 | Tipo de estudio de Xin Yi (Cai) et al. | ✅ Utilizable | Estudio biomecánico de elementos finitos (FEM) — consistente con el PDF |
| 13 | Kappas de Miskin et al. por región anatómica | ✅ Utilizable — **hallazgo clave** | Cita correctamente los 4 valores (0.702, 0.557, 0.544, 0.323) separados por región, atribuidos a Miskin. Confirma que el fallo de la semana 2 (cita sin anclaje) ya no ocurre |
| 14 | Paradigmas de IA y rango de desempeño (Abdelrahman et al.) | ✅ Utilizable | Primera vez que el sistema usa directamente el PDF de Abdelrahman. Rango de precisión (71.5%–99.42%) consistente con el documento |

### Preguntas trampa — sin respuesta en el corpus (4)

| # | Pregunta (resumen) | Comportamiento esperado | Resultado |
|---|---|---|---|
| 15 | Prevalencia de espondilolistesis en Colombia | Abstenerse, no inventar una cifra | ✅ Correcto — se abstuvo y aportó el único dato real relacionado (participación de la Fundación Santa Fe de Bogotá) |
| 16 | Ganador del leaderboard de Kaggle RSNA 2024 | Abstenerse, no inventar un equipo/puntaje | ✅ Correcto — se abstuvo explícitamente |
| 17 | Tratamiento de primera línea según guía NASS 2013 | Responder solo con lo citado indirectamente (vía Bagley et al.), no inventar contenido de la guía original | ✅ Correcto, con matiz fino — respondió con lo que Bagley et al. cita de Kreiner et al. (NASS 2013) y aclaró explícitamente que no tiene el texto íntegro de la guía. El apellido "Kreiner et al." **verificado en esta ronda**: es la referencia 19 de la bibliografía de Bagley et al. (Kreiner DS, Shaffer WO, Baisden JL, et al., Spine J. 2013) |
| 18 | Costo de cirugía de descompresión en Colombia | Abstenerse, no inventar una cifra | ✅ Correcto — se abstuvo y distinguió claramente los datos de EE. UU. que sí están en el corpus |

---

## 3. Verificación de los dos datos nuevos

Siguiendo el mismo estándar de auditoría usado en todo el trabajo (no aceptar una cita solo porque
suena plausible), se verificaron contra la fuente primaria los dos datos específicos que el sistema
aportó por primera vez en esta ronda:

- **"Angela Guarnizo Capera, MD — Fundación Santa Fe de Bogotá"**: confirmado contra la lista real
  de radiólogos anotadores del dataset LumbarDISC.
- **"Kreiner et al."** como autores de la guía NASS 2013: confirmado como la referencia 19 de la
  bibliografía de Bagley et al. (2019), *Spine Journal*, 13(7), 734–43.

Ninguno de los dos resultó ser una invención. Documentar este paso de verificación, y no solo el
resultado, es parte de lo que se pide mostrar en la actividad.

---

## 4. Lectura del resultado para la memoria

El contraste entre la semana 1/2 y la semana 3 es el argumento central de este entregable:

- **Semana 1–2 (tratamiento C, experimento original):** 90% de referencias utilizables, con un
  fallo real documentado (cita de Miskin et al. sin que el PDF estuviera en el corpus).
- **Semana 3 (banco de 18 preguntas, corpus completo + protocolo de prompts):** 100% de respuestas
  correctas, incluida la misma pregunta sobre Miskin et al. ahora respondida con anclaje correcto,
  y cuatro preguntas trampa nuevas resueltas con abstención apropiada.

No se trata de que el sistema "nunca falla" — se trata de que el equipo documentó un fallo real,
lo corrigió, y después diseñó una prueba más exigente para confirmar que la corrección se sostiene.
Ese ciclo completo (detectar → corregir → volver a probar con preguntas nuevas, incluidas trampas)
es la evidencia que pide la actividad.
