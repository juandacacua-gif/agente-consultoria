# Correcciones propuestas a Articulo.pdf

Base: `scripts/verificacion_articulo.R` y su salida (`documentacion/verificacion_articulo_salida.txt`), ejecutados el 2026-11-19 sobre `train_limpio_imputado.csv` (R 4.6.0, MASS 7.3.65, n = 1975).

Cada punto dice dónde está el texto, qué hay que cambiar y por qué. Los textos entre comillas son propuestas para pegar; revísalos antes de usarlos.

## A. Lo que se verificó y se puede mantener

| Parte | Resultado |
|---|---|
| Tabla 1 (faltantes) | Los porcentajes cuadran con n = 1975 |
| Tabla 4 (simetría, 10 pruebas) | χ², gl y p coinciden en las 10 con `mcnemar.test` |
| Tabla 5, L4-L5 y L5-S1 | Nagelkerke, exactitud y MAE coinciden |
| Tabla 6 | 9 de 20 OR coinciden con `exp(coef .L)`; el resto es cercano salvo L1-L2 |

## B. Correcciones que no dependen de volver a ejecutar nada

1. **Sección 3, objetivo 3.** Dice que el agente automatiza "la ejecución de modelos en R".
   Propuesta: "Diseñar e implementar un agente de IA (Streamlit + RAG tabular) que genera scripts en R y los explica; los scripts se ejecutan en un contenedor aislado sin red solo cuando el usuario los confirma, y el resultado no se devuelve al modelo."
   Motivo: el modelo de lenguaje no ejecuta R ni calcula sobre el archivo completo.

2. **Sección 4.1, imputación.** Dice "Imputación Múltiple".
   Propuesta: "Se aplicó MICE con el método polr y una sola imputación (m = 1, semilla 123)." Añadir en limitaciones: con m = 1 los análisis posteriores no reflejan la incertidumbre de los datos imputados.

3. **Sección 5.1.2, conclusión de la Tabla 4.** Dice "no existe sesgo de lateralidad: la degeneración avanza de manera simétrica".
   Propuesta: "No se detectó asimetría entre lados. La excepción nominal es el foramen L1-L2 (p = 0.0348), que no sería significativa con corrección por comparaciones múltiples (10 pruebas, Bonferroni α = 0.005)."
   Motivo: se hicieron 10 pruebas sin corrección, y los datos son transversales, así que "avanza" no es apropiado.

4. **Sección 5.3.1 y 5.3.2, uso de "progresión".** Reemplazar "progresión de la estenosis central" por "asociación con la severidad de la estenosis central". Igual con "fase de transición" (cluster 1): "perfil intermedio". Motivo: datos transversales.

5. **Sección 5.3, AIC.** Eliminar la frase de que el AIC de L4-L5 muestra "mayor carga degenerativa". El AIC mide el ajuste de cada modelo y no sirve para comparar niveles con respuestas distintas. Dejarlo solo como dato del modelo.

6. **Resumen de la sección 5.3.3, exactitud y MAE.**
   - "Exactitud entre 78.4 % y 96.5 %" → "entre 81.5 % y 96.5 %".
   - "MAE inferior a 0.31" → "MAE de 0.045 a 0.249".
   - Quitar "excelente bondad de ajuste". Propuesta: "El Nagelkerke fue de 0.26 a 0.55. En L5-S1 el modelo no mejora la predicción de la categoría más frecuente (96.46 % en ambos casos), y en L1-L2 la mejora es mínima (95.8 % contra 95.5 %). En L4-L5 sí mejora (81.5 % contra 75.1 %)."

7. **Tabla 5, columnas de línea base.** Añadir "Exactitud al predecir la moda" y "MAE al predecir la moda":

   | Nivel | Exactitud (moda) | MAE (moda) |
   |---|---|---|
   | L1-L2 | 95.54 % | 0.0552 |
   | L2-L3 | 89.62 % | 0.1311 |
   | L3-L4 | 82.13 % | 0.2410 |
   | L4-L5 | 75.09 % | 0.3782 |
   | L5-S1 | 96.46 % | 0.0451 |

8. **Tabla 6 y texto, etiquetas de significancia.** Con el modelo del artículo (factores ordenados):
   - L2-L3 LFN_R: p = 0.012 (no "< 0.001").
   - L3-L4 LFN_R: p = 0.0013 (no "< 0.001").
   - L4-L5 LFN_L: p < 0.001 (no "< 0.01").
   Las conclusiones sobre cuáles efectos foraminales son significativos se mantienen.

9. **Sección 7, conclusión 4.** "Tres perfiles clínicos claros" y "continuidad fenotípica" no se verificaron (ver sección D). Usar un lenguaje más cauto: "tres perfiles descriptivos".

10. **Sección 6, declaración de uso de IA.** Añadir: "Las Tablas 4, 5 y 6 se contrastaron con `scripts/verificacion_articulo.R`: la Tabla 4 se reproduce exactamente; las Tablas 5 y 6 se reproducen de forma aproximada (ver `documentacion/verificacion_articulo_salida.txt`)."

## C. Correcciones sobre los OR y las ecuaciones (Tabla 6 y ecuaciones 2–6)

El script del repositorio ajusta `polr` con predictores como **factores ordenados**. Por eso R da dos coeficientes por predictor (`.L` y `.Q`), y la Tabla 6 reporta solo `exp(.L)`.

