# ==============================================================================
# VERIFICACIÓN DEL CÓDIGO R QUE ENTREGÓ EL AGENTE
# Ejecutar desde la raíz del repositorio (donde está train_limpio_imputado.csv).
# Es de solo lectura: no escribe archivos ni modifica los datos.
# ==============================================================================

paquetes <- c("tidyverse", "MASS", "DescTools", "rcompanion")
faltan <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]
if (length(faltan) > 0) install.packages(faltan, repos = "https://cloud.r-project.org")

suppressPackageStartupMessages({
  library(tidyverse)
  library(DescTools)
  library(rcompanion)
})
# MASS se usa con prefijo (MASS::polr) para no enmascarar dplyr::select

cat("\n==== 0. ENTORNO ====\n")
cat(R.version.string, "\n")
cat("DescTools:", as.character(packageVersion("DescTools")),
    "| rcompanion:", as.character(packageVersion("rcompanion")),
    "| MASS:", as.character(packageVersion("MASS")), "\n")

datos <- read_csv("train_limpio_imputado.csv", show_col_types = FALSE)
cat("Filas:", nrow(datos), "| Columnas:", ncol(datos), "\n")

# ------------------------------------------------------------------------------
cat("\n==== 1. ETIQUETAS REALES DE LAS VARIABLES ====\n")
# El código del agente supone c("Normal/Mild", "Moderate", "Severe").
vars_prueba <- c("spinal_canal_stenosis_l4_l5",
                 "left_neural_foraminal_narrowing_l4_l5",
                 "right_neural_foraminal_narrowing_l4_l5",
                 "left_subarticular_stenosis_l4_l5",
                 "right_subarticular_stenosis_l4_l5")
cat("¿Existen las columnas?\n")
print(vars_prueba %in% names(datos))
for (v in vars_prueba[vars_prueba %in% names(datos)]) {
  cat("\n", v, "\n", sep = "")
  print(table(datos[[v]], useNA = "ifany"))
}

niveles <- c("Normal/Mild", "Moderate", "Severe")
etiquetas_reales <- sort(unique(unlist(datos[vars_prueba[vars_prueba %in% names(datos)]])))
cat("\nEtiquetas distintas halladas:", paste(etiquetas_reales, collapse = " | "), "\n")
cat("¿Coinciden con las que supone el agente? ",
    setequal(etiquetas_reales, niveles), "\n")

# ------------------------------------------------------------------------------
cat("\n==== 2. SIMETRÍA BILATERAL: ¿QUÉ HACE CADA FUNCIÓN? ====\n")
tabla <- table(
  factor(datos$left_neural_foraminal_narrowing_l4_l5,  levels = niveles),
  factor(datos$right_neural_foraminal_narrowing_l4_l5, levels = niveles)
)
print(tabla)

cat("\n-- (a) Llamada EXACTA del agente: MHChisqTest(tabla, fitted = TRUE) --\n")
print(tryCatch(MHChisqTest(tabla, fitted = TRUE),
               error = function(e) paste("ERROR:", conditionMessage(e))))

cat("\n-- (b) MHChisqTest(tabla) sin 'fitted' --\n")
print(tryCatch(MHChisqTest(tabla),
               error = function(e) paste("ERROR:", conditionMessage(e))))

cat("\n-- (c) mcnemar.test(tabla): en tablas k x k es la prueba de simetría de Bowker --\n")
print(tryCatch(mcnemar.test(tabla),
               error = function(e) paste("ERROR:", conditionMessage(e))))

cat("\n-- (d) DescTools::BowkerTest(tabla) --\n")
print(tryCatch(BowkerTest(tabla),
               error = function(e) paste("ERROR:", conditionMessage(e))))

cat("\nDescripción oficial de MHChisqTest (primeras líneas):\n")
ayuda <- tryCatch(capture.output(tools::Rd2txt(utils:::.getHelpFile(help("MHChisqTest", package = "DescTools")))),
                  error = function(e) "No se pudo leer la ayuda; usa ?DescTools::MHChisqTest en la consola.")
cat(head(ayuda, 15), sep = "\n")

# ------------------------------------------------------------------------------
cat("\n==== 3. MODELO polr Y NOMBRES DE nagelkerke ====\n")
d <- datos %>%
  mutate(
    y   = factor(spinal_canal_stenosis_l4_l5, levels = niveles, ordered = TRUE),
    x_i = factor(left_subarticular_stenosis_l4_l5,  levels = niveles, ordered = FALSE),
    x_d = factor(right_subarticular_stenosis_l4_l5, levels = niveles, ordered = FALSE)
  )
modelo <- MASS::polr(y ~ x_i + x_d, data = d, Hess = TRUE)

cat("\nCoeficientes (solo se imprime nombre, beta y OR; revisa que haya Moderate y Severe):\n")
print(round(cbind(beta = coef(modelo), OR = exp(coef(modelo))), 3))

cat("\nElementos que devuelve nagelkerke():\n")
nk <- nagelkerke(modelo)
print(names(nk))
cat("\n¿Existe nk$PseudoR2?  ->  ", !is.null(nk$PseudoR2), "\n")
cat("Contenido real de la tabla de pseudo R2:\n")
print(nk$Pseudo.R.squared.for.model.vs.null)

# ------------------------------------------------------------------------------
cat("\n==== 4. MAE DEL MODELO FRENTE A UNA LÍNEA BASE ====\n")
obs  <- as.numeric(d$y)
pred <- as.numeric(predict(modelo, type = "class"))
mae_modelo <- mean(abs(obs - pred))
moda <- as.numeric(names(which.max(table(obs))))
mae_base <- mean(abs(obs - moda))
cat("MAE del modelo:              ", round(mae_modelo, 4), "\n")
cat("MAE de predecir siempre la moda:", round(mae_base, 4), "\n")
cat("Distribución de la respuesta (proporciones):\n")
print(round(prop.table(table(d$y)), 3))

cat("\n==== FIN: copia y pega toda esta salida en el chat ====\n")
