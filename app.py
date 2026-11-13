import streamlit as st
import pandas as pd
import google.generativeai as genai
import re
import os
from dotenv import load_dotenv

load_dotenv()

# 1. Configuración de la página
st.set_page_config(page_title="Agente Bioestadístico", page_icon="🩺", layout="wide")
st.title("🩺 Consultor Bioestadístico Clínico AI")
st.markdown("Sube tu dataset, haz preguntas estadísticas y obtén código R e informes HTML listos para descargar.")

# =====================================================================
# CAPA DE DATOS E INDEXACIÓN (RAG Tabular)
# =====================================================================
def indexar_y_buscar_datos(user_query, df):
    contexto_extraido = ""
    query_lower = user_query.lower()
    
    # 1. Indexación de resúmenes estadísticos (Soporte Categórico u Ordinal)
    if any(palabra in query_lower for palabra in ['resumen', 'estadística', 'distribución', 'descriptiva', 'frecuencia', 'tabla']):
        # Incluye estadísticas para cadenas y factores
        resumen_tab = df.describe(include='all').fillna('-').to_string()
        
        # Conteo rápido de frecuencias por clase para las primeras variables
        frecuencias = "\n".join([f"- {col}: {dict(df[col].value_counts())}" for col in df.columns[:5]])
        
        contexto_extraido += f"\n\n[RAG Tabular - Resumen Estadístico e Imputación]:\n{resumen_tab}\n"
        contexto_extraido += f"\n[RAG Tabular - Distribución de Frecuencias (Muestra)]: \n{frecuencias}\n"
        
    # 2. Indexación de la estructura de columnas y variables
    if any(palabra in query_lower for palabra in ['columnas', 'variables', 'estructura', 'datos', 'niveles', 'lumbares']):
        columnas_info = ", ".join(df.columns)
        contexto_extraido += f"\n\n[RAG Tabular - Estructura de Columnas]: El dataset contiene {len(df.columns)} variables: [{columnas_info}]\n"
        
    return contexto_extraido
# =====================================================================

# 2. Barra lateral (Sidebar) para configuraciones y datos
with st.sidebar:
    st.header("⚙️ Configuración")
    api_key = st.text_input(
        "Ingresa tu GEMINI_API_KEY",
        type="password",
        value=os.getenv("GEMINI_API_KEY", ""),
    )
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
    DIRECTIVA PRINCIPAL: Eres un Consultor Bioestadístico Senior especializado en análisis de radiología, imagenología y patologías espinales. 
    PERSONALIDAD: Tienes un tono cálido, muy amable, empático y accesible. Hablas como un colega cercano o un mentor. Usa un lenguaje natural y conversacional.
    Tu salida debe incluir código reproducible en R (tidyverse), con las líneas para instalar y cargar los paquetes requeridos. 
    PAUTAS DE RECOMENDACIÓN ESTADÍSTICA:
        1. Para variables categóricas ordinales (ej. Normal/Mild < Moderate < Severe), RECOMIENDA SIEMPRE métodos no paramétricos y ordinales:
           - Prueba Chi-Cuadrada (asociación entre estructuras)
           - Prueba de McNemar-Bowker (evaluación de simetría bilateral izquierda vs. derecha)
           - Análisis de Correspondencias Múltiples (MCA) y Clustering K-Medoides (PAM) para fenotipos
           - Regresión Logística Ordinal de Odds Proporcionales (polr de MASS o clm de ordinal)
        2. Explicita siempre la interpretación de los ODDS RATIOS (OR = e^beta) y la bondad de ajuste mediante Pseudo R2 (McFadden, Nagelkerke) y MAE (Error Absoluto Medio).
    Regla estricta: No des diagnósticos médicos, asume que todo es análisis de datos.

