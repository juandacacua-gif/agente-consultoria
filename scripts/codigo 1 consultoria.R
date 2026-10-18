# ==============================================================================
# AUDITORÍA DE CALIDAD DE DATOS (QC)
# Proyecto: Análisis de Niveles de Severidad
# ==============================================================================

# 1. Instalación y carga de paquetes requeridos
required_packages <- c("tidyverse", "janitor", "naniar")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tidyverse)
library(janitor)
library(naniar)

# 2. Carga del conjunto de datos
file_path <- "train.csv"

if(!file.exists(file_path)) {
  stop("El archivo 'train.csv' no se encuentra en el directorio de trabajo actual.")
}

df <- read_csv(file_path, show_col_types = FALSE)

cat("========================================================\n")
cat("      INFORME PRELIMINAR DE CALIDAD DE DATOS           \n")
cat("========================================================\n\n")

# ------------------------------------------------------------------------------
# A. VERIFICACIÓN DE DUPLICADOS
# ------------------------------------------------------------------------------
total_rows <- nrow(df)
total_cols <- ncol(df)
unique_ids <- n_distinct(df$study_id)
exact_duplicates <- sum(duplicated(df))
id_duplicates <- sum(duplicated(df$study_id))

cat("--> 1. RESUMEN DE DUPLICADOS:\n")
cat(" - Total de filas:", total_rows, "\n")
cat(" - Total de columnas:", total_cols, "\n")
cat(" - Identificadores únicos (study_id):", unique_ids, "\n")
cat(" - Filas exactas duplicadas:", exact_duplicates, "\n")
cat(" - 'study_id' duplicados:", id_duplicates, "\n\n")

if(id_duplicates > 0) {
  cat("⚠️ ALERTA: Existen 'study_id' repetidos. Muestra de IDs duplicados:\n")
  print(df %>% filter(duplicated(study_id) | duplicated(study_id, fromLast = TRUE)) %>% select(study_id) %>% head(6))
  cat("\n")
} else {
  cat("✔ No se encontraron IDs duplicados.\n\n")
}

# ------------------------------------------------------------------------------
# B. VERIFICACIÓN DE DATOS FALTANTES (MISSING VALUES)
# ------------------------------------------------------------------------------
cat("--> 2. AUDITORÍA DE DATOS FALTANTES (NA):\n")

missing_summary <- df %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "n_faltantes") %>%
  mutate(porcentaje = round((n_faltantes / total_rows) * 100, 2)) %>%
  filter(n_faltantes > 0) %>%
  arrange(desc(n_faltantes))

if(nrow(missing_summary) > 0) {
  cat("⚠️ Se encontraron datos faltantes en las siguientes variables:\n")
  print(missing_summary, n = 30)
} else {
  cat("✔ ¡Excelente! No hay valores faltantes en ninguna columna.\n")
}
cat("\n")

# ------------------------------------------------------------------------------
# C. AUDITORÍA DE INCONSISTENCIAS EN LOS NIVELES DE SEVERIDAD
# ------------------------------------------------------------------------------
cat("--> 3. INCONSISTENCIAS EN VALORES DE SEVERIDAD:\n")

# Seleccionamos todas las columnas excepto el identificador
condition_cols <- setdiff(names(df), "study_id")

# Obtenemos los valores únicos de severidad en todo el conjunto de datos
severity_values <- df %>%
  pivot_longer(cols = all_of(condition_cols), names_to = "condicion", values_to = "severidad") %>%
  count(severidad, name = "frecuencia_total") %>%
  mutate(porcentaje = round((frecuencia_total / (total_rows * length(condition_cols))) * 100, 2))

cat("Valores únicos detectados en las 25 columnas de condición y sus frecuencias:\n")
print(severity_values)
cat("\n")

# Comprobación de inconsistencias específicas (por ejemplo, textos imprevistos o espacios)
expected_categories <- c("Normal/Mild", "Moderate", "Severe", NA)

inconsistent_records <- df %>%
  pivot_longer(cols = all_of(condition_cols), names_to = "condicion", values_to = "severidad") %>%
  filter(!severidad %in% expected_categories)

if(nrow(inconsistent_records) > 0) {
  cat("⚠️ ATENCIÓN: Se detectaron etiquetas de severidad no estándar o erratas:\n")
  print(head(inconsistent_records, 10))
} else {
  cat("✔ Todas las etiquetas corresponden a las categorías estándar esperadas.\n")
}
cat("\n========================================================\n")

mice::md.pattern(df, rotate.names = TRUE)

# ======================================================================================
# TRATAMIENTO DE DATOS FALTANTES
# ======================================================================================

# 1. Instalación y carga de paquetes requeridos
required_packages <- c("tidyverse", "mice")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tidyverse)
library(mice)

# Asegúrate de tener cargado el dataset original
# df <- read_csv("train.csv")

# Convertimos las columnas de condición a Factores (Categorías Ordinales)
condition_cols <- setdiff(names(df), "study_id")

# Nota: Al usar polr, es ideal que los factores estén explícitamente ordenados (ordered = TRUE)
df_factores <- df %>% 
  mutate(across(all_of(condition_cols), ~ factor(., levels = c("Normal/Mild", "Moderate", "Severe"), ordered = TRUE)))

# ------------------------------------------------------------------------------ 
# OPCIÓN B: Imputación Multivariada (MICE) - *RECOMENDADA* 
# Preserva la relación entre niveles y lados (izq/der) 
# ------------------------------------------------------------------------------ 
cat("\nIniciando Imputación Multivariada MICE (Proportional Odds Logistic Regression para datos ordinales)...\n") 

