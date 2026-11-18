# Paquetes de R usados por los scripts que ha entregado el agente y por los
# scripts del repositorio. Se instalan al construir la imagen.
paquetes <- c(
  "tidyverse", "readxl", "janitor", "naniar", "mice", "rstatix", "ggcorrplot",
  "vcd", "ordinal", "rcompanion", "DescTools", "performance", "factoextra",
  "FactoMineR", "cluster", "nortest", "e1071", "car", "broom", "pacman"
)

options(Ncpus = max(1L, parallel::detectCores() - 1L))
install.packages(paquetes)

faltan <- paquetes[!(paquetes %in% rownames(installed.packages()))]
if (length(faltan) > 0) {
  stop("No se instalaron: ", paste(faltan, collapse = ", "))
}

# Registro de versiones, para reproducibilidad
inst <- installed.packages()[, c("Package", "Version")]
write.csv(inst, "/opt/runner/paquetes_instalados.csv", row.names = FALSE)
cat("Repositorio de CRAN usado:", getOption("repos"), "\n")
cat("Paquetes instalados:", nrow(inst), "\n")
