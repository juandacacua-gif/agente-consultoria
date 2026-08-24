import os
import time
import pandas as pd
from dotenv import load_dotenv
import google.generativeai as genai
from google.api_core import exceptions

# 1. Configurar credenciales ocultas
def configure_api():
    load_dotenv()
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("Error: Falta GEMINI_API_KEY en el archivo .env")
    genai.configure(api_key=api_key)

# 2. Iniciar el chat interactivo
def iniciar_agente():
    configure_api()
    
    system_instruction = """
    DIRECTIVA PRINCIPAL: Eres un Consultor Bioestadístico Senior. 
    Tu salida debe incluir código reproducible en R (tidyverse). 
    Regla estricta: No des diagnósticos médicos, asume que todo es análisis de datos.
    """
    
    # Usamos el modelo más reciente
    model = genai.GenerativeModel(
        'gemini-3.6-flash',
        system_instruction=system_instruction
    )
    
    # .start_chat() permite que el modelo recuerde el historial de la conversación
    chat = model.start_chat(history=[])
    
    print("🤖 Bioestadístico Clínico Iniciado. (Escribe 'salir' para terminar)")
    
    # 3. Opción para subir datos
    archivo = input("\n📁 Arrastra tu CSV a Colab y escribe su nombre aquí (ej. datos.csv), o presiona Enter para omitir: ")
    contexto_datos = ""
    
    if archivo.strip():
        try:
            df = pd.read_csv(archivo.strip())
            columnas = list(df.columns)
            # Le pasamos esta nota secreta al agente
            contexto_datos = f"\n[Nota oculta para el IA: El usuario subió un dataset llamado '{archivo}' con {len(df)} filas. Las columnas son: {columnas}. Usa estos nombres de columnas exactos al generar el código R.]"
            print("✅ Archivo analizado correctamente. El agente ya conoce tus variables.")
        except Exception as e:
            print(f"⚠️ No se pudo leer el archivo. Asegúrate de haberlo subido a Colab. Error: {e}")

    # 4. Bucle interactivo (El Chat)
    while True:
        user_input = input("\nTú: ")
        
        # Criterio para apagar el agente
        if user_input.lower() in ['salir', 'exit', 'quit']:
            print("👋 Cerrando el consultorio. ¡Éxito con tu análisis!")
            break
            
        # Inyectamos el contexto de los datos solo en el primer mensaje
        if contexto_datos:
            user_input += contexto_datos
            contexto_datos = "" 
            
        try:
            print("Consultando a la IA...")
            response = chat.send_message(user_input)
            print("\n🤖 Agente Bioestadístico Iniciado:")
            print(response.text)
            
        except exceptions.ResourceExhausted:
            print("Límite de tasa. Esperando 10 segundos...")
            time.sleep(10)
        except Exception as e:
            print(f"Error crítico: {e}")

if __name__ == "__main__":
    iniciar_agente()
