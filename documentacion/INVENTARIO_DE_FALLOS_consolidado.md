# Inventario de fallos — Actividad "Nada sin fuente"

Consolidado de los inventarios individuales de los dos integrantes del equipo.
Cada uno documentó al menos tres fallos, detectados de forma independiente.

---

## INVENTARIO DE FALLOS — Juan David Cacua

### Fallo 1

**Herramienta:** Gemini

**Qué generó:** Un código para análisis descriptivo de los datos

**Qué estaba mal:** Una función inexistente de R (`tidy`)

**Cómo lo detecté:** Cuando corría el código y nada corregía el error

**Qué me costó:** Tiempo y ajuste manual

**Qué lo habría evitado:** Preparar mejor el agente y darle más contexto

> **Nota pendiente de revisar antes de la sustentación:** `tidy()` sí es una función
> real de R, del paquete `broom` (parte del tidyverse). Vale la pena confirmar si el
> error real fue usarla sin cargar `library(broom)` primero (lo que sí da un error de
> "función no encontrada" aunque la función exista), o si fue otra función con nombre
> parecido la que en realidad no existía. Ajustar la descripción según lo que diga el
> mensaje de error real de R, para que el fallo quede bien caracterizado.

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

> Este es, de los tres, el fallo más útil para la sustentación: tiene fecha exacta,
> confirmación cruzada de dos personas, y un mecanismo claro (herramienta de contexto
> cerrado que igual mezcla conocimiento externo cuando el tema es muy conocido). Lo
> proponemos como el **caso de fallo oficial** para el entregable de la semana 3.

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

**Nota de corrección:** una versión anterior de este inventario incluía "Chai et al.
no localizable" como fallo. Se retiró porque Juan David encontró el artículo real
(DOI `10.3389/fmed.2026.1848548`) — no era una referencia inventada, sino una
limitación de las búsquedas que hicimos en su momento. Queda como ejemplo, en el
propio proceso de armar este inventario, de por qué "no encontrar algo" no es lo
mismo que "confirmar que no existe".
