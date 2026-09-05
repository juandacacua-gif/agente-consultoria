import streamlit as st
import pandas as pd
import google.generativeai as genai
import re
import os
import subprocess

# 1. Configuración de la página
st.set_page_config(page_title="Agente Bioestadístico", page_icon="🩺", layout="wide")
st.title("🩺 Consultor Bioestadístico Clínico AI")
st.markdown("Sube tu dataset, haz preguntas estadísticas y obtén código R e informes LaTeX listos para descargar.")

# 2. Barra lateral (Sidebar) para configuraciones y datos
with st.sidebar:
    st.header("⚙️ Configuración")
    api_key = st.text_input("Ingresa tu GEMINI_API_KEY", type="password")
    st.markdown("---")
    st.header("📁 Datos")
    uploaded_file = st.file_uploader("Sube tu dataset (CSV, Excel)", type=["csv", "xlsx", "xls"])

    df = None 
    if uploaded_file is not None:
        nombre_archivo = uploaded_file.name
        if nombre_archivo.endswith('.csv'):
            df = pd.read_csv(uploaded_file)
        elif nombre_archivo.endswith(('.xlsx', '.xls')):
            df = pd.read_excel(uploaded_file)

if not api_key:
    st.warning("👈 Por favor, ingresa tu clave de API en el menú lateral para comenzar.")
    st.stop()

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
    model = genai.GenerativeModel('gemini-3.6-flash', system_instruction=system_instruction)
    st.session_state.chat = model.start_chat(history=[])
    st.session_state.mensajes = [] 
    st.session_state.contexto_enviado = False

# =====================================================================
# Opción para Exportar el Chat (Barra Lateral)
# =====================================================================
if st.session_state.mensajes:
    with st.sidebar:
        st.markdown("---")
        st.header("💾 Exportar Sesión")
        historial_md = "# 🩺 Reporte de Consultoría Bioestadística\n\n"
        historial_md += f"**Fecha:** {pd.Timestamp.now().strftime('%Y-%m-%d %H:%M')}\n\n"
        if uploaded_file is not None:
            historial_md += f"**Dataset Analizado:** `{uploaded_file.name}`\n\n"
        historial_md += "---\n\n"
        
        for msg in st.session_state.mensajes:
            rol = "👤 **Usuario**" if msg["role"] == "user" else "🩺 **Consultor Bioestadístico AI**"
            historial_md += f"### {rol}\n\n{msg['content']}\n\n---\n\n"
        
        st.sidebar.download_button(
            label="📥 Descargar Historial (.md)",
            data=historial_md,
            file_name="historial_consultoria_bioestadistica.md",
            mime="text/markdown"
        )

# =====================================================================
# NUEVA Pestaña de Exploración de Datos (EDA Visual y Tarjetas)
# =====================================================================
if df is not None:
    with st.expander("🔍 Exploración preliminar del dataset", expanded=False):
        tab1, tab2 = st.tabs(["📋 Tabla de Datos", "📊 Resumen Visual"])
        
        with tab1:
            st.markdown("**Vista previa de las primeras 10 filas:**")
            st.dataframe(df.head(10), use_container_width=True)
            
        with tab2:
            # 1. Tarjetas (Metrics) Globales
            st.markdown("### 📈 Métricas Generales")
            col_m1, col_m2, col_m3 = st.columns(3)
            col_m1.metric("Total de Pacientes / Filas", df.shape[0])
            col_m2.metric("Total de Variables / Columnas", df.shape[1])
            col_m3.metric("Datos Faltantes (Nulos)", df.isnull().sum().sum())
            
            st.markdown("---")
            
            # 2. Selector interactivo por variable
            st.markdown("### 🔍 Análisis de Distribución")
            var_seleccionada = st.selectbox("Selecciona una columna para visualizar:", df.columns)
            
            # Si la variable es numérica, mostramos tarjetas extra
            if pd.api.types.is_numeric_dtype(df[var_seleccionada]):
                col_a, col_b, col_c, col_d = st.columns(4)
                col_a.metric("Promedio", f"{df[var_seleccionada].mean():.2f}")
                col_b.metric("Mediana", f"{df[var_seleccionada].median():.2f}")
                col_c.metric("Mínimo", f"{df[var_seleccionada].min()}")
                col_d.metric("Máximo", f"{df[var_seleccionada].max()}")
            
            # Gráfico de barras interactivo nativo
            st.markdown(f"**Frecuencia de datos para: `{var_seleccionada}`**")
            st.bar_chart(df[var_seleccionada].value_counts().head(20))