REGLAS DE SALIDA:
- Todo código en R debe ser completamente reproducible en R (usando tidyverse, MASS, ordinal, etc.), incluyendo la instalación y carga de paquetes.
- Si el usuario solicita un informe formal, genera un HTML limpio encerrado estrictamente en ```html ... ``` con tablas estilizadas y CSS integrado.
- No emitas diagnósticos médicos directos; enfócate en el modelado estadístico y la interpretación bioestadística.
  NUEVA REGLA PARA INFORMES: Si el usuario te pide un informe formal, debes generarlo en formato HTML limpio y profesional (con etiquetas <h1>, <h2>, <p>, <table>, y estilos CSS integrados) encerrado estrictamente en un bloque de código que inicie con ```html y termine con ```.

  REGLA DE VERACIDAD: No puedes ejecutar R ni calcular sobre el archivo completo. Solo recibes nombres de columnas, un resumen y frecuencias parciales. Nunca inventes resultados numéricos (p-valores, OR, IC, R2, MAE, estadísticos). En los informes escribe "[pendiente: ejecutar el script]" en lugar de cifras, o pide al usuario que pegue la salida de R. No generes datos sintéticos salvo que el usuario lo pida, y márcalos como simulados. Con polr, usa predictores como factor no ordenado. Un OR es de odds, no de probabilidad. En datos transversales no hables de progresión.
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
# Pestaña de Exploración de Datos (EDA Visual y Tarjetas)
# =====================================================================
if df is not None:
    with st.expander("🔍 Exploración preliminar del dataset", expanded=False):
        tab1, tab2 = st.tabs(["📋 Tabla de Datos", "📊 Resumen Visual"])
        
        with tab1:
            st.markdown("**Vista previa de las primeras 10 filas:**")
            st.dataframe(df.head(10), width="stretch")
            
        with tab2:
            st.markdown("### 📈 Métricas Generales")
            col_m1, col_m2, col_m3 = st.columns(3)
            col_m1.metric("Total de Pacientes / Filas", df.shape[0])
            col_m2.metric("Total de Variables / Columnas", df.shape[1])
            col_m3.metric("Datos Faltantes (Nulos)", df.isnull().sum().sum())
            
            st.markdown("---")
            
            st.markdown("### 🔍 Análisis de Distribución")
            var_seleccionada = st.selectbox("Selecciona una columna para visualizar:", df.columns)
            
            if pd.api.types.is_numeric_dtype(df[var_seleccionada]):
                col_a, col_b, col_c, col_d = st.columns(4)
                col_a.metric("Promedio", f"{df[var_seleccionada].mean():.2f}")
                col_b.metric("Mediana", f"{df[var_seleccionada].median():.2f}")
                col_c.metric("Mínimo", f"{df[var_seleccionada].min()}")
                col_d.metric("Máximo", f"{df[var_seleccionada].max()}")
            else:
                col_a, col_b, col_c = st.columns(3)
                modo = df[var_seleccionada].mode()[0] if not df[var_seleccionada].empty else "-"
                n_categorias = df[var_seleccionada].nunique()
                pct_moda = (df[var_seleccionada] == modo).mean() * 100
    
                col_a.metric("Categoría Frecuente (Moda)", str(modo))
                col_b.metric("Nº de Categorías", n_categorias)
                col_c.metric("% de la Moda", f"{pct_moda:.1f}%")
            
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
if col_btn3.button("📄 Generar informe HTML"):
    prompt_rapido = "Haz un análisis completo de mis datos, interpreta los resultados y redacta el informe formal en HTML."

# 5. Entrada del usuario (Caja de chat o Botones)
prompt_usuario = st.chat_input("Escribe tu propia consulta estadística...")
prompt_final = prompt_usuario or prompt_rapido

if prompt_final:
    st.session_state.mensajes.append({"role": "user", "content": prompt_final})
    with st.chat_message("user"):
        st.markdown(prompt_final)

    # Construcción del mensaje para el LLM con la capa de indexación y RAG
    mensaje_llm = prompt_final
    
    if df is not None:
        # Si es el primer mensaje, inyectamos la estructura completa de columnas
        if not st.session_state.contexto_enviado:
            columnas = list(df.columns)
            mensaje_llm += f"\n\n[Nota de Contexto Inicial: El usuario subió un dataset llamado '{uploaded_file.name}' con {len(df)} filas. Las columnas son: {columnas}.]"
            st.session_state.contexto_enviado = True 
            
        # Inyección dinámica mediante RAG Tabular basado en indexación local
        contexto_rag = indexar_y_buscar_datos(prompt_final, df)
        if contexto_rag:
            mensaje_llm += contexto_rag

    with st.chat_message("assistant"):
        with st.spinner("Consultando al sistema RAG y analizando datos..."):
            try:
                response = st.session_state.chat.send_message(mensaje_llm)
                respuesta_ia = response.text
                st.markdown(respuesta_ia)
                st.session_state.mensajes.append({"role": "assistant", "content": respuesta_ia})
                
                r_match = re.search(r'```[rR]\n(.*?)\n```', respuesta_ia, re.DOTALL)
                html_match = re.search(r'```html\n(.*?)\n```', respuesta_ia, re.DOTALL)
                
                col1, col2 = st.columns(2)
                if r_match:
                    with col1:
                        st.download_button(
                            label="⬇️ Descargar script_analisis.R", 
                            data=r_match.group(1), 
                            file_name="script_analisis.R", 
                            mime="text/plain"
                        )
                
                if html_match:
                    with col2:
                        codigo_html = html_match.group(1)
                        st.download_button(
                            label="🌐 Descargar informe.html", 
                            data=codigo_html, 
                            file_name="informe_clinico.html", 
                            mime="text/html"
                        )
                        st.info("💡 Abre este archivo en tu navegador y presiona **Ctrl + P** -> **Guardar como PDF** para obtener tu documento impreso perfecto.")
                        
            except Exception as e:
                st.error(f"Error en la comunicación con la API: {e}")

if __name__ == "__main__":
    pass
