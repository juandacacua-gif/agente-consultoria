# ==============================================================================
# ANÁLISIS DEL EXPERIMENTO — Actividad "Nada sin fuente"
# Proporción de referencias utilizables por tratamiento (A/B/C) + acuerdo
# entre clasificadores (Juan David y Camilo)
# ==============================================================================
#
# CÓMO SE USA:
# 1. Cada uno abre las referencias por separado (sin consultarse) y llena su
#    propia columna en clasificacion_referencias.csv:
#      clasificacion_juan / clasificacion_camilo
#    Valores permitidos (se puede escribir con o sin tildes/mayúsculas):
#      "Utilizable"
#      "Existe pero no dice eso"
#      "No existe"
# 2. Corran este script. La primera parte reporta en cuántas filas NO
#    coincidieron los dos clasificadores (eso se discute y se reporta tal
#    cual, no se oculta).
# 3. Después de discutir los desacuerdos, agreguen a mano una columna
#    "clasificacion_final" en el CSV con la decisión acordada para cada fila
#    (para las que sí coincidieron, es simplemente la misma clasificación).
#    Vuelvan a correr el script: ahora también calcula la proporción de
#    referencias utilizables por tratamiento, con intervalo de Wilson.
#
# ==============================================================================

# 1. Paquetes ------------------------------------------------------------------
paquetes <- c("tidyverse", "irr", "binom", "janitor")
paquetes_nuevos <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]
if (length(paquetes_nuevos) > 0) install.packages(paquetes_nuevos)

library(tidyverse)
library(irr)
library(binom)
library(janitor)

# 2. Carga y normalización de datos --------------------------------------------
file_path <- "clasificacion_referencias.csv"
if (!file.exists(file_path)) {
  stop("No se encuentra 'clasificacion_referencias.csv' en el directorio de trabajo actual.")
}

datos <- read_csv(file_path, show_col_types = FALSE) %>% clean_names()

# Normaliza texto libre a tres categorías fijas, para que no fallen por
# tildes, mayúsculas o espacios de más.
normalizar_clasificacion <- function(x) {
  x <- str_squish(str_to_lower(x))
  case_when(
    str_detect(x, "^utilizable") ~ "Utilizable",
    str_detect(x, "^existe")     ~ "Existe pero no dice eso",
    str_detect(x, "^no existe")  ~ "No existe",
    TRUE ~ NA_character_
  )
}

datos <- datos %>%
  mutate(
    tratamiento = factor(tratamiento, levels = c("A", "B", "C")),
    clasificacion_juan   = normalizar_clasificacion(clasificacion_juan),
    clasificacion_camilo = normalizar_clasificacion(clasificacion_camilo)
  )

# 3. Cobertura: filas todavía sin clasificar ------------------------------------
pendientes <- datos %>%
  filter(is.na(clasificacion_juan) | is.na(clasificacion_camilo))

cat("========================================================\n")
cat("  FILAS SIN CLASIFICAR POR AL MENOS UNO DE LOS DOS\n")
cat("========================================================\n")
if (nrow(pendientes) > 0) {
  cat("Faltan", nrow(pendientes), "fila(s) por clasificar. Complétenlas antes de\n")
  cat("interpretar el resto de los resultados.\n\n")
  print(pendientes %>% select(integrante_consulta, tratamiento, referencia))
} else {
  cat("Todas las filas tienen clasificación de ambos integrantes.\n")
}
cat("\n")

datos_completos <- datos %>% filter(!is.na(clasificacion_juan), !is.na(clasificacion_camilo))

# 4. Acuerdo entre clasificadores (kappa de Cohen) ------------------------------
cat("========================================================\n")
cat("  ACUERDO ENTRE CLASIFICADORES (KAPPA DE COHEN)\n")
cat("========================================================\n\n")

desacuerdos <- datos_completos %>%
  filter(clasificacion_juan != clasificacion_camilo)

cat("De", nrow(datos_completos), "referencias clasificadas por ambos, no coincidieron en",
    nrow(desacuerdos), "\n")
