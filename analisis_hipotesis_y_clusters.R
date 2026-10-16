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

# Todas las tablas de contingencia para los gráficos (1-5 sub der, 6-10 sub izq, 11-15 foram der, 16-20 foram izq)

tabla01<-table(df_analisis$spinal_canal_stenosis_l1_l2, df_analisis$right_subarticular_stenosis_l1_l2)
tabla02<-table(df_analisis$spinal_canal_stenosis_l2_l3, df_analisis$right_subarticular_stenosis_l2_l3)
tabla03<-table(df_analisis$spinal_canal_stenosis_l3_l4, df_analisis$right_subarticular_stenosis_l3_l4)
tabla04<-table(df_analisis$spinal_canal_stenosis_l4_l5, df_analisis$right_subarticular_stenosis_l4_l5)
tabla05<-table(df_analisis$spinal_canal_stenosis_l5_s1, df_analisis$right_subarticular_stenosis_l5_s1)

tabla06<-table(df_analisis$spinal_canal_stenosis_l1_l2, df_analisis$left_subarticular_stenosis_l1_l2)
tabla07<-table(df_analisis$spinal_canal_stenosis_l2_l3, df_analisis$left_subarticular_stenosis_l2_l3)
tabla08<-table(df_analisis$spinal_canal_stenosis_l3_l4, df_analisis$left_subarticular_stenosis_l3_l4)
tabla09<-table(df_analisis$spinal_canal_stenosis_l4_l5, df_analisis$left_subarticular_stenosis_l4_l5)
tabla10<-table(df_analisis$spinal_canal_stenosis_l5_s1, df_analisis$left_subarticular_stenosis_l5_s1)

tabla11<-table(df_analisis$spinal_canal_stenosis_l1_l2, df_analisis$right_neural_foraminal_narrowing_l1_l2)
tabla12<-table(df_analisis$spinal_canal_stenosis_l2_l3, df_analisis$right_neural_foraminal_narrowing_l2_l3)
tabla13<-table(df_analisis$spinal_canal_stenosis_l3_l4, df_analisis$right_neural_foraminal_narrowing_l3_l4)
tabla14<-table(df_analisis$spinal_canal_stenosis_l4_l5, df_analisis$right_neural_foraminal_narrowing_l4_l5)
tabla15<-table(df_analisis$spinal_canal_stenosis_l5_s1, df_analisis$right_neural_foraminal_narrowing_l5_s1)

tabla16<-table(df_analisis$spinal_canal_stenosis_l1_l2, df_analisis$left_neural_foraminal_narrowing_l1_l2)
tabla17<-table(df_analisis$spinal_canal_stenosis_l2_l3, df_analisis$left_neural_foraminal_narrowing_l2_l3)
tabla18<-table(df_analisis$spinal_canal_stenosis_l3_l4, df_analisis$left_neural_foraminal_narrowing_l3_l4)
tabla19<-table(df_analisis$spinal_canal_stenosis_l4_l5, df_analisis$left_neural_foraminal_narrowing_l4_l5)
tabla20<-table(df_analisis$spinal_canal_stenosis_l5_s1, df_analisis$left_neural_foraminal_narrowing_l5_s1)

# Pruebas x2

chisq.test(tabla01)
chisq.test(tabla02)
chisq.test(tabla03)
chisq.test(tabla04)
chisq.test(tabla05)

chisq.test(tabla06)
chisq.test(tabla07)
chisq.test(tabla08)
chisq.test(tabla09)
chisq.test(tabla10)

chisq.test(tabla11)
chisq.test(tabla12)
chisq.test(tabla13)
chisq.test(tabla14)
chisq.test(tabla15)

chisq.test(tabla16)
chisq.test(tabla17)
chisq.test(tabla18)
chisq.test(tabla19)
chisq.test(tabla20)

# Gráficos

par(mfrow = c(2, 3))

plot(tabla01, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L1_L2")
plot(tabla02, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L2_L3")
plot(tabla03, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L3_L4")
plot(tabla04, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L4_L5")
plot(tabla05, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L5_S1")


# Restaurar la configuración original (1 sola gráfica por ventana)
par(mfrow = c(1, 1))


par(mfrow = c(2, 3))

plot(tabla06, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L1_L2")
plot(tabla07, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L2_L3")
plot(tabla08, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L3_L4")
plot(tabla09, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L4_L5")
plot(tabla10, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L5_S1")


# Restaurar la configuración original (1 sola gráfica por ventana)
par(mfrow = c(1, 1))

par(mfrow = c(2, 3))

plot(tabla11, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L1_L2")
plot(tabla12, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L2_L3")
plot(tabla13, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L3_L4")
plot(tabla14, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L4_L5")
plot(tabla15, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L5_S1")


# Restaurar la configuración original (1 sola gráfica por ventana)
par(mfrow = c(1, 1))

par(mfrow = c(2, 3))


plot(tabla16, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L1_L2")
plot(tabla17, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L2_L3")
plot(tabla18, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L3_L4")
plot(tabla19, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L4_L5")
plot(tabla20, col = c("#6baed6", "#fd8d3c", "#e31a1c"),
     main = "Nivel L5_S1")


# Restaurar la configuración original (1 sola gráfica por ventana)
par(mfrow = c(1, 1))

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

homologo01 = table(Izquierda = df_analisis$left_subarticular_stenosis_l1_l2, Derecha = df_analisis$right_subarticular_stenosis_l1_l2)
homologo02 = table(Izquierda = df_analisis$left_subarticular_stenosis_l2_l3, Derecha = df_analisis$right_subarticular_stenosis_l2_l3)
homologo03 = table(Izquierda = df_analisis$left_subarticular_stenosis_l3_l4, Derecha = df_analisis$right_subarticular_stenosis_l3_l4)
homologo04 = table(Izquierda = df_analisis$left_subarticular_stenosis_l4_l5, Derecha = df_analisis$right_subarticular_stenosis_l4_l5)
homologo05 = table(Izquierda = df_analisis$left_subarticular_stenosis_l5_s1, Derecha = df_analisis$right_subarticular_stenosis_l5_s1)
homologo06 = table(Izquierda = df_analisis$left_neural_foraminal_narrowing_l1_l2, Derecha = df_analisis$right_neural_foraminal_narrowing_l1_l2)
homologo07 = table(Izquierda = df_analisis$left_neural_foraminal_narrowing_l2_l3, Derecha = df_analisis$right_neural_foraminal_narrowing_l2_l3)
homologo08 = table(Izquierda = df_analisis$left_neural_foraminal_narrowing_l3_l4, Derecha = df_analisis$right_neural_foraminal_narrowing_l3_l4)
homologo09 = table(Izquierda = df_analisis$left_neural_foraminal_narrowing_l4_l5, Derecha = df_analisis$right_neural_foraminal_narrowing_l4_l5)
homologo10 = table(Izquierda = df_analisis$left_neural_foraminal_narrowing_l5_s1, Derecha = df_analisis$right_neural_foraminal_narrowing_l5_s1)

mcnemar.test(homologo01)
mcnemar.test(homologo02)
mcnemar.test(homologo03)
mcnemar.test(homologo04)
mcnemar.test(homologo05)
mcnemar.test(homologo06)
mcnemar.test(homologo07)
mcnemar.test(homologo08)
mcnemar.test(homologo09)
mcnemar.test(homologo10)

# ==============================================================================
# 5. ANÁLISIS DE CORRESPONDENCIAS MÚLTIPLES (MCA)
# ==============================================================================
# Convertir factores ordenados a factores estándar para FactoMineR MCA
df_mca <- df_analisis %>%
  mutate(across(everything(), ~ factor(as.character(.x))))

# Ejecutar MCA
mca_res <- MCA(df_mca, graph = FALSE)

# Resumen de las dimensiones principales
cat("
=== Varianza Explicada por Dimensiones MCA ===
")
print(head(mca_res))

# Gráficos del MCA

# Biplot de individuos (pacientes)
p_mca_ind <- fviz_mca_ind(mca_res,
                          label = "none",
                          habillage = "spinal_canal_stenosis_l4_l5", # Colorear por condición clave
                          addEllipses = TRUE,
                          ggtheme = theme_minimal(),
                          title = "MCA - Mapa de Pacientes segun Perfil Lumbar")

print(p_mca_ind)
