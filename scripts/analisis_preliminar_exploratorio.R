# ==============================================================================
# AUDITORÍA DE CALIDAD DE DATOS
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

# Correlacion de Spearman
# Transformar a valores numericos para poder hacer la correlación
df_num <- datos %>%
  dplyr::select(-study_id) %>%
  mutate(across(everything(), ~ case_when(
    .x == "Normal/Mild" ~ 0,
    .x == "Moderate"    ~ 1,
    .x == "Severe"      ~ 2
  )))

# Matriz de correlación de Spearman completa (25x25)
matriz_corr_25x25 <- cor(df_num, method = "spearman")

# Definir los 5 grandes grupos de condiciones anatómicas
grupos <- list(
  "Canal Espinal"     = 1:5,    # Columnas 1 a 5 (L1-L2 a L5-S1)
  "Foraminal Izq."    = 6:10,   # Columnas 6 a 10
  "Foraminal Der."    = 11:15,  # Columnas 11 a 15
  "Subarticular Izq." = 16:20,  # Columnas 16 a 20
  "Subarticular Der." = 21:25   # Columnas 21 a 25
)

# Crear la matriz vacía de 5x5 y calcular el promedio de correlación entre grupos
matriz_macro <- matrix(NA, nrow = 5, ncol = 5, 
                       dimnames = list(names(grupos), names(grupos)))

for (i in 1:5) {
  for (j in 1:5) {
    # Promedio de las correlaciones entre las 5 variables del grupo i y las 5 del grupo j
    matriz_macro[i, j] <- mean(matriz_corr_25x25[grupos[[i]], grupos[[j]]])
  }
}

# Convertir la matriz 5x5 a Formato Largo (df_macro_long)
df_macro_long <- as.data.frame(as.table(matriz_macro)) %>%
  rename(
    Condicion1  = Var1,
    Condicion2  = Var2,
    Correlacion = Freq
  )

# Graficar el mapa de calor sintetizado 5x5
p_macro <- ggplot(df_macro_long, aes(x = Condicion1, y = Condicion2, fill = Correlacion)) +
  geom_tile(color = "white", size = 1) +
  geom_text(aes(label = sprintf("%.2f", Correlacion)), color = "black", fontface = "bold", size = 4.5) +
  scale_fill_gradient(low = "#ffffcc", high = "#e31a1c", name = "Rho Promedio") +
  labs(
    title = "Correlación Promedio entre Tipos de Condición Anatómica",
    x = "", y = ""
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13, margin = margin(b = 12)),
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold", size = 10, color = "black"),
    axis.text.y = element_text(face = "bold", size = 10, color = "black"),
    plot.margin = margin(t = 15, r = 15, b = 15, l = 15)
  )

print(p_macro)

# ==============================================================================
# 3. GRÁFICOS DE BARRAS DE DISTRIBUCIÓN DE SEVERIDAD
# ==============================================================================
# Gráfico 1: Distribución global de severidad por Tipo de Condición
# Paleta de colores clínica / semántica
colores_severidad <- c(
  "Normal/Mild" = "#2ca25f", # Verde médico tranquilo
  "Moderate"    = "#fdbb84", # Naranja / Ámbar
  "Severe"      = "#e31a1c"  # Rojo de alerta
)

p_barras_tipo <- datos_long %>%
  # 1. Forzamos el orden correcto de los niveles
  mutate(severidad = factor(severidad, levels = c("Normal/Mild", "Moderate", "Severe"))) %>% 
  ggplot(aes(x = tipo_condicion, fill = severidad)) +
  geom_bar(position = "fill", color = "black", size = 0.3, alpha = 0.9) +
  # Paleta de colores manual ordenada
  scale_fill_manual(values = colores_severidad, name = "Severidad") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), expand = c(0, 0)) +
  labs(
    title = "Distribución Proporcional de Severidad según Tipo de Condición",
    x = "Tipo de Condición Anatómica",
    y = "Proporción (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    # Título centrado y con margen suficiente
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13, margin = margin(b = 12)),
    # Eje X con ángulo adecuado y alineación para evitar recortes
    axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1, face = "bold", size = 10, color = "black"),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.x = element_text(face = "bold", size = 11, margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", size = 11, margin = margin(r = 10)),
    # Leyenda clara
    legend.title = element_text(face = "bold", size = 11),
    legend.text = element_text(size = 10),
    # Márgenes de seguridad alrededor del gráfico
    plot.margin = margin(t = 15, r = 15, b = 20, l = 15)
  )

print(p_barras_tipo)

# Gráfico 2: Distribución por Nivel Lumbar y Tipo de Condición (Facetado)
p_barras_facet <- datos_long %>%
  # 1. Orden de niveles de severidad
  mutate(severidad = factor(severidad, levels = c("Normal/Mild", "Moderate", "Severe"))) %>% 
  ggplot(aes(x = nivel_lumbar, fill = severidad)) +
  geom_bar(position = "fill", color = "white", size = 0.2) +
  # labeller = label_wrap_gen(width = 22) envuelve los títulos largos en 2 líneas
  facet_wrap(~ tipo_condicion, ncol = 3, labeller = label_wrap_gen(width = 22)) +
  # Paleta semántica idéntica
  scale_fill_manual(values = colores_severidad, name = "Severidad") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), expand = c(0, 0)) +
  labs(
    title = "Distribución de Severidad por Nivel Lumbar y Condición Anatómica",
    x = "Nivel Lumbar",
    y = "Proporción (%)"
  ) +
  theme_light(base_size = 11) +
  theme(
    # Título principal
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13, margin = margin(b = 12)),
    # Cabeceras de los Facets (rectángulo oscuro con texto blanco para legibilidad)
    strip.background = element_rect(fill = "#2c3e50"),
    strip.text = element_text(face = "bold", size = 9.5, color = "white", margin = margin(t = 5, b = 5)),
    # Eje X inclinado a 45° para que L1/L2, L2/L3... no se solapen
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 8.5, color = "black", face = "bold"),
    axis.text.y = element_text(size = 9, color = "black"),
    axis.title.x = element_text(face = "bold", size = 11, margin = margin(t = 8)),
    axis.title.y = element_text(face = "bold", size = 11, margin = margin(r = 8)),
    # Leyenda y márgenes
    legend.title = element_text(face = "bold", size = 10.5),
    legend.position = "right",
    plot.margin = margin(t = 15, r = 15, b = 15, l = 15)
  )


print(p_barras_facet)
