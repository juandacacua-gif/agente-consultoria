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
   
2. Instalar dependencias copiando y ejecutando:
   
   `!pip install -r requirements.txt`
   
3. Crear un archivo '.env' con la variable 'GEMINI_API_KEY' usando este codigo:
   
   `with open('.env', 'w') as f:`
   
   `f.write('GEMINI_API_KEY=AQUÍ_VA_EL_CODIGO')`
   
    `print("✅ Archivo .env creado exitosamente.")`

4. Subir el archivo csv que se desea analizar, ejecutando este codigo:
   
   `from google.colab import files`
   
   `print("Sube aquí tu archivo CSV (ej. el de Kaggle RSNA Lumbar Spine):")`
   
   `uploaded = files.upload()`
   
5. Ejecutar el script, ejecutando el codigo:
   `!python main.py`
  

## Arquitectura y Decisiones de Recursos
* **Elección de Modelo:** Se utilizó la API de Gemini 3.6 Flash.
* **Justificación:** Se descartó cuantización local (ej. Mistral Q4_K_M) debido a la alta latencia en hardware estándar y la posible pérdida de precisión al generar código en R. La API ofrece memoria virtual ilimitada para el usuario local y protege los datos médicos al usar bases de datos ya anonimizadas (Kaggle RSNA).

## Versionado de Prompts
* **v1:** Rol general estadístico. *Problema:* El agente se negaba a responder al detectar la palabra "pacientes" por filtros de seguridad.
* **v2:** Rol específico de "Bioestadístico Clínico" con directivas de sistema explícitas para asumir escenarios teóricos de investigación. *Resultado:* Flujo continuo sin ruptura de personaje.
