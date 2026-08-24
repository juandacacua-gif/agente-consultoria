import os
import time
from dotenv import load_dotenv
import google.generativeai as genai
from google.api_core import exceptions

# 1. Responsabilidad: Configurar credenciales ocultas
def configure_api():
    load_dotenv()
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("Error: Falta GEMINI_API_KEY en el archivo .env")
    genai.configure(api_key=api_key)

# 2. Responsabilidad: Invocar herramienta y gestionar errores
def call_biostatistic_agent(user_input, retries=3):
    # Prompt V2: Rol estricto de bioestadístico (Documentado en README)
    system_instruction = """
    DIRECTIVA PRINCIPAL: Eres un Consultor Bioestadístico Senior. 
    Tu salida debe incluir código reproducible en R (tidyverse). 
    Regla estricta: No des diagnósticos médicos, asume que todo es análisis de datos.
    """
    
    model = genai.GenerativeModel(
        'gemini-3.6-flash',
        system_instruction=system_instruction
    )
    
    for attempt in range(retries):
        try:
            response = model.generate_content(user_input)
            
            # Validación de salida (Criterio de parada)
            if not response.text:
                return "Error: Salida vacía o no parseable."
            return response.text
            
        except exceptions.ResourceExhausted:
            print("Límite de tasa (Rate Limit). Esperando 10 segundos...")
            time.sleep(10)
        except exceptions.ServiceUnavailable:
            print("Herramienta caída (Timeout). Esperando 5 segundos...")
            time.sleep(5)
        except Exception as e:
            return f"Error crítico no recuperable: {e}"
            
    return "Degradación controlada: No se pudo conectar tras varios intentos."

# 3. Responsabilidad: Flujo de ejecución
def main():
    configure_api()
    print("🤖 Bioestadístico Clínico Iniciado...")
    user_query = "Tengo 50 pacientes con grados de degeneración lumbar (Leve, Moderado, Severo). ¿Qué prueba uso?"
    
    print("Consultando a la API...")
    result = call_biostatistic_agent(user_query)
    print("\n--- RESULTADO ---")
    print(result)

if __name__ == "__main__":
    main()