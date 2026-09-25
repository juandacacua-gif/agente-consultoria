# Inventario de fallos — Actividad "Nada sin fuente"

Consolidado de los inventarios individuales de los dos integrantes del equipo.
Cada uno documentó al menos tres fallos, detectados de forma independiente.

---

## INVENTARIO DE FALLOS — Juan David Cacua

### Fallo 1

**Herramienta:** Gemini

**Qué generó:** Un código para análisis descriptivo de los datos

**Qué estaba mal:** Una función equivocada de R (`tidy`) que además no cargaba, porque 
el paquete `broom`, al que pertenece la función, no estaba cargado.

**Cómo lo detecté:** Cuando corría el código y nada corregía el error, la funcion `tidy`
es una función hecha para extraer los coeficientes y parámetros de un modelo estadístico,
pero el codigo generado por IA lo pretendía usar como parte del proceso para hacer unos
gráficos.

**Qué me costó:** Tiempo y ajuste manual, además de tener que consultar nuevamente al agente.

**Qué lo habría evitado:** Preparar mejor el agente y darle más contexto

### Fallo 2

**Herramienta:** Gemini

**Qué generó:** Un código para imputar los datos faltantes

**Qué estaba mal:** La elección de regresión politómica en lugar de regresión logística ordinal

**Cómo lo detecté:** Cuando comparaba con las respuestas que daba Gemini sin iniciar sesión

**Qué me costó:** Tiempo en la revisión conceptual y cambio de método

**Qué lo habría evitado:** Preparar mejor al agente para este tipo de procesos

### Fallo 3

**Herramienta:** Gemini

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

**Herramienta:** Claude (búsqueda web dirigida para localizar la referencia)

**Qué generó:** Al intentar localizar la referencia "Chai, Z., Liu, C., Qin, R., Zhao, D., Shi, A. (2026). Anatomy-guided context-aware deep learning for lumbar degenerative disease grading and burden-aware risk assessment on MRI. Frontiers in Medicine", citada en la diapositiva 9 de nuestro anteproyecto, hicimos tres búsquedas con términos distintos.

**Qué estaba mal:** No encontramos ese artículo con ese título, esos autores ni en esa revista en ningún lugar. Frontiers in Medicine es de acceso abierto por defecto, así que si existiera debería aparecer fácilmente indexado, como sí pasó con otras dos referencias que buscamos de la misma manera (Al-Tameemi et al. y Bagley et al., ambas confirmadas sin problema). Todo apunta a que es una referencia inventada que se coló en algún punto de la elaboración del anteproyecto original, con apariencia perfectamente creíble (nombres de autores plausibles, título coherente con el tema, revista real).

**Cómo lo detecté:** Verificando cada referencia contra una fuente externa real (Frontiers, PubMed, DOAJ), en vez de asumir que estaba bien solo porque figuraba en la bibliografía con formato correcto.

**Qué me costó:** Tiempo de búsqueda repetida sin resultado, y la incertidumbre de no poder confirmar al 100% que no existe (solo puedo decir que no la encontré, no que sea imposible que exista).

**Qué lo habría evitado:** Exigir un enlace o DOI verificable para cada referencia en el momento de escribir el anteproyecto original, no después.

### Fallo 3

**Herramienta:** Claude (lectura y cotejo de PDF completos contra las diapositivas)

**Qué generó:** Al leer el cuerpo completo del preprint "Beyond Accuracy: Multi-Level Ordinal Assessment of Lumbar Spine Degeneration..." (citado en la diapositiva 7) y compararlo con lo que dice esa diapositiva, encontramos dos problemas en la misma referencia.

**Qué estaba mal:** Primero, la bibliografía del anteproyecto cita el autor como "Preprints." —el nombre de la plataforma donde se publicó, no de una persona— cuando los autores reales son Trînc, E.C., Ancuți, C., Ancuți, C. e Iacob, E.R. Segundo, la diapositiva describe el paper como si propusiera "modelos estadísticos" para atender "el enorme desbalance de datos", pero el artículo real usa cinco pipelines de Vision Transformers (un método de deep learning) y explica la insuficiencia de la exactitud convencional por la complejidad de evaluar múltiples condiciones y niveles a la vez, no por desbalance de clases.

**Cómo lo detecté:** Leyendo el PDF completo (no solo el resumen) y comparando frase por frase contra lo que dice nuestra diapositiva, en vez de confiar en que el resumen de la diapositiva era fiel al artículo solo porque la referencia bibliográfica apuntaba a un documento real.

**Qué me costó:** Tener que releer el paper completo para ubicar la sección exacta que contradice la caracterización de la diapositiva, y ahora corregir tanto el nombre de los autores en la bibliografía como la descripción del método en el estado del arte.

**Qué lo habría evitado:** No conformarme con que la referencia "existiera" — verificar también que el contenido descrito en la diapositiva correspondiera de verdad a lo que dice el documento citado, sección por sección.

---

## Resumen del equipo

| # | Fallo | Integrante | Tipo |
|---|---|---|---|
| 1 | Función de R mal caracterizada (`tidy`) — *descripción pendiente de ajustar* | Juan David | Código / herramienta |
| 2 | Regresión politómica en vez de ordinal | Juan David | Conceptual / estadístico |
| 3 | Orden de factores en gráfico | Juan David | Código, menor |
| 4 | Trento citado como Abdelrahman | Camilo | Cita bibliográfica — fuente equivocada |
| 5 | Chai et al. no localizable | Camilo | Cita bibliográfica — fuente inexistente |
| 6 | Beyond Accuracy: autor real omitido + método mal descrito | Camilo | Cita bibliográfica + contenido |

Seis fallos documentados entre los dos, con variedad de tipos (código, estadístico,
bibliográfico y de fidelidad de contenido) — más que suficiente frente al mínimo de
tres por persona que pide la actividad.
