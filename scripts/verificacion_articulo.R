# ==============================================================================
# VERIFICACION DE LAS CIFRAS DEL ARTICULO (Articulo.pdf, Tablas 4, 5 y 6)
# Ejecutar desde la raiz del repositorio (donde esta train_limpio_imputado.csv).
# Solo lectura: no escribe archivos ni modifica los datos.
# Bloque 3: predictores numericos 1-3 (hipotesis). Bloque 3b: factores ordenados,
# igual que scripts/analisis_hipotesis_clusters_regresion.R.
# ==============================================================================
suppressPackageStartupMessages({ library(tidyverse); library(MASS) })
select <- dplyr::select   # MASS enmascara dplyr::select

datos   <- read_csv("train_limpio_imputado.csv", show_col_types = FALSE)
niveles <- c("Normal/Mild", "Moderate", "Severe")
cat(R.version.string, "| MASS", as.character(packageVersion("MASS")),
    "| filas:", nrow(datos), "\n")

segmentos <- c("l1_l2", "l2_l3", "l3_l4", "l4_l5", "l5_s1")
col <- function(tipo, lado, s) {
  base <- c(canal = "spinal_canal_stenosis", sub = "subarticular_stenosis",
            for_ = "neural_foraminal_narrowing")[[tipo]]
  if (tipo == "canal") paste0(base, "_", s) else paste0(lado, "_", base, "_", s)
}
num <- function(x) as.numeric(factor(x, levels = niveles))   # 1, 2, 3

# ---- 1. Tabla 4: simetria (mcnemar.test = Bowker en tablas k x k) ------------
cat("\n==== 1. SIMETRIA IZQ vs DER (articulo, Tabla 4) ====\n")
art4 <- tribble(~seg, ~tipo, ~chi, ~p,
  "l1_l2","sub",2.6939,0.4413, "l2_l3","sub",2.4588,0.4828, "l3_l4","sub",0.0633,0.9958,
  "l4_l5","sub",0.2376,0.9713, "l5_s1","sub",3.3909,0.3352, "l1_l2","for_",8.6178,0.0348,
  "l2_l3","for_",3.0610,0.3823, "l3_l4","for_",0.1953,0.9783, "l4_l5","for_",0.5911,0.8985,
  "l5_s1","for_",2.7290,0.4353)
res1 <- pmap_dfr(art4, function(seg, tipo, chi, p) {
  t <- table(factor(datos[[col(tipo, "left",  seg)]], levels = niveles),
             factor(datos[[col(tipo, "right", seg)]], levels = niveles))
  r <- mcnemar.test(t)
  tibble(seg, tipo, chi_art = chi, chi_R = round(unname(r$statistic), 4),
         p_art = p, p_R = round(r$p.value, 4),
         coincide = abs(chi - r$statistic) < 5e-4 & abs(p - r$p.value) < 5e-4)
})
print(as.data.frame(res1))

# ---- 2/3. Modelos POLR por nivel: Tablas 5 y 6 --------------------------------
art5 <- tribble(~seg, ~AIC, ~nag, ~acc, ~mae,
  "l1_l2",534.36,0.419,95.75,0.0481, "l2_l3",931.16,0.510,91.75,0.0916,
  "l3_l4",1436.47,0.528,85.82,0.1559, "l4_l5",1844.73,0.545,81.52,0.2491,
  "l5_s1",552.14,0.257,96.46,0.0451)
art6 <- tribble(~seg, ~var, ~OR, ~lo, ~hi,
  "l1_l2","LSS_L",9.145,4.716,17.296, "l1_l2","LSS_R",19.910,9.407,42.674,
  "l1_l2","LFN_L",1.707,0.145,15.358, "l1_l2","LFN_R",0.695,0.267,1.713,
  "l2_l3","LSS_L",10.210,6.743,15.557, "l2_l3","LSS_R",11.553,7.557,17.781,
  "l2_l3","LFN_L",1.904,0.778,4.855,  "l2_l3","LFN_R",4.748,1.481,17.218,
  "l3_l4","LSS_L",8.043,5.820,11.191, "l3_l4","LSS_R",7.922,5.694,11.093,
  "l3_l4","LFN_L",1.128,0.653,1.934,  "l3_l4","LFN_R",2.130,1.290,3.538,
  "l4_l5","LSS_L",9.154,6.672,12.865, "l4_l5","LSS_R",7.342,5.392,10.203,
  "l4_l5","LFN_L",2.032,1.504,2.746,  "l4_l5","LFN_R",1.345,0.985,1.834,
  "l5_s1","LSS_L",4.713,2.897,7.798,  "l5_s1","LSS_R",5.091,3.149,8.404,
  "l5_s1","LFN_L",1.150,0.660,1.950,  "l5_s1","LFN_R",1.146,0.653,1.970)

