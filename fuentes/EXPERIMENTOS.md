# Tabla de experimentos

Se busca mirar como la IA responde a lo que le pedimos, en que casos es cuando más empieza a "alucinar" y en que otros
es que responde de forma más coherente.
Para esto se hacen estas **15 preguntas** a la IA:

1. **Pregunta:** ¿Cuáles son las regiones anatómicas principales evaluadas para la degeneración en el dataset de la competencia RSNA 2024?
    
    - **Respuesta conocida:** Estenosis espinal lumbar, estenosis foraminal neural (izquierda/derecha) y espondilolistesis en los niveles L1-L2 a L5-S1.
        
    - **Fuente:** [[Variables_y_Severidad]] / Documentación oficial de Kaggle.
        
2. **Pregunta:** ¿Qué niveles vertebrales específicos abarca principalmente el análisis de degeneración lumbar en nuestro estudio clínico?
    
    - **Respuesta conocida:** Se evalúa desde L1 hasta S1, con especial énfasis clínico en los niveles L4-L5 y L5-S1 por su alta incidencia de patología.
        
    - **Fuente:** [[Problema_y_Contexto]] y dataset CSV.
        
3. **Pregunta:** ¿Cómo se clasifican categóricamente los niveles de severidad de la estenosis en los datos procesados?
    
    - **Respuesta conocida:** Normal/Leve, Moderado y Severo.
        
    - **Fuente:** [[Variables_y_Severidad]].
        
4. **Pregunta:** ¿Cuál es el formato principal en el que se cargan los datos crudos del proyecto para ser procesados mediante R?
    
    - **Respuesta conocida:** Archivos en formato `.csv` (datos tabulares estructurados).
        
    - **Fuente:** [[Notas_Codigo_R_Y_Streamlit]].
        
5. **Pregunta:** ¿Qué tratamiento inicial se le da a los valores nulos o faltantes dentro del script de preprocesamiento en R?
    
    - **Respuesta conocida:** Se identifican mediante inspección con `mice` y se filtran o imputan según el criterio estadístico definido en el protocolo.
        
    - **Fuente:** [[Analisis_y_Clusterizazion]] / Scripts de R.
        

#### Bloque 2: Metodología Estadística y Código en R (Problema de Herramientas)

6. **Pregunta:** ¿Qué colección de paquetes en R se estipuló como estándar obligatorio para la manipulación y flujos de datos bioestadísticos?
    
    - **Respuesta conocida:** El ecosistema `tidyverse` (incluyendo `dplyr`, `tidyr`, etc.).
        
    - **Fuente:** Directiva del sistema del agente y [[Notas_Codigo_R_Y_Streamlit]].
        
7. **Pregunta:** ¿Qué función o comando inicial es estrictamente obligatorio incluir al inicio de cada script de análisis en R para evitar fallas de funciones no encontradas?
    
    - **Respuesta conocida:** La llamada explícita a las librerías mediante `library(tidyverse)` (y los demás paquetes requeridos).
        
    - **Fuente:** [[Notas_Codigo_R_Y_Streamlit]].
        
8. **Pregunta:** ¿Qué tipo de análisis bioestadístico se planificó para la Fase 1 y 2 del cronograma del proyecto?
    
    - **Respuesta conocida:** Análisis exploratorio de datos (EDA), estadísticas descriptivas y pruebas de hipótesis comparativas entre grupos (tratamiento vs. control/referencia).
        
    - **Fuente:** [[Cronograma_8_Semanas]].
        
9. **Pregunta:** ¿Cómo se estructuró la integración entre la interfaz gráfica y el motor analítico del consultor?
    
    - **Respuesta conocida:** Una aplicación interactiva desarrollada en Python con `Streamlit` que se comunica con la API de Gemini y ejecuta flujos tabulares.
        
    - **Fuente:** [[Estrategia_RAG]] y `app.py`.
        
10. **Pregunta:** Ante el error histórico de que el modelo intente usar funciones obsoletas o inventadas (como `tidy` mal aplicada), ¿cómo responde el sistema de validación?
    
    - **Respuesta conocida:** El agente debe generar exclusivamente código reproducible basado en funciones estándar documentadas del `tidyverse` y ejecutarse de forma controlada.
        
    - **Fuente:** [[Estrategia_RAG]].
        

#### Bloque 3: Estado del Arte y Referencias Teóricas (Problema de Búsqueda)

11. **Pregunta:** ¿Cuál es el objetivo principal planteado en el anteproyecto para el consultor bioestadístico basado en IA?
    
    - **Respuesta conocida:** Actuar como un asistente especializado que apoye en la redacción de informes clínicos y análisis rigurosos sin emitir alucinaciones en cifras o referencias.
        
    - **Fuente:** [[Objetivos_y_alcance]].
        
12. **Pregunta:** ¿Qué tipo de arquitectura de recuperación de contexto se seleccionó para conectar los documentos del usuario con el modelo?
    
    - **Respuesta conocida:** RAG Gestionado a través de la API de Gemini con contexto cerrado sobre los archivos y datasets propios.
        
    - **Fuente:** [[Estrategia_RAG]].
        
13. **Pregunta:** ¿Cuántas semanas abarca el cronograma total del proyecto de ingeniería antes de la entrega final de diciembre?
    
    - **Respuesta conocida:** Un total de 8 semanas estructuradas en fases de limpieza, modelado, integración de agentes y reporte final.
        
    - **Fuente:** [[Cronograma_8_Semanas]].
        
14. **Pregunta:** ¿Qué norma o formato de citación bibliográfica debe garantizar el sistema al exportar referencias o notas teóricas?
    
    - **Respuesta conocida:** Formato APA 7ª edición.
        
    - **Fuente:** [[Inicio_Proyecto]] y directrices del anteproyecto.
        
15. **Pregunta:** ¿Cómo se garantiza la reproducibilidad completa del sistema ante una auditoría externa?
    
    - **Respuesta conocida:** Mediante el versionamiento de scripts en Python/R, el uso de un repositorio estructurado en Markdown (Obsidian) y la fijación de las fuentes documentales del corpus.
        
    - **Fuente:** [[Inicio_Proyecto]] y [[Estrategia_RAG]]

# Los experimentos:
- **Experimento A** — Se preguntan a Gemini convencional.
- **Experimento B** — Se preguntan a Gemini con acceso a las fuentes elegidas para el proyecto.
- **Experimento C** — Se preguntan al agente de IA creado para el proyecto.

En la tabla de resultados de los experimentos se pondrá "correcto" o "incorrecto" dependiendo de la respuesta que de la IA.

# Los resultados:




