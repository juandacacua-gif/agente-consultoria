# Línea base — Comparación proceso manual vs. agente bioestadístico

## Pregunta de investigación
¿Existe una diferencia estadísticamente significativa en los grados de severidad degenerativa de la columna lumbar entre distintos grupos de pacientes?

## Dataset
**RSNA 2024 Lumbar Spine Degenerative Classification (Kaggle)** — Datos clínicos que incluyen la variable de severidad de la enfermedad. 
*Nota crítica del dominio:* La variable severidad es **ordinal** (Normal/Leve, Moderado, Severo), no continua.

## Proceso manual (línea base)

| Etapa | Tiempo estimado |
|---|---|
| Cargar datos, limpieza de NA's y exploración | 5 min |
| Decidir qué prueba estadística usar (riesgo de sesgo) | 10 min |
| Escribir el código para validar supuestos en R | 10 min |
| Ejecutar la prueba y lidiar con errores de sintaxis | 5 min |
| Redactar interpretación formal / Formato LaTeX | 15 min |
| **TOTAL** | **45 min** |

**Observaciones registradas durante el proceso manual:**
- **Riesgo metodológico alto:** Hubo una duda real sobre si tratar la severidad como una variable numérica (asignando 1, 2, 3) y usar una prueba paramétrica (ANOVA), o respetar su naturaleza ordinal. Optar por la primera (un error muy común en analistas junior) habría invalidado el estudio.
- **Fricción técnica:** Fue necesario consultar la documentación de `tidyverse` para recordar la sintaxis exacta de pruebas no paramétricas (ej. Kruskal-Wallis) y la creación de gráficos de diagnóstico visual.
- **Formateo:** Pasar los resultados estadísticos a un documento formal requiere trabajo manual y propenso a errores tipográficos.

## Proceso con el agente

| Etapa | Tiempo |
|---|---|
| Ejecución completa (Lectura de CSV, decisión, código R y reporte LaTeX) | 2 min |

**Observaciones registradas durante la ejecución del agente:**
- **Decisión metodológica determinística:** Gracias a las directivas del sistema (System Instructions), el agente detectó la naturaleza de los datos y recomendó inmediatamente evitar pruebas basadas en medias, proporcionando el código correcto para análisis no paramétrico.
- **Manejo de errores de red:** Durante la iteración del desarrollo, la API devolvió errores `ResourceExhausted` (Límite de tasa por capa gratuita). El bloque `try-except` del script gestionó el fallo aplicando un `time.sleep(10)` y reintentando sin que el programa colapsara. El usuario final no experimentó cierres inesperados.
- **Generación documental:** El agente fue capaz de aislar el código LaTeX del resto de la conversación y guardarlo automáticamente en un archivo `.tex` local listo para compilar.

## Comparación

| Métrica | Manual | Agente | Diferencia |
|---|---|---|---|
| Tiempo total | 45 min | 2 min | **~95% de reducción del tiempo** |
| Decisión Metodológica | Duda alta riesgo de error Tipo I / II | Regla aplicada sin dudar | El agente impone rigor estadístico de manera automatizada |
| Resiliencia de Infraestructura | Humano lidiando con foros | Degradación controlada / Reintentos | Evidencia real de la arquitectura del script en Python |
| Entregable | Texto plano / Script sucio | Código R limpio + Informe LaTeX | Salida estandarizada lista para publicación |

## Limitaciones identificadas (Guardrails)

El proceso manual permite el juicio clínico profundo ante datos altamente complejos (diseños longitudinales con múltiples variables de confusión). El agente actual está diseñado para el análisis exploratorio y pruebas de hipótesis univariadas/bivariadas claras. **El agente no diagnostica.** Ante un dataset con ruido extremo o variables clínicas ambiguas, el agente está instruido para advertir al usuario y detener el análisis automático. Esta limitación asegura la ética del uso de IA en la investigación médica.

## Nota metodológica

Esta línea base se construyó documentando el proceso teórico de un investigador médico sin conocimientos avanzados de programación en R. Los tiempos de la línea base reflejan el "costo" de buscar sintaxis en foros y dudar sobre la metodología (fricciones reales de la disciplina). El tiempo del agente es una medición real de la latencia de la API de Gemini 2.5 Flash sumado al tiempo de tipeo del prompt.
