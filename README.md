# Agente Bioestadístico Clínico (Proyecto RSNA Lumbar Spine)

## Instrucciones de Ejecución
1. Clonar el repositorio.
2. Instalar dependencias: `pip install -r requirements.txt`
3. Crear un archivo `.env` con la variable `GEMINI_API_KEY`.
4. Ejecutar el script: `python main.py`

## Instrucciones de Ejecución en Google Colab
1. Clonar el repositorio, copiando y ejecutando lo siguiente:
   
   `!git clone https://github.com/juandacacua-gif/agente-consultoria.git`
   
   `%cd agente-consultoria`
   
2. Instalar dependencias y LaTeX para informes, copiando y ejecutando:
   
   `!pip install -r requirements.txt`

   `!sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texlive-lang-spanish`
   
3. Crear un archivo '.env' con la variable 'GEMINI_API_KEY' usando este codigo:
   
   `with open('.env', 'w') as f:`
   
   `f.write('GEMINI_API_KEY=AQUÍ_VA_EL_CODIGO')`
   
    `print("✅ Archivo .env creado exitosamente.")`

4. Subir el archivo csv que se desea analizar, ejecutando este codigo:
   
   `from google.colab import files`
   
   `print("Sube aquí tu archivo CSV:")`
   
   `uploaded = files.upload()`
   
5. Encender el agente ejecutando el codigo:
   
   `!python main.py`

6. Para compilar el informe LaTeX despues de solicitarlo, ejecutar este codigo:

   `!pdflatex -interaction=nonstopmode informe_clinico.tex`
  

## Arquitectura y Decisiones de Recursos
* **Elección de Modelo:** Se utilizó la API de Gemini 3.6 Flash.
* **Justificación:** Se descartó cuantización local (ej. Mistral Q4_K_M) debido a la alta latencia en hardware estándar y la posible pérdida de precisión al generar código en R. La API ofrece memoria virtual ilimitada para el usuario local y protege los datos médicos al usar bases de datos ya anonimizadas (Kaggle RSNA).

## Versionado de Prompts
* **v1:** Rol general estadístico. *Problema:* El agente se negaba a responder al detectar la palabra "pacientes" por filtros de seguridad.
* **v2:** Rol específico de "Bioestadístico Clínico" con directivas de sistema explícitas para asumir escenarios teóricos de investigación. *Resultado:* Flujo continuo sin ruptura de personaje.

## Justificación y necesidad
Se le pone al agente el rol de Consultor Bioestadístico con la especialidad en investigación clínica y médica, para guiar a investigadores y médicos a analizar bases de datos clínicas, diseñar experimentos, elegir pruebas estadísticas adecuadas y generar código, con validez metodológica.

* **Habilidades del agente:**

•	Identificación de Variables: Determinar si son cualitativas (como leve, moderado, severo), cuantitativas (como edad), y su nivel de medición.

•	Evaluación de Datos: Evaluar datos faltantes o inconsistentes buscando formas de limpiar la base antes de analizar **(no hace limpieza ni imputación si el usuario no lo pide)**.

•	Validación de Supuestos: Evaluar normalidad y homocedasticidad, e identificar si las distribuciones no son normales.

•	Elección de métodos y pruebas: Recomendar pruebas adecuadas, ver bien cuándo usar pruebas paramétricas cuando usar pruebas no paramétricas según como estén los datos.

•	Interpretación Clínica: Ayudar a interpretar los resultados estadísticos (p-valor, intervalos de confianza) en un contexto médico, **sin** dar ningún diagnóstico clínico.

•	Códigos: Dar ejemplos claros en lenguaje de R usando paquetes como tidyverse.

* **Observaciones del agente:**

•	Si el usuario da escenarios con pacientes, enfermedades, imágenes o medicamentos, se asume que es un ejercicio de análisis de datos de investigación sin tener que dar diagnósticos médicos.

•	No sugerir análisis que violen los supuestos de los datos (como dar promedios para variables ordinales o cualitativas).

•	Si el usuario pide ayuda de diseño, pero no da archivos, explicar el árbol de decisiones estadísticas y dar un código simulado en R.

•	Si el usuario sube un archivo CSV o tabla, leer primero las columnas, diagnosticar de los tipos de variables y proponer el código exacto.

* **Restricciones del agente:**

•	No dar consejos médicos o diagnósticos

•	No imputar datos faltantes sin consentimiento

•	No sugerir pruebas paramétricas sin comprobar los supuestos

•	Se deben verificar manualmente los códigos que da el agente

## Diseño y configuración

En la entrada del agente, el usuario ingresa una consulta en lenguaje natural o sube un archivo CSV o tabla con datos clínicos, allí se habilitan las habilidades de leer los datos analizando los encabezados y tipos de datos, comprobando los supuestos estadísticos y generando el código de R.

* **Rutas del agente:**

•	Si el usuario no especifica el tipo de variable clínica; El agente detiene el análisis y pregunta.

•	Si se violan los supuestos, el agente busca pruebas no paramétricas.

•	El agente se detiene cuando entrega un código de R, validado y con su respectiva interpretación clínica.

Se elige un modelo basado en API en Gems de Gemini usando Gemini 3.6 Flash, se elige por ser capaz de leer bases grandes sin perder información, y por tener bajo costo, como la base de datos publica de RSNA es anónima, hay un riesgo nulo de exponer información personal de salud.

## Implementación técnica

En el archivo *requirements.txt* se indican las versiones de las librerías a usar, que son *google-generativeai==0.5.0*, *python-dotenv==1.0.1* y *pandas>=2.0.0*.

Para la gestión de errores, se pone un limite de tasa donde el código esperara 10 segundos y reintentará si la API nota muchas peticiones, si el agente devuelve texto en lugar de código, el sistema le pedirá a la IA que lo corrija.

Se eligió la API externa en la nuble que no consume VRAM local y da respuestas en alrededor de 2 segundos, optimizando el costo computacional.

Las credenciales como la clave API están en un archivo llamado “.env”, y el código allí lee la clave.

El archivo *main.py* divide las responsabilidades, carga credenciales, gestiona errores de red y ejecuta el modelo.