cat("(", round(100 * nrow(desacuerdos) / nrow(datos_completos), 1), "% de desacuerdo )\n\n", sep = "")

if (nrow(desacuerdos) > 0) {
  cat("--- Filas en desacuerdo (para discutir y decidir clasificacion_final) ---\n")
  print(desacuerdos %>%
          select(tratamiento, referencia, clasificacion_juan, clasificacion_camilo))
  cat("\n")
}

# Kappa global
kappa_global <- kappa2(datos_completos %>% select(clasificacion_juan, clasificacion_camilo))
cat("--- Kappa de Cohen, global ---\n")
print(kappa_global)
cat("\n")

# Kappa por tratamiento (si hay suficientes filas y categorías por tratamiento)
cat("--- Kappa de Cohen, por tratamiento ---\n")
for (trat in levels(datos_completos$tratamiento)) {
  sub <- datos_completos %>% filter(tratamiento == trat)
  if (nrow(sub) >= 3 && n_distinct(c(sub$clasificacion_juan, sub$clasificacion_camilo)) > 1) {
    cat("\nTratamiento", trat, ":\n")
    print(kappa2(sub %>% select(clasificacion_juan, clasificacion_camilo)))
  } else {
    cat("\nTratamiento", trat, ": muy pocas filas o sin variación para calcular kappa.\n")
  }
}
cat("\n")

# 5. Proporción de referencias utilizables por tratamiento (usa clasificacion_final) ----
cat("========================================================\n")
cat("  PROPORCIÓN DE REFERENCIAS UTILIZABLES POR TRATAMIENTO\n")
cat("========================================================\n\n")

if (!"clasificacion_final" %in% names(datos)) {
  cat("Todavía no existe la columna 'clasificacion_final' en el CSV.\n")
  cat("Discutan los desacuerdos de arriba, agréguenla a mano en el archivo\n")
  cat("(para las filas donde sí coincidieron, es la misma clasificación) y\n")
  cat("vuelvan a correr el script para obtener las proporciones e intervalos.\n")
} else {
  datos_final <- datos %>%
    mutate(clasificacion_final = normalizar_clasificacion(clasificacion_final)) %>%
    filter(!is.na(clasificacion_final))

  resumen <- datos_final %>%
    group_by(tratamiento) %>%
    summarise(
      n_total = n(),
      n_utilizable = sum(clasificacion_final == "Utilizable"),
      .groups = "drop"
    ) %>%
    bind_cols(
      binom.confint(
        x = .$n_utilizable, n = .$n_total, methods = "wilson"
      ) %>% select(proporcion = mean, ic_inferior = lower, ic_superior = upper)
    )

  cat("--- Proporción utilizable por tratamiento (IC 95%, método Wilson) ---\n")
  print(resumen %>%
          mutate(across(c(proporcion, ic_inferior, ic_superior), ~ round(.x, 3))))
  cat("\n")

  cat("--- Tabla completa de clasificación (para el informe) ---\n")
  print(datos_final %>% tabyl(tratamiento, clasificacion_final))
  cat("\n")

  # Gráfico de proporciones con intervalo de confianza
  p_prop <- ggplot(resumen, aes(x = tratamiento, y = proporcion)) +
    geom_col(fill = "#4C72B0", width = 0.5, alpha = 0.85) +
    geom_errorbar(aes(ymin = ic_inferior, ymax = ic_superior), width = 0.15) +
    scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
    labs(
      title = "Proporción de referencias utilizables por tratamiento",
      subtitle = "A = sin fuentes (control) · B = buscador conectado · C = contexto cerrado",
      x = "Tratamiento", y = "Proporción utilizable (IC 95%, Wilson)"
    ) +
    theme_minimal(base_size = 12)

  print(p_prop)
  ggsave("proporcion_utilizable_por_tratamiento.png", p_prop, width = 7, height = 5, dpi = 150)
  cat("Gráfico guardado como 'proporcion_utilizable_por_tratamiento.png'\n")
}