# Ejecutamos MICE usando el método 'polr'
set.seed(123) # Para reproducibilidad
mice_data <- mice(df_factores, m = 1, method = 'polr', printFlag = FALSE) 

# Extraemos el dataset completo e imputado 
df_imputed_mice <- complete(mice_data)

cat("✔ Imputación MICE completada exitosamente.\n")
cat("Total de NAs post-imputación MICE:", sum(is.na(df_imputed_mice)), "\n")

# ------------------------------------------------------------------------------
# Guardar el dataset limpio
# ------------------------------------------------------------------------------
write_csv(df_imputed_mice, "train_limpio_imputado.csv")
cat("\n💾 Dataset limpio guardado exitosamente como 'train_limpio_imputado.csv'\n")

# ==============================================================================
# ANÁLISIS EXPLORATORIO (EDA) Y CO-OCURRENCIA DE CONDICIONES
# ==============================================================================

# 1. Instalación y carga de librerías necesarias
required_packages <- c("tidyverse", "rstatix", "reshape2", "viridis", "scales")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tidyverse)
library(rstatix)
library(reshape2)
library(viridis)
library(scales)

# 2. Cargar el dataset imputado
df_clean <- read_csv("train_limpio_imputado.csv", show_col_types = FALSE)
rm(df_imputed_mice)

# Definir variables de condición (excluyendo el study_id)
condition_cols <- setdiff(names(df_clean), "study_id")

# Asegurar orden del factor
severity_levels <- c("Normal/Mild", "Moderate", "Severe")
df_clean <- df_clean %>%
  mutate(across(all_of(condition_cols), ~ factor(., levels = severity_levels, ordered = TRUE)))

# ==============================================================================
# A. GRÁFICO DE BARRAS: DISTRIBUCIÓN DE SEVERIDAD POR CONDICIÓN
# ==============================================================================

# Preparar datos en formato largo
df_long <- df_clean %>%
  pivot_longer(cols = all_of(condition_cols), names_to = "condicion", values_to = "severidad")

# Calcular porcentajes por condición
df_distribucion <- df_long %>%
  count(condicion, severidad) %>%
  group_by(condicion) %>%
  mutate(porcentaje = n / sum(n))

# Graficar barras apiladas al 100%
p_barras <- ggplot(df_distribucion, aes(x = reorder(condicion, porcentaje), y = porcentaje, fill = severidad)) +
  geom_bar(stat = "identity", position = "fill", width = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_manual(values = c("Normal/Mild" = "#2ca02c", "Moderate" = "#ff7f0e", "Severe" = "#d62728")) +
  labs(
    title = "Distribución del Nivel de Severidad por Condición",
    subtitle = "Proporción de clasificaciones en las 25 evaluaciones",
    x = "Condición / Nivel Anatómico",
    y = "Proporción (%)",
    fill = "Severidad"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 14),
    axis.text.y = element_text(size = 8)
  )

print(p_barras)


# ==============================================================================
# B. MAPA DE CALOR (HEATMAP) DE CORRELACIÓN / CO-OCURRENCIA
# ==============================================================================

# Convertir severidad a puntuación numérica ordinal (0, 1, 2)
df_numeric <- df_clean %>%
  mutate(across(all_of(condition_cols), ~ as.numeric(factor(., levels = severity_levels)) - 1)) %>%
  select(all_of(condition_cols))

# Matriz de correlación de Spearman
cor_matrix <- cor(df_numeric, method = "spearman")

# Convertir la matriz en formato largo para ggplot
melted_cor <- melt(cor_matrix)

# Graficar Heatmap
p_heatmap <- ggplot(melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_viridis_c(option = "magma", direction = -1, limits = c(0, 1), name = "Rho Spearman") +
  labs(
    title = "Mapa de Calor de Co-ocurrencia y Correlación de Severidad",
    subtitle = "Correlación de rangos de Spearman entre las 25 condiciones",
    x = "", y = ""
  ) +
  theme_minimal(base_size = 10) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 7),
    axis.text.y = element_text(size = 7),
    plot.title = element_text(face = "bold", size = 14),
    panel.grid = element_blank()
  )

print(p_heatmap)


# ==============================================================================
# C. MATRIZ DE FUERZA DE ASOCIACIÓN (V DE CRAMÉR & CHI-CUADRADO)
# ==============================================================================

cat("\n--- CALCULANDO PRUEBAS DE ASOCIACIÓN DE CHI-CUADRADO Y V DE CRAMÉR ---\n")

# Función para calcular V de Cramér entre un par de variables
cramer_v_matrix <- matrix(NA, nrow = length(condition_cols), ncol = length(condition_cols),
                          dimnames = list(condition_cols, condition_cols))

for(i in 1:length(condition_cols)) {
  for(j in 1:length(condition_cols)) {
    var1 <- df_clean[[condition_cols[i]]]
    var2 <- df_clean[[condition_cols[j]]]
    cramer_v_matrix[i, j] <- cramer_v(table(var1, var2))
  }
}

# Top 10 pares de condiciones con mayor co-ocurrencia (excluyendo la diagonal)
melted_cramer <- melt(cramer_v_matrix) %>%
  filter(Var1 != Var2) %>%
  distinct(val = pmin(as.character(Var1), as.character(Var2)), 
           val2 = pmax(as.character(Var1), as.character(Var2)), .keep_all = TRUE) %>%
  arrange(desc(value)) %>%
  head(10)

cat("\nTop 10 pares de condiciones con MAYOR fuerza de co-ocurrencia (V de Cramér):\n")
print(melted_cramer %>% select(Condicion_1 = Var1, Condicion_2 = Var2, Cramer_V = value))