ajustar <- function(s) {
  d <- tibble(
    y = factor(datos[[col("canal", NA, s)]], levels = niveles, ordered = TRUE),
    LSS_L = num(datos[[col("sub",  "left",  s)]]), LSS_R = num(datos[[col("sub",  "right", s)]]),
    LFN_L = num(datos[[col("for_", "left",  s)]]), LFN_R = num(datos[[col("for_", "right", s)]])
  ) %>% drop_na()
  m  <- MASS::polr(y ~ LSS_L + LSS_R + LFN_L + LFN_R, data = d, Hess = TRUE)
  m0 <- MASS::polr(y ~ 1, data = d, Hess = TRUE)
  ll1 <- as.numeric(logLik(m)); ll0 <- as.numeric(logLik(m0)); n <- nrow(d)
  cs  <- 1 - exp((2 / n) * (ll0 - ll1))
  obs <- as.numeric(d$y); pred <- as.numeric(predict(m, type = "class"))
  ci  <- suppressMessages(confint(m))               # IC por verosimilitud perfilada
  tt  <- coef(summary(m))[names(coef(m)), , drop = FALSE]
  list(m = m, n = n,
       met = tibble(seg = s, n = n, AIC = AIC(m), nag = cs / (1 - exp((2 / n) * ll0)),
                    acc = 100 * mean(pred == obs), mae = mean(abs(obs - pred)),
                    mae_moda = mean(abs(obs - as.numeric(names(which.max(table(obs)))))),
                    acc_moda = 100 * max(prop.table(table(obs)))),
       or = tibble(seg = s, var = names(coef(m)), OR = exp(coef(m)),
                   lo = exp(ci[, 1]), hi = exp(ci[, 2]),
                   p_wald = 2 * pnorm(-abs(tt[, "Value"] / tt[, "Std. Error"])),
                   coef = coef(m)))
}
aj <- map(setNames(segmentos, segmentos), ajustar)

cat("\n==== 2. TABLA 5: AIC, Nagelkerke, exactitud, MAE ====\n")
t5 <- map_dfr(aj, ~ .x$met) %>% inner_join(art5, by = "seg", suffix = c("_R", "_art"))
print(as.data.frame(t5 %>% transmute(seg, n,
  AIC_art = AIC_art, AIC_R = round(AIC_R, 2), nag_art = nag_art, nag_R = round(nag_R, 3),
  acc_art = acc_art, acc_R = round(acc_R, 2), mae_art = mae_art, mae_R = round(mae_R, 4),
  mae_moda = round(mae_moda, 4), acc_moda = round(acc_moda, 2))), row.names = FALSE)
cat("(mae_moda / acc_moda = linea base de predecir siempre la categoria mas frecuente)\n")

cat("\n==== 3. TABLA 6: OR, IC 95% y p (predictores numericos 1-3) ====\n")
t6 <- map_dfr(aj, ~ .x$or) %>% inner_join(art6, by = c("seg", "var"), suffix = c("_R", "_art"))
print(as.data.frame(t6 %>% transmute(seg, var,
  OR_art, OR_R = round(OR_R, 3), lo_art, lo_R = round(lo_R, 3), hi_art, hi_R = round(hi_R, 3),
  p_wald = signif(p_wald, 3), coef_R = round(coef, 4),
  coincide_OR = abs(OR_art - OR_R) / OR_art < 0.005)), row.names = FALSE)


# ---- 3b. Mismo modelo que scripts/analisis_hipotesis_clusters_regresion.R -----
# Predictores como factores ORDENADOS: polr da dos coeficientes por variable
# (.L = tendencia lineal, .Q = curvatura). Se compara el articulo con cada uno.
cat("\n==== 3b. MODELO CON FACTORES ORDENADOS (como el script del repositorio) ====\n")
ajustar_ord <- function(s) {
  of <- function(x) factor(x, levels = niveles, ordered = TRUE)
  d <- tibble(y = of(datos[[col("canal", NA, s)]]),
              LSS_L = of(datos[[col("sub",  "left",  s)]]), LSS_R = of(datos[[col("sub",  "right", s)]]),
              LFN_L = of(datos[[col("for_", "left",  s)]]), LFN_R = of(datos[[col("for_", "right", s)]])) %>% drop_na()
  m  <- MASS::polr(y ~ LSS_L + LSS_R + LFN_L + LFN_R, data = d, Hess = TRUE)
  m0 <- MASS::polr(y ~ 1, data = d, Hess = TRUE)
  ll1 <- as.numeric(logLik(m)); ll0 <- as.numeric(logLik(m0)); n <- nrow(d)
  cs <- 1 - exp((2 / n) * (ll0 - ll1))
  obs <- as.numeric(d$y); pred <- as.numeric(predict(m, type = "class"))
  ci <- suppressMessages(confint(m))
  tt <- coef(summary(m))[names(coef(m)), , drop = FALSE]
  list(met = tibble(seg = s, n_coef = length(coef(m)), AIC_ord = AIC(m),
                    nag_ord = cs / (1 - exp((2 / n) * ll0)),
                    acc_ord = 100 * mean(pred == obs), mae_ord = mean(abs(obs - pred))),
       or = tibble(seg = s, term = names(coef(m)), coef = coef(m), OR = exp(coef(m)),
                   lo = exp(ci[, 1]), hi = exp(ci[, 2]),
                   p_wald = 2 * pnorm(-abs(tt[, "Value"] / tt[, "Std. Error"]))) %>%
         mutate(var = sub("\\..*$", "", term), contr = sub("^.*\\.", "", term)))
}
ao <- map(setNames(segmentos, segmentos), ajustar_ord)

cat("\n-- Ajuste global (ordenados) contra Tabla 5 --\n")
t5o <- map_dfr(ao, ~ .x$met) %>% inner_join(art5, by = "seg")
print(as.data.frame(t5o %>% transmute(seg, n_coef, AIC_art = AIC, AIC_ord = round(AIC_ord, 2),
  nag_art = nag, nag_ord = round(nag_ord, 3), acc_art = acc, acc_ord = round(acc_ord, 2),
  mae_art = mae, mae_ord = round(mae_ord, 4))), row.names = FALSE)

cat("\n-- Coeficientes .L y .Q (todos los que da R) contra el OR del articulo --\n")
t6o <- map_dfr(ao, ~ .x$or) %>% left_join(art6 %>% rename(OR_art = OR, lo_art = lo, hi_art = hi),
                                           by = c("seg", "var"))
print(as.data.frame(t6o %>% transmute(seg, var, contr, coef = round(coef, 4), OR_R = round(OR, 3),
  lo_R = round(lo, 3), hi_R = round(hi, 3), p_wald = signif(p_wald, 3),
  OR_art = ifelse(contr == "L", OR_art, NA),
  coincide_L = ifelse(contr == "L", abs(OR - OR_art) / OR_art < 0.005, NA))), row.names = FALSE)
cat("\nOR del articulo que coinciden con el coeficiente .L:",
    sum(t6o$contr == "L" & abs(t6o$OR - t6o$OR_art) / t6o$OR_art < 0.005, na.rm = TRUE), "de 20\n")

cat("\n==== 4. RESUMEN ====\n")
cat("Simetria (Tabla 4) que coincide: ", sum(res1$coincide), "de", nrow(res1), "\n")
cat("OR (Tabla 6) que coinciden (<0.5%):",
    sum(abs(t6$OR_art - t6$OR_R) / t6$OR_art < 0.005), "de", nrow(t6), "\n")
cat("Exactitud entre", round(min(t5$acc_R), 2), "y", round(max(t5$acc_R), 2),
    "| MAE maximo", round(max(t5$mae_R), 4), "| Nagelkerke maximo", round(max(t5$nag_R), 3), "\n")
cat("Los OR del bloque 3 (numericos 1-3) eran una hipotesis; el bloque 3b reproduce el script del repositorio.\n")
