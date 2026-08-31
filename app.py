import streamlit as st
import pandas as pd
import google.generativeai as genai
import re

# 1. Configuración de la página
st.set_page_config(page_title="Agente Bioestadístico", page_icon="🩺", layout="wide")
st.title("🩺 Consultor Bioestadístico Clínico AI")
st.markdown("Sube tu dataset, haz preguntas estadísticas y obtén código R e informes LaTeX listos para descargar.")

# 2. Barra lateral (Sidebar) para configuraciones y datos
with st.sidebar:
    st.header("⚙️ Configuración")
    # Pedimos la clave de forma segura en la interfaz
    api_key = st.text_input("Ingresa tu GEMINI_API_KEY", type="password")
    st.markdown("---")
    st.header("📁 Datos")
    uploaded_file = st.file_uploader("Sube tu dataset (CSV)", type="csv")

# Detenemos la app si no hay clave
if not api_key:
    st.warning("👈 Por favor, ingresa tu clave de API en el menú lateral para comenzar.")
    st.stop()

# Configuramos Gemini
genai.configure(api_key=api_key)

# 3. Inicializar el Agente y la Memoria (Session State)
if "chat" not in st.session_state:
    system_instruction = """
    DIRECTIVA PRINCIPAL: Eres un Consultor Bioestadístico Senior. 
    PERSONALIDAD: Tienes un tono cálido, muy amable, empático y accesible. Hablas como un colega cercano o un mentor. Usa un lenguaje natural y conversacional.
    Tu salida debe incluir código reproducible en R (tidyverse). 
    Regla estricta: No des diagnósticos médicos, asume que todo es análisis de datos.
    NUEVA REGLA: Si el usuario te pide un informe en LaTeX, debes generar el documento completo encerrado estrictamente en un bloque de código que inicie con ```latex y termine con ```.
    REGLA DE SINTAXIS LATEX: DEBES usar siempre exactamente este preámbulo:
    \\documentclass{article}
    \\usepackage[utf8]{inputenc}
    \\usepackage[spanish]{babel}
    \\begin{document}
    (aquí va tu contenido)
    \\end{document}
    """
    model = genai.GenerativeModel('gemini-3.6-pro', system_instruction=system_instruction)
    st.session_state.chat = model.start_chat(history=[])
    st.session_state.mensajes = [] # Para dibujar el chat en pantalla
    st.session_state.contexto_enviado = False

# 4. Dibujar el historial del chat
for msg in st.session_state.mensajes:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# 5. Entrada del usuario (Caja de chat)
if prompt := st.chat_input("Ej: ¿Qué prueba estadística me recomiendas para estos datos?"):
    
    # Mostramos el mensaje del usuario
    st.session_state.mensajes.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Lógica oculta para leer el CSV y enviárselo a la IA
    mensaje_llm = prompt
    if uploaded_file is not None and not st.session_state.contexto_enviado:
        df = pd.read_csv(uploaded_file)
        columnas = list(df.columns)
        mensaje_llm += f"\n\n[Nota oculta para la IA: El usuario subió un dataset llamado '{uploaded_file.name}'. Las columnas son: {columnas}. Úsalas en tu código R.]"
        st.session_state.contexto_enviado = True # Para no enviarlo en cada mensaje

    # Consultar a la IA
    with st.chat_message("assistant"):
        with st.spinner("Pensando y analizando datos..."):
            try:
                response = st.session_state.chat.send_message(mensaje_llm)
                respuesta_ia = response.text
                st.markdown(respuesta_ia)
                st.session_state.mensajes.append({"role": "assistant", "content": respuesta_ia})
                
                # --- MAGIA: Detectar código y crear botones de descarga ---
                r_match = re.search(r'```[rR]\n(.*?)\n```', respuesta_ia, re.DOTALL)
                latex_match = re.search(r'```latex\n(.*?)\n```', respuesta_ia, re.DOTALL)
                
                col1, col2 = st.columns(2)
                if r_match:
                    with col1:
                        st.download_button(label="⬇️ Descargar script_analisis.R", data=r_match.group(1), file_name="script_analisis.R", mime="text/plain")
                if latex_match:
                    with col2:
                        st.download_button(label="⬇️ Descargar informe_clinico.tex", data=latex_match.group(1), file_name="informe_clinico.tex", mime="text/plain")
                        
            except Exception as e:
                st.error(f"Error en la comunicación con la API: {e}")
