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

# =====================================================================
# CAPA DE DATOS E INDEXACIÓN (RAG Tabular para la terminal)
# =====================================================================
def indexar_y_buscar_datos(user_query, df):
    """
    Busca e indexa dinámicamente resúmenes o metadatos del dataset 
    según la consulta del usuario, asegurando trazabilidad y veracidad.
    """
    contexto_extraido = ""
    query_lower = user_query.lower()
    
    # 1. Indexación de estadísticas descriptivas si se solicitan métricas
    if any(palabra in query_lower for palabra in ['resumen', 'estadística', 'media', 'promedio', 'distribución', 'descriptiva']):
        resumen_numerico = df.describe().to_string()
        contexto_extraido += f"\n\n[RAG Tabular - Resumen Estadístico Oficial Indexado]:\n{resumen_numerico}\n"
        
    # 2. Indexación de la estructura de columnas y variables
    if any(palabra in query_lower for palabra in ['columnas', 'variables', 'estructura', 'datos', 'niveles']):
        columnas_info = ", ".join(df.columns)
        contexto_extraido += f"\n\n[RAG Tabular - Estructura de Columnas Indexada]: El dataset contiene las siguientes variables: [{columnas_info}]\n"
        
    return contexto_extraido
# =====================================================================

# 2. Iniciar el chat interactivo
def iniciar_agente():
    configure_api()
    
    system_instruction = """
    DIRECTIVA PRINCIPAL: Eres un Consultor Bioestadístico Senior especializado en análisis de radiología y patologías espinales. 
    PERSONALIDAD: Tienes un tono cálido, muy amable, empático y accesible. Hablas como un colega cercano o un mentor que quiere ver triunfar al usuario. Usa un lenguaje natural y conversacional, celebrando los avances, sin dejar de ser riguroso en la estadística.
    Tu salida debe incluir código reproducible en R (tidyverse), incluyendo también líneas de código con la instalación y carga de tidyverse y los demás paquetes requeridos. 
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
    
    print("🤖 Bioestadístico Clínico con RAG Tabular Iniciado. (Escribe 'salir' para terminar)")
    
    # 3. Opción para subir datos (Soporte CSV y Excel)
    archivo = input("\n📁 Arrastra tu archivo y escribe su nombre aquí (ej. datos.csv o datos.xlsx), o presiona Enter para omitir: ")
    df = None
    contexto_datos = ""
    
    if archivo.strip():
        try:
            ruta = archivo.strip()
            if ruta.endswith('.csv'):
                df = pd.read_csv(ruta)
            elif ruta.endswith(('.xlsx', '.xls')):
                df = pd.read_excel(ruta)
            
            columnas = list(df.columns)
            contexto_datos = f"\n[Nota de Contexto Inicial para la IA: El usuario subió un dataset llamado '{archivo}' con {len(df)} filas. Las columnas son: {columnas}.]"
            print("✅ Archivo analizado e indexado correctamente. El agente ya conoce tus variables.")
        except Exception as e:
            print(f"⚠️ No se pudo leer el archivo. Asegúrate de haberlo subido. Error: {e}")

    # 4. Bucle interactivo (El Chat)
    primer_mensaje = True
    while True:
        user_input = input("\nTú: ")
        
        # Criterio para apagar el agente
        if user_input.lower() in ['salir', 'exit', 'quit']:
            print("👋 Cerrando el consultorio. ¡Éxito con tu análisis!")
            break
            
        # Construimos el mensaje añadiendo el contexto inicial y la capa RAG de indexación
        mensaje_envio = user_input
        
        if df is not None:
            if primer_mensaje and contexto_datos:
                mensaje_envio += f"\n{contexto_datos}"
                primer_mensaje = False
                
            # Inyectamos dinámicamente la evidencia indexada según lo que pida el usuario
            contexto_rag = indexar_y_buscar_datos(user_input, df)
            if contexto_rag:
                mensaje_envio += contexto_rag
            
        try:
            print("Consultando al sistema RAG y analizando datos...")
            response = chat.send_message(mensaje_envio)
            print("\n🤖 Bioestadístico:")
            print(response.text)

            # --- Extraer y guardar R ---
            r_match = re.search(r'```[rR]\n(.*?)\n```', response.text, re.DOTALL)
            if r_match:
                codigo_r = r_match.group(1)
                with open("script_analisis.R", "w", encoding="utf-8") as f:
                    f.write(codigo_r)
                print("\n✅ ¡Código R detectado! Se ha guardado automáticamente como 'script_analisis.R'")
            
            # --- Extraer y guardar HTML ---
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
