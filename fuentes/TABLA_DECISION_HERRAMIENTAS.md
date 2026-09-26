# Tabla de decisión de herramientas

Comparación entre **NotebookLM** (Google) y **Proyecto con archivos** (Claude Projects o
ChatGPT Projects, agrupados porque funcionan de forma muy similar) para la vía
empaquetada de la actividad "Nada sin fuente".

## Los 6 criterios

| Criterio | NotebookLM | Proyecto con archivos (Claude/ChatGPT) | Gana |
|---|---|---|---|
| **1. Contexto cerrado** (¿limita la respuesta a los documentos subidos?) | Diseñado alrededor de esto: panel de "Sources" explícito, el sistema intenta anclar cada respuesta a las fuentes cargadas. **No es perfecto** — lo comprobamos nosotros mismos: al preguntarle a NotebookLM sobre estenosis lumbar con nuestro corpus de 6 PDF, mencionó valores de kappa (0.702, 0.544, 0.557, 0.323) que no estaban en ninguno de esos 6 documentos, sino en un artículo externo (Miskin et al. 2021). | El modelo conserva todo su conocimiento general de fondo y lo mezcla con los archivos del proyecto salvo que se le indique lo contrario explícitamente en las instrucciones del proyecto — en la práctica, riesgo similar o mayor de mezclar conocimiento externo con el corpus. | NotebookLM (por poco) |
| **2. Cita con localización** (¿señala documento + página/fragmento exacto?) | Fuerte: cada afirmación lleva un número de cita clicable que abre el fragmento resaltado dentro del PDF original. Lo confirmamos varias veces — los porcentajes de Vision Transformers, las tablas de kappa de Al-Tameemi, todo apuntaba al lugar exacto del documento. | Débil: normalmente cita el nombre del archivo como máximo, sin abrir el fragmento exacto ni resaltar la página dentro de la interfaz de chat estándar. | **NotebookLM (clara)** |
| **3. Privacidad** (¿qué pasa con los documentos subidos?) | Google se compromete a no usar el contenido de NotebookLM para entrenar sus modelos por defecto. Ligado a una cuenta de Google. | Anthropic y OpenAI tienen políticas similares de no entrenamiento por defecto en cuentas de consumo, aunque conviene revisar la configuración de privacidad de cada cuenta antes de subir documentos. | Empate |
| **4. Costo** | Gratuito con cuenta de Google normal — hasta 50 notebooks, 50 fuentes cada uno. Suficiente para este proyecto. | Los "Proyectos" con archivos generalmente requieren plan de pago (Claude Pro o ChatGPT Plus) para tener capacidad razonable de archivos y contexto. | **NotebookLM (clara)** |
| **5. Exportación a APA 7** | No tiene botón dedicado de formato bibliográfico; hay que pedirle en el chat que dé el formato APA, y se debe verificar manualmente. | Misma limitación — ninguna de las dos tiene exportación automática de bibliografía en un formato específico. | Empate (punto débil de ambas) |
| **6. Reproducibilidad** (¿se puede fijar y repetir el mismo protocolo de preguntas?) | Las fuentes quedan fijas en el notebook, pero no hay un lugar formal para "fijar" el prompt/protocolo — cada pregunta se escribe libremente en el chat. | Los "Proyectos" permiten guardar instrucciones persistentes que aplican a toda conversación dentro del proyecto — más parecido a un protocolo versionable. | Proyecto con archivos (por poco) |

## Resultado

**NotebookLM gana en 3 de 6 criterios de forma clara o moderada** (contexto cerrado,
cita con localización, costo), **empata en 2** (privacidad, exportación APA), y **pierde
en 1** (reproducibilidad del protocolo, donde un Proyecto con instrucciones persistentes
tiene una ligera ventaja estructural).

## Decisión del equipo

Se elige **NotebookLM** como la herramienta de la vía empaquetada, principalmente por
el criterio 2 (cita con localización): es el único de los dos que permite verificar,
con un clic, si una afirmación está realmente respaldada por el documento que dice
citar — que es el objetivo central de esta actividad. La desventaja en reproducibilidad
(criterio 6) se compensa documentando el protocolo de prompts por escrito en un archivo
aparte del repositorio (`protocolo_prompts.md`, pendiente de crear), en vez de depender
de que la herramienta lo guarde internamente.

## Evidencia que respalda esta tabla

Esta comparación no es teórica: los criterios 1 y 2 están respaldados por el
Tratamiento C del experimento del equipo (ver `EXPERIMENTOS` y `clasificacion_referencias.csv`),
donde se probó NotebookLM en vivo con el corpus real del proyecto, incluyendo el caso
de fallo documentado en el inventario de fallos (Miskin et al. citado sin estar en el
corpus subido).