# =====================================================================

# 4. Dibujar el historial del chat
for msg in st.session_state.mensajes:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# =====================================================================
# Botones de Preguntas Rápidas (Quick Prompts)
# =====================================================================
st.markdown("💡 **Sugerencias de análisis:**")
col_btn1, col_btn2, col_btn3 = st.columns(3)

prompt_rapido = None
if col_btn1.button("📊 Sugerir prueba estadística"):
    prompt_rapido = "Recomiéndame la prueba de hipótesis adecuada para evaluar la variable principal de estos datos."
if col_btn2.button("📉 Validar normalidad"):
    prompt_rapido = "Genera el código en R para verificar si las variables numéricas cumplen el supuesto de normalidad."
if col_btn3.button("📄 Generar informe LaTeX"):
    prompt_rapido = "Haz un análisis completo de mis datos, interpreta los resultados y redacta el informe formal en LaTeX."

# 5. Entrada del usuario (Caja de chat o Botones)
prompt_usuario = st.chat_input("Escribe tu propia consulta estadística...")
prompt_final = prompt_usuario or prompt_rapido

if prompt_final:
    st.session_state.mensajes.append({"role": "user", "content": prompt_final})
    with st.chat_message("user"):
        st.markdown(prompt_final)

    mensaje_llm = prompt_final
    if df is not None and not st.session_state.contexto_enviado:
        columnas = list(df.columns)
        mensaje_llm += f"\n\n[Nota oculta para la IA: El usuario subió un dataset llamado '{uploaded_file.name}'. Las columnas son: {columnas}. Úsalas en tu código R.]"
        st.session_state.contexto_enviado = True 

    with st.chat_message("assistant"):
        with st.spinner("Pensando y analizando datos..."):
            try:
                response = st.session_state.chat.send_message(mensaje_llm)
                respuesta_ia = response.text
                st.markdown(respuesta_ia)
                st.session_state.mensajes.append({"role": "assistant", "content": respuesta_ia})
                
                r_match = re.search(r'```[rR]\n(.*?)\n```', respuesta_ia, re.DOTALL)
                latex_match = re.search(r'```latex\n(.*?)\n```', respuesta_ia, re.DOTALL)
                
                col1, col2 = st.columns(2)
                if r_match:
                    with col1:
                        st.download_button(label="⬇️ Descargar script_analisis.R", data=r_match.group(1), file_name="script_analisis.R", mime="text/plain")
                
                if latex_match:
                    with col2:
                        codigo_latex = latex_match.group(1)
                        with open("informe_clinico.tex", "w", encoding="utf-8") as f:
                            f.write(codigo_latex)
                        subprocess.run(["pdflatex", "-interaction=nonstopmode", "informe_clinico.tex"], capture_output=True)
                        st.download_button(label="⬇️ Descargar informe.tex", data=codigo_latex, file_name="informe_clinico.tex", mime="text/plain")
                        if os.path.exists("informe_clinico.pdf"):
                            with open("informe_clinico.pdf", "rb") as pdf_file:
                                st.download_button(label="📄 Descargar PDF listo", data=pdf_file.read(), file_name="informe_clinico.pdf", mime="application/pdf")
                        
            except Exception as e:
                st.error(f"Error en la comunicación con la API: {e}")