1. **Cambiar el encabezado de la Tabla 6** a "OR del contraste lineal (`exp(coef .L)`)" y explicar en el texto que el término cuadrático (`.Q`) no se muestra. Casi todos los `.Q` son no significativos (p de 0.06 a 0.88).
2. **Reemplazar "Incrementar un grado en estenosis subarticular eleva entre 4.7 y 19.9 veces..."** (sección 5.3.3, resumen y conclusión 2). El `.L` no es el efecto por grado. Si el efecto es casi lineal, el OR por grado es aproximadamente `exp(0.707 × coef)`, y entre Normal/Mild y Severe es `exp(1.414 × coef)`.
   - Ejemplo L4-L5 LSS_L: OR por grado ≈ 4.8; Normal/Mild contra Severe ≈ 22.
   - Con predictores numéricos de 1 a 3 (bloque 3), los OR por grado de LSS van de 2.9 a 10.2.
   Propuesta de texto: "La estenosis subarticular fue el predictor dominante (contraste lineal, OR 4.7–21.3, p < 0.001 en todos los niveles). Por grado de severidad, el efecto es aproximadamente de 2.9 a 10.2 veces."
   Los límites 4.7 y 21.3 salen de la columna `OR_R` del bloque 3b (L5-S1 LSS_L y L1-L2 LSS_R). Si regeneras las tablas con otro CSV, recalcula estos valores.
3. **Ecuaciones logit (2)–(6).** Escriben un solo coeficiente por predictor, lo cual no describe el modelo ajustado (ocho coeficientes por nivel). Dos tampoco concuerdan con su OR: L1-L2 LFN_R (ecuación: 0.7715, con signo distinto entre el informe y el artículo; OR de la tabla: 0.695, que implica −0.364) y L3-L4 LFN_R (ecuación: 0.2064; OR: 2.130, que implica 0.756). Opciones: quitarlas, o reemplazarlas por una tabla de coeficientes con `.L` y `.Q` copiada de la salida de R.
4. **IC de L5-S1 LFN_L.** El artículo dice 0.665 y el informe de regresión dice 0.660. Con el modelo ordenado, R da 0.662.
5. **Regenerar Tablas 5 y 6 desde un solo ajuste y un solo CSV.** Las cifras del artículo difieren de las de R en L1-L2 y L2-L3 (por ejemplo, LSS_L de L1-L2: 9.145 contra 11.023; AIC de L1-L2: 534.36 contra 525.11). La diferencia crece con la proporción de datos imputados, pero no se pudo confirmar la causa. Hay que regenerar las tablas desde el CSV vigente, o documentar con qué imputación se calcularon.

## D. Lo que no se verificó

- Tabla 2 (V de Cramér), pruebas χ² de independencia y gráficos de mosaico.
- MCA (13.8 % y 4.8 % de varianza), K-medoides y la descripción de los tres clusters.
- Las citas bibliográficas (Revisión de fuentes).

## E. Informe `informe_hipotesis_y_clusters.pdf`

Cambiar el p de McNemar-Bowker L4/L5 foraminal de 0.9757 a **0.8985** (χ² = 0.5911, gl = 3). Es el valor verificado y el que ya trae el artículo.

## F. Referencias: lista del artículo contra `referencias.bib`

Se compararon las 11 entradas de la sección "Referencias" del PDF con el `.bib`. No se verificó el `.bib` contra las páginas de las revistas; se toma como referencia porque está más completo (DOI, volumen y páginas).

| Ref. del artículo | Problema | Según `referencias.bib` |
|---|---|---|
| [1] Abdelrahman et al. | Revista "Journal of Software Engineering and Applications, 5(2)" y título sin "and Clinical Assessment" | Revista *Journal of Smart Algorithms and Applications*, título completo con "and Clinical Assessment", DOI 10.66279/r8h6j935. La entrada está marcada PENDIENTE (nombres, volumen y páginas) |
| [3] Bagley et al. | "8, 16082": 16082 es parte del DOI, no la página | F1000Research 8, página 137 |
| [5] Miskin et al. | "22(8), 1750–1758" | Pain Medicine 22(7), 1485–1495 |
| [7] Trento et al. | Lleva el **título del trabajo de Zhao y Zhu** ("Advances and challenges in AI-assisted MRI...") | Trento et al. (2025), "Artificial Intelligence and Its Impact on the Management of Lumbar Degenerative Pathology: A Narrative Review", Medicina 61(8), 1400 |
| [10] Zhao et al. | Lleva el **título de Trento**, autor "Zhao, D." y datos "34(5), 1420–1432" | Zhao y Zhu (2026), "Advances and challenges in AI-assisted MRI for lumbar disc degeneration detection and classification", European Spine Journal 35(3), 1291–1300 |
| [9] y [11] | Son el mismo trabajo (Cai 2020) y están duplicados. [9] firma "Xin Yi, C." y pone 917–926; [11] está truncada ("917–[. . . ]") | Cai, X.-Y. et al. (2020), Orthopaedic Surgery 12(3), 917–930. Dejar una sola entrada |
| [8] Trînc et al. | Título truncado | Título completo: "...from Multiplanar MRI Using the RSNA 2024 (LumbarDISC) Dataset and Condition-Specific ViTs". Es un preprint sin revisión por pares: decirlo |

Además:
- El texto de la sección 2 cita "Trento et al. (2025): Advances and challenges..." y "Zhao et al. (2025): Artificial Intelligence and Its Impact...". Hay que intercambiar los títulos y corregir el año de Zhao a 2026.
- `Walsh 2026` está en el `.bib` con la nota PENDIENTE (DOI, volumen y páginas; solo se leyó el resumen). Si no se cita en el texto, no la incluyas.
- En [6], el segundo autor aparece como "Flanders, E. A." y en el `.bib` como "Flanders, Adam E.".
- Con el `.bib` y `\bibliographystyle`, la lista se genera sola y desaparecen los errores de tipeo. Lo más seguro es dejar de escribir las referencias a mano.
