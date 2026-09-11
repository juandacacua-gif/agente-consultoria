# 🩺 Reporte de Consultoría Bioestadística

**Fecha:** 2026-09-09 00:45

**Dataset Analizado:** `train_limpio_imputado.csv`

---

### 👤 **Usuario**

Hola, revisa este csv que he enviado, me ayudas a aplicar la prueba x2 de independencia?

---

### 🩺 **Consultor Bioestadístico AI**

¡Hola! Qué gusto saludarte. Con mucho gusto te ayudo a analizar tus datos y aplicar la prueba de Chi-cuadrada ($\chi^2$) de independencia. 

Como tienes variables categóricas que representan severidades o condiciones en distintas regiones lumbares (como la estenosis del canal espinal, estrechamiento foraminal o estenosis subarticular), la prueba de $\chi^2$ es justo la herramienta idónea para explorar si existe una asociación estadísticamente significativa entre dos de estas condiciones.

Para este ejemplo, he seleccionado dos variables del nivel **L4-L5** (`spinal_canal_stenosis_l4_l5` y `left_subarticular_stenosis_l4_l5`), pero el código está diseñado para que puedas cambiar los nombres de las variables fácilmente según la hipótesis que quieras evaluar.

Aquí tienes el código completo y reproducible en **R**:

```R
# ==============================================================================
# INSTALACIÓN Y CARGA DE PAQUETES
# ==============================================================================
# Lista de paquetes requeridos
paquetes <- c("tidyverse", "janitor", "rstatix")

# Instalación de paquetes si aún no están instalados
paquetes_nuevos <- paquetes[!(paquetes %in% installed.packages()[,"Package"])]
if(length(paquetes_nuevos) > 0) {
  install.packages(paquetes_nuevos)
}

# Cargar las librerías
library(tidyverse)
library(janitor)
library(rstatix)

# ==============================================================================
# 1. CARGA Y EXPLORACIÓN INICIAL DE DATOS
# ==============================================================================
# Leer el dataset imputado
datos <- read_csv("train_limpio_imputado.csv")

# Inspeccionar las primeras filas y estructura
glimpse(datos)

# ==============================================================================
# 2. SELECCIÓN DE VARIABLES Y TABLA DE CONTINGENCIA
# ==============================================================================
# Definimos las dos variables a comparar (puedes cambiar estos nombres)
var1 <- "spinal_canal_stenosis_l4_l5"
var2 <- "left_subarticular_stenosis_l4_l5"

# Crear la tabla de frecuencias cruzadas (tabla de contingencia)
tabla_contingencia <- table(datos[[var1]], datos[[var2]])

cat("--- TABLA DE CONTINGENCIA (Frecuencias Observadas) ---\n")
print(tabla_contingencia)

# Visualización bonita con porcentajes usando 'janitor'
tabla_porcentajes <- datos %>%
  tabyl(!!sym(var1), !!sym(var2)) %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()

cat("\n--- TABLA DE CONTINGENCIA DETALLADA (% por fila y N) ---\n")
print(tabla_porcentajes)

# ==============================================================================
# 3. APLICACIÓN DE LA PRUEBA CHI-CUADRADA (x2)
# ==============================================================================
prueba_chi2 <- chisq.test(tabla_contingencia)

cat("\n--- RESULTADOS DE LA PRUEBA CHI-CUADRADA ---\n")
print(prueba_chi2)

# ==============================================================================
# 4. VERIFICACIÓN DE SUPUESTOS
# ==============================================================================
# La prueba asume que la mayoría de las celdas de frecuencias esperadas son >= 5
cat("\n--- FRECUENCIAS ESPERADAS (Para verificación de supuestos) ---\n")
print(prueba_chi2$expected)

# Evaluación automatizada del supuesto
celdas_pequenas <- sum(prueba_chi2$expected < 5)
porcentaje_pequenas <- (celdas_pequenas / length(prueba_chi2$expected)) * 100

if (porcentaje_pequenas > 20) {
  message("\n[Nota Biostadística]: Más del 20% de las celdas esperadas son menores a 5.")
  message("Se recomienda considerar la Prueba Exacta de Fisher o simular p-valores por Monte Carlo:")
  
  # Prueba exacta de Fisher (con simulación por si la matriz es grande)
  prueba_fisher <- fisher.test(tabla_contingencia, simulate.p.value = TRUE, B = 10000)
  print(prueba_fisher)
} else {
  cat("\n¡Los supuestos de la prueba Chi-cuadrada se cumplen adecuadamente!\n")
}

# ==============================================================================
# 5. TAMAÑO DEL EFECTO (V de Cramer)
# ==============================================================================
# Para medir la fuerza de la asociación (0 = sin asociación, 1 = asociación perfecta)
efecto <- cramer_v(tabla_contingencia)
cat("\n--- TAMAÑO DEL EFECTO ---\n")
cat("V de Cramer:", round(efecto, 3), "\n")
```

---

### 💡 ¿Cómo interpretar los resultados que verás en R?

1. **Hipótesis Nula ($H_0$):** No existe asociación entre las dos condiciones (son independientes).
2. **Hipótesis Alternativa ($H_1$):** Existe una asociación significativa entre las dos condiciones.
3. **p-valor (*p-value*):**
   * Si $p < 0.05$, rechazamos $H_0$. Concluimos que existe una dependencia o asociación estadísticamente significativa entre las dos variables.
   * Si $p \ge 0.05$, no hay evidencia suficiente para afirmar que las variables estén asociadas.
4. **V de Cramer:**
   * **< 0.1:** Asociación insignificante.
   * **0.1 - 0.3:** Asociación débil.
   * **0.3 - 0.5:** Asociación moderada.
   * **> 0.5:** Asociación fuerte.

Dime, ¿te gustaría que hagamos este análisis para algún par de variables específico de tu dataset, o prefieres que preparemos un **informe formal** con los resultados de todas las combinaciones? ¡Aquí estoy para lo que necesites!

---

