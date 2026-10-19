# ==============================================================================
# AUDITORÍA DE CALIDAD DE DATOS (QC)
# Proyecto: Análisis de Niveles de Severidad
# ==============================================================================

# 1. Instalación y carga de paquetes requeridos
required_packages <- c("tidyverse", "janitor", "naniar", "mice", "rstatix", "ggcorrplot")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tidyverse)
library(janitor)
library(naniar)
library(mice)
library(rstatix)
library(ggcorrplot)

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
# 1. TRATAMIENTO DE DATOS FALTANTES
# ======================================================================================

# df <- read_csv("train.csv")

# Convertimos las columnas de condición a Factores (Categorías Ordinales)
condition_cols <- setdiff(names(df), "study_id")

# Nota: Al usar polr, es ideal que los factores estén explícitamente ordenados (ordered = TRUE)
df_factores <- df %>% 
  mutate(across(all_of(condition_cols), ~ factor(., levels = c("Normal/Mild", "Moderate", "Severe"), ordered = TRUE)))

# ------------------------------------------------------------------------------ 
# Imputación Multivariada (MICE) - Preserva la relación entre niveles y lados (izq/der) 
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
# 2. MAPA DE CALOR CON CORRELACIÓN DE SPEARMAN
# ==============================================================================

datos = read.csv("train_limpio_imputado.csv")

# Transformar datos a formato largo para facilitar análisis agrupados
datos_long <- datos %>%
  pivot_longer(
    cols = -study_id,
    names_to = "variable_raw",
    values_to = "severidad"
  ) %>%
  mutate(
    # Extraer el nivel lumbar (ej. l1_l2, l2_l3, etc.)
    nivel_lumbar = str_extract(variable_raw, "l[1-5]_[l-s][1-5]") %>% str_to_upper() %>% str_replace("_", "/"),
    # Extraer el tipo de condición clínica/anatómica
    tipo_condicion = str_remove(variable_raw, "_l[1-5]_[l-s][1-5]") %>%
      str_replace_all("_", " ") %>%
      str_to_title()
  )

# Para Spearman, mapeamos la severidad categórica a una escala ordinal numérica
# Adaptamos este mapeo si tus valores ya son numéricos o tienen otros nombres:
mapa_severidad <- c(
  "Normal/Mild" = 0, "Normal" = 0, "Mild" = 0, "0" = 0,
  "Moderate"    = 1, "1" = 1,
  "Severe"      = 2, "2" = 2
)

# Convertir las variables del dataset original a formato numérico ordinal
datos_numericos <- datos %>%
  select(-study_id) %>%
  mutate(across(everything(), ~ ifelse(.x %in% names(mapa_severidad), mapa_severidad[.x], as.numeric(.x))))

# Calcular matriz de correlación de Spearman
matriz_cor_spearman <- cor(datos_numericos, method = "spearman", use = "pairwise.complete.obs")

# Graficar el mapa de calor (Heatmap)
p_heatmap <- ggcorrplot(
  matriz_cor_spearman, 
  hc.order = FALSE, # Cambia a TRUE solo cuando la matriz no tenga NAs
  type = "lower", 
  lab = FALSE, 
  colors = c("#6D9EC1", "white", "#E46726"), 
  title = "Mapa de Calor: Correlaciones de Spearman entre Variables y Niveles", 
  ggtheme = theme_minimal()
) + 
  theme( 
    axis.text.x = element_text(angle = 90, hjust = 1, size = 8), 
    axis.text.y = element_text(size = 8), 
    plot.title = element_text(hjust = 0.5, face = "bold") 
  )

print(p_heatmap)

# ==============================================================================
# 3. GRÁFICOS DE BARRAS DE DISTRIBUCIÓN DE SEVERIDAD
# ==============================================================================
# Gráfico 1: Distribución global de severidad por Tipo de Condición
p_barras_tipo <- datos_long %>%
  # 1. Forzamos el orden correcto de los niveles
  mutate(severidad = factor(severidad, levels = c("Normal/Mild", "Moderate", "Severe"))) %>% 
  
  # 2. Pasamos el resultado al ggplot (ya no necesitas usar factor() dentro de aes)
  ggplot(aes(x = tipo_condicion, fill = severidad)) +
  geom_bar(position = "fill", color = "black", alpha = 0.85) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2", name = "Severidad") +
  labs(
    title = "Distribución Proporcional de Severidad según Tipo de Condición",
    x = "Tipo de Condición Anatómica",
    y = "Proporción (%)"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold"),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

print(p_barras_tipo)

# Gráfico 2: Distribución por Nivel Lumbar y Tipo de Condición (Facetado)
p_barras_facet <- datos_long %>%
  # 1. Forzamos el orden correcto de los niveles
  mutate(severidad = factor(severidad, levels = c("Normal/Mild", "Moderate", "Severe"))) %>% 
  ggplot(aes(x = nivel_lumbar, fill = severidad)) +
  geom_bar(position = "fill", color = "white") +
  facet_wrap(~ tipo_condicion, ncol = 3) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_viridis_d(option = "plasma", name = "Severidad") +
  labs(
    title = "Distribución de Severidad por Nivel Lumbar y Condición",
    x = "Nivel Lumbar",
    y = "Proporción (%)"
  ) +
  theme_light() +
  theme(
    strip.text = element_text(face = "bold", size = 10),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

print(p_barras_facet)