# 🩺 Reporte de Consultoría Bioestadística

**Fecha:** 2026-09-05 03:08

**Dataset Analizado:** `train.csv`

---

### 👤 **Usuario**

Genera el código en R para verificar si las variables numéricas cumplen el supuesto de normalidad.

---

### 🩺 **Consultor Bioestadístico AI**

¡Hola! Qué gusto saludarte. Veo que estás trabajando con un conjunto de datos sumamente interesante sobre evaluaciones de la columna vertebral (`train.csv`). 

Evaluar el supuesto de normalidad es un paso crucial en nuestro flujo de trabajo bioestadístico, ya que nos guiará para decidir si usaremos pruebas paramétricas (como la prueba *t* de Student o ANOVA) o alternativas no paramétricas (como Mann-Whitney o Kruskal-Wallis).

Como buena práctica, siempre recomiendo evaluar la normalidad combinando dos enfoques:
1. **Inspección visual:** Gráficos Q-Q (quantile-quantile) e histogramas con curvas de densidad. A menudo son más informativos que una prueba estricta, especialmente con muestras grandes.
2. **Pruebas numéricas:** La prueba de **Shapiro-Wilk** (ideal para muestras pequeñas/medianas, $N \le 5000$) o la prueba de **Anderson-Darling** (si tienes un dataset más masivo).

Aquí tienes un código limpio, reproducible y basado en el universo `tidyverse` para analizar tus variables numéricas:

```R
# ==============================================================================
# Verificación del Supuesto de Normalidad
# Consultoría Bioestadística
# ==============================================================================

# 1. Cargar librerías necesarias
library(tidyverse)
library(nortest) # Para pruebas de normalidad en muestras grandes (ej. Anderson-Darling)

# 2. Cargar el dataset
# Nota: Asegúrate de que 'train.csv' esté en tu directorio de trabajo
df <- read_csv("train.csv")

# 3. Seleccionar las variables numéricas (excluyendo la ID de estudio)
variables_numericas <- df %>%
  select(-study_id) %>%
  select(where(is.numeric))

# ------------------------------------------------------------------------------
# A. EVALUACIÓN ANALÍTICA (Pruebas Estadísticas)
# ------------------------------------------------------------------------------

# Función para calcular la normalidad según el tamaño de muestra
evaluar_normalidad_stats <- function(data) {
  data %>%
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "Valor") %>%
    drop_na(Valor) %>% # Excluimos valores faltantes para las pruebas
    group_by(Variable) %>%
    summarise(
      N = n(),
      Promedio = mean(Valor),
      Desv_Estd = sd(Valor),
      # Si N <= 5000 usamos Shapiro-Wilk, si no, Anderson-Darling
      Estadistico_p_val = ifelse(
        N <= 5000, 
        shapiro.test(if(N > 5000) sample(Valor, 5000) else Valor)$p.value,
        ad.test(Valor)$p.value
      ),
      Prueba_Utilizada = if_else(N <= 5000, "Shapiro-Wilk", "Anderson-Darling"),
      Cumple_Normalidad_alpha_0.05 = if_else(Estadistico_p_val > 0.05, "Sí", "No")
    )
}

# Ejecutar y ver la tabla de resultados
resultados_normalidad <- evaluar_normalidad_stats(variables_numericas)
print(resultados_normalidad)


# ------------------------------------------------------------------------------
# B. EVALUACIÓN VISUAL (Gráficos Q-Q e Histogramas)
# ------------------------------------------------------------------------------

# Preparar datos en formato largo para facilitar la graficación masiva
df_long <- variables_numericas %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Valor") %>%
  drop_na(Valor)

# 1. Histogramas con curva de densidad
ggplot(df_long, aes(x = Valor)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "steelblue", alpha = 0.6, color = "white") +
  geom_density(color = "darkred", size = 1) +
  facet_wrap(~ Variable, scales = "free") +
  theme_minimal() +
  labs(
    title = "Distribución e Histogramas de Variables Numéricas",
    subtitle = "La línea roja representa la densidad empírica de los datos",
    x = "Valor",
    y = "Densidad"
  )

# 2. Gráficos Q-Q (Quantile-Quantile Plots)
# En un Q-Q plot, si los puntos siguen la línea punteada, la variable es normal.
ggplot(df_long, aes(sample = Valor)) +
  stat_qq_line(color = "firebrick", linetype = "dashed", size = 0.8) +
  stat_qq(color = "navy", alpha = 0.5, size = 1) +
  facet_wrap(~ Variable, scales = "free") +
  theme_minimal() +
  labs(
    title = "Gráficos Q-Q de Normalidad",
    subtitle = "Los puntos deben alinearse con la diagonal si la distribución es normal",
    x = "Cuantiles Teóricos",
    y = "Cuantiles Muestrales"
  )
```

### Un par de consejos bioestadísticos para interpretar tus resultados:

1. **Atención con el valor p ($p$-value):** En datasets biomédicos grandes, las pruebas de hipótesis (como Shapiro-Wilk) se vuelven muy sensibles. A veces, desviaciones minúsculas y sin relevancia clínica pueden resultar en un $p < 0.05$ (rechazando normalidad). Por eso, **fíate mucho de los gráficos Q-Q**.
2. **Si tus variables son puntuaciones discretas o grados de estenosis** (por ejemplo, escalas ordinales 0, 1, 2, 3), es esperable que no sigan una normalidad estricta. Si ese es el caso, las pruebas no paramétricas o modelos ordinales serán tus mejores aliados.

¡Espero que este código te sea de gran utilidad! Quedo a tu entera disposición si necesitas ayuda interpretando los gráficos o decidiendo qué prueba estadística usar a continuación. ¡Mucho éxito con tu análisis!

---

