# ==============================================================================
# SCRIPT DE ANÁLISIS ESTADÍSTICO Y CLUSTERING PARA PATOLOGÍAS LUMBARES
# Dataset: train_limpio_imputado.csv
# ==============================================================================

# 1. CARGA DE PAQUETES REQUERIDOS
# ------------------------------------------------------------------------------
# Si no tienes instalados los paquetes, ejecuta:
# install.packages(c("tidyverse", "cluster", "factoextra", "FactoMineR", "vcd"))

library(tidyverse)   # Manipulación de datos y visualización (dplyr, ggplot2, readr)
library(cluster)     # Algoritmo K-Medoides (PAM) y matriz de distancia de Gower
library(factoextra)  # Visualizaciones elegantes para Clustering y MCA
library(FactoMineR)  # Análisis de Correspondencias Múltiples (MCA)
library(vcd)         # Pruebas estadísticas para datos categóricos

# 2. CARGA Y PREPARACIÓN DE DATOS
# ------------------------------------------------------------------------------
# Cargar el archivo CSV
df <- read_csv("train_limpio_imputado.csv")

# Mostrar estructura inicial
cat("--- Estructura del Dataset ---
")
glimpse(df)

# Definir los niveles ordinales correctos
niveles_severidad <- c("Normal/Mild", "Moderate", "Severe")

# Convertir todas las columnas categóricas a factores ordenados (excluyendo study_id)
df_analisis <- df %>%
  select(-study_id) %>%
  mutate(across(everything(), ~ factor(.x, levels = niveles_severidad, ordered = TRUE)))

cat("
Resumen de variables procesadas:
")
summary(df_analisis)

# ==============================================================================
# 3. PRUEBA CHI-CUADRADA DE INDEPENDENCIA
# ==============================================================================
# Ejemplo: Evaluar la relación entre la estenosis del canal espinal en L4/L5 
# y la estenosis subarticular izquierda en L4/L5

# Usando $
var1 <- df_analisis$spinal_canal_stenosis_l4_l5
var2 <- df_analisis$left_subarticular_stenosis_l4_l5

tabla_contingencia <- table(Canal_L4_L5 = var1, Subarticular_Izq_L4_L5 = var2)

# Tabla de contingencia
tabla_contingencia <- table(var1, var2)
cat("
=== Tabla de Contingencia (Canal L4/L5 vs Subarticular Izq L4/L5) ===
")
print(tabla_contingencia)

# Prueba Chi-Cuadrada
prueba_chisq <- chisq.test(tabla_contingencia)
cat("
=== Resultado Prueba Chi-Cuadrada ===
")
print(prueba_chisq)

# Visualización de la asociación
plot(tabla_contingencia, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Relación entre Estenosis Canal L4/L5 y Subarticular Izq L4/L5")


# ==============================================================================
# 4. PRUEBA DE MCNEMAR-BOWKER (Simetría de Homólogos Izquierda vs. Derecha)
# ==============================================================================
# Ejemplo: Evaluar si existe simetría o sesgo lateral entre el lado izquierdo 
# y derecho en estrechamiento foraminal L4/L5

izq <- df_analisis$left_subarticular_stenosis_l4_l5
der <- df_analisis$right_subarticular_stenosis_l4_l5

# La prueba de McNemar-Bowker requiere una tabla cuadrada (k x k)
tabla_pareada <- table(Izquierda = izq, Derecha = der)
cat("
=== Tabla Pareada (Izquierda vs. Derecha L4/L5) ===
")
print(tabla_pareada)

# En R base, mcnemar.test realiza la prueba de McNemar-Bowker para k x k
prueba_mcnemar <- mcnemar.test(tabla_pareada)
cat("
=== Resultado Prueba McNemar-Bowker (Simetría) ===
")
print(prueba_mcnemar)


# ==============================================================================
# 5. ANÁLISIS DE CORRESPONDENCIAS MÚLTIPLES (MCA)
# ==============================================================================
# Convertir factores ordenados a factores estándar para FactoMineR MCA
df_mca <- df_analisis %>%
  mutate(across(everything(), ~ factor(as.character(.x))))

# Ejecutar MCA
mca_res <- MCA(df_mca, graph = TRUE)

# Resumen de las dimensiones principales
cat("
=== Varianza Explicada por Dimensiones MCA ===
")
print(head(mca_res))

# Gráficos del MCA
# Biplot de las categorías de variables en el espacio 2D
p_mca_var <- fviz_mca_var(mca_res, 
                          repel = TRUE, 
                          col.var = "contrib",
                          gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                          ggtheme = theme_minimal(),
                          title = "MCA - Contribución de Categorías de Severidad")

print(p_mca_var)

# Biplot de individuos (pacientes)
p_mca_ind <- fviz_mca_ind(mca_res,
                          label = "none",
                          habillage = "spinal_canal_stenosis_l4_l5", # Colorear por condición clave
                          addEllipses = TRUE,
                          ggtheme = theme_minimal(),
                          title = "MCA - Mapa de Pacientes segun Perfil Lumbar")

print(p_mca_ind)


# ==============================================================================
# 6. ANÁLISIS DE CLUSTERS CON K-MEDOIDES (PAM + Distancia de Gower)
# ==============================================================================
# 1. Calcular la matriz de distancia de Gower (ideal para variables ordinales/categóricas)
cat("
Calculando matriz de distancias de Gower...
")
dist_gower <- daisy(df_analisis, metric = "gower")

# 2. Determinar el número óptimo de clusters (Método de la Silueta)
p_sil <- fviz_nbclust(as.matrix(dist_gower), pam, method = "silhouette") +
  labs(title = "Número Óptimo de Clusters (PAM / Medoides)")
print(p_sil)

# 3. Ejecutar PAM con k = 3 clusters (por ejemplo: Leve, Moderado, Severo)
k_optimo <- 3
pam_res <- pam(dist_gower, k = k_optimo, diss = TRUE)

# Resumen del clustering
cat("
=== Tamaño de los Clusters K-Medoides ===
")
print(pam_res)

# Asignar el cluster resultante al dataset original
df_con_clusters <- df %>%
  mutate(cluster_medoide = factor(pam_res))

# 4. Visualizar los clusters sobre las dimensiones del MCA
p_clusters <- fviz_mca_ind(mca_res,
                           label = "none",
                           habillage = df_con_clusters,
                           addEllipses = TRUE,
                           ellipse.level = 0.95,
                           ggtheme = theme_minimal(),
                           title = "Clusters de K-Medoides Representados en Espacio MCA")

print(p_clusters)

# 5. Caracterización de los Medoides (Pacientes representativos de cada cluster)
cat("
=== Pacientes Medoides (Representantes Centroides) ===
")
medoides_ids <- df_con_clusters[pam_res.med, ]
print(medoides_ids)

cat("
¡Proceso completado exitosamente!
")
