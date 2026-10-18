# ==============================================================================
# INSTALACIÓN Y CARGA DE PAQUETES
# ==============================================================================
paquetes <- c("tidyverse", "janitor", "rstatix", "ggcorrplot")

paquetes_nuevos <- paquetes[!(paquetes %in% installed.packages()[,"Package"])]
if(length(paquetes_nuevos) > 0) {
  install.packages(paquetes_nuevos)
}

library(tidyverse)
library(janitor)
library(rstatix)
library(ggcorrplot)

# ==============================================================================
# 1. CARGA Y REESTRUCTURACIÓN DE DATOS (WIDE A LONG)
# ==============================================================================
datos <- read_csv("train_limpio_imputado.csv")

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

cat("--- VISTA PREVIA DE DATOS REESTRUCTURADOS (LONG FORMAT) ---\n")
print(head(datos_long, 10))

# ==============================================================================
# 2. PRUEBA CHI-CUADRADA AGRUPADA (COMPARA TIPOS DE CONDICIÓN)
# ==============================================================================
# Ejemplo: Comparar la distribución de severidad entre "Spinal Canal Stenosis"
# y "Left Neural Foraminal Narrowing" acumulando todos los niveles lumbares
tabla_agrupada <- datos_long %>%
  filter(tipo_condicion %in% c("Spinal Canal Stenosis", "Left Neural Foraminal Narrowing")) %>%
  select(tipo_condicion, severidad)

# Si prefieres usar la tabla nativa:
tabla_chi_agrupada <- table(
  datos_long$tipo_condicion[datos_long$tipo_condicion %in% c("Spinal Canal Stenosis", "Left Neural Foraminal Narrowing")],
  datos_long$severidad[datos_long$tipo_condicion %in% c("Spinal Canal Stenosis", "Left Neural Foraminal Narrowing")]
)

cat("\n--- TABLA DE CONTINGENCIA AGRUPADA ---\n")
print(tabla_chi_agrupada)

chi_agrupado <- chisq.test(tabla_chi_agrupada)
cat("\n--- PRUEBA CHI-CUADRADA ENTRE TIPOS DE CONDICIÓN ---\n")
print(chi_agrupado)

# ==============================================================================
# 3. MAPA DE CALOR CON CORRELACIÓN DE SPEARMAN
# ==============================================================================
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
  hc.order = TRUE,
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
# 4. GRÁFICOS DE BARRAS DE DISTRIBUCIÓN DE SEVERIDAD
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
