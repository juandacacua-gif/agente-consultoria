import os
import time
import pandas as pd
import re
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
    Tu salida debe incluir código reproducible en R (tidyverse), incluyendo también líneas de código con la instalación y carga de tidyverse y los demás paquetes requeridos. 
    PERSONALIDAD: Tienes un tono cálido, muy amable, empático y accesible. Hablas como un colega cercano o un mentor que quiere ver triunfar al usuario. Usa un lenguaje natural y conversacional, celebrando los avances, sin dejar de ser riguroso en la estadística.
    Regla estricta: No des diagnósticos médicos, asume que todo es análisis de datos.
    NUEVA REGLA PARA INFORMES: Si el usuario te pide un informe, debes generar el documento completo en formato HTML limpio y profesional (con etiquetas <h1>, <h2>, <p>, <table>, y estilos CSS integrados) encerrado estrictamente en un bloque de código que inicie con ```html y termine con ```.
    """
    
    # Usamos el modelo más reciente
    model = genai.GenerativeModel(
        'gemini-3.6-flash',
        system_instruction=system_instruction
    )
    
    # .start_chat() permite que el modelo recuerde el historial de la conversación
    chat = model.start_chat(history=[])
    
    print("🤖 Bioestadístico Clínico Iniciado. (Escribe 'salir' para terminar)")
    
    # 3. Opción para subir datos (Soporte CSV y Excel)
    archivo = input("\n📁 Arrastra tu archivo a Colab y escribe su nombre aquí (ej. datos.csv o datos.xlsx), o presiona Enter para omitir: ")
    contexto_datos = ""
    
    if archivo.strip():
        try:
            if archivo.strip().endswith('.csv'):
                df = pd.read_csv(archivo.strip())
            elif archivo.strip().endswith(('.xlsx', '.xls')):
                df = pd.read_excel(archivo.strip())
            
            columnas = list(df.columns)
            contexto_datos = f"\n[Nota oculta para la IA: El usuario subió un dataset llamado '{archivo}' con {len(df)} filas. Las columnas son: {columnas}. Usa estos nombres de columnas exactos al generar el código R.]"
            print("✅ Archivo analizado correctamente. El agente ya conoce tus variables.")
        except Exception as e:
            print(f"⚠️ No se pudo leer el archivo. Asegúrate de haberlo subido. Error: {e}")

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
            print("\n🤖 Bioestadístico:")
            print(response.text)

            # --- Extraer y guardar R ---
            r_match = re.search(r'```[rR]\n(.*?)\n```', response.text, re.DOTALL)
            if r_match:
                codigo_r = r_match.group(1)
                with open("script_analisis.R", "w", encoding="utf-8") as f:
                    f.write(codigo_r)
                print("\n✅ ¡Código R detectado! Se ha guardado automáticamente como 'script_analisis.R'")
            
            # --- Extraer y guardar HTML (Reemplazo de LaTeX) ---
            html_match = re.search(r'```html\n(.*?)\n```', response.text, re.DOTALL)
            if html_match:
                codigo_html = html_match.group(1)
                with open("informe_clinico.html", "w", encoding="utf-8") as f:
                    f.write(codigo_html)
                print("\n✅ ¡Informe HTML detectado! Se ha guardado como 'informe_clinico.html'")
                print("💡 Tip: Abre ese archivo en tu navegador web y presiona Ctrl + P (o Cmd + P) -> 'Guardar como PDF' para obtener tu documento impreso perfecto.")
            
        except exceptions.ResourceExhausted:
            print("Límite de tasa. Esperando 10 segundos...")
            time.sleep(10)
            except Exception as e:
            print(f"Error crítico: {e}")

if __name__ == "__main__":
    iniciar_agente()
