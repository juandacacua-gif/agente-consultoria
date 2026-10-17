# Visto bueno — Semana 1
**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia · Universidad Santo Tomás

> **Revisión del 17 de octubre de 2026:** se corrigieron la lectura del kappa, las rutas de los archivos (ahora en `documentacion/`), la lista del corpus (faltaba Zhao et al.) y el estado del banco de preguntas. El resto es el visto bueno de la semana 1.

## 1. Conteo del experimento

Se diseñó un experimento de tres tratamientos sobre 2 consultas bibliográficas reales
del área del proyecto (acuerdo interobservador en estenosis lumbar, y modelos de deep
learning sobre el dataset RSNA 2024): **A** = chat sin fuentes, **B** = buscador con
bases reales, **C** = contexto cerrado (NotebookLM con nuestro corpus). Se clasificaron
30 referencias en total (5 por tratamiento y consulta), cada una por los dos integrantes
de forma independiente.

- **Acuerdo bruto entre clasificadores:** 93.3% (28/30). Kappa de Cohen global = -0.0345
  (p=0.85). Tabla cruzada: 28 casos en que ambos marcaron utilizable, 1 en que solo Camilo
  marcó no utilizable, 1 en que solo Juan marcó no utilizable y 0 en que ambos marcaron no
  utilizable. Los dos integrantes **nunca coincidieron en un caso no utilizable**: cada uno
  marcó un caso distinto. Con una categoría casi vacía el kappa dice muy poco, y su valor
  cercano a cero no debe leerse como acuerdo sobre los casos problemáticos ni como un
  artefacto sin importancia.
- **Proporción utilizable por tratamiento** (IC 95%, Wilson): A = 100% (10/10),
  B = 100% (10/10), C = 90% (9/10, IC 59.6%–98.2%).
- El único caso "no utilizable" de la clasificación final reveló un fallo real y
  documentado: NotebookLM citó valores de un artículo (Miskin et al., 2021) que **no
  estaba en el corpus** en el momento de la consulta. Camilo lo clasificó como no
  utilizable; Juan lo había clasificado como utilizable. La fecha de carga del PDF
  (un día después de la consulta) la confirmó Juan.

## 2. Herramienta elegida y comparación

Se comparó **NotebookLM** contra **Proyecto con archivos** (Claude/ChatGPT Projects)
en 6 criterios: contexto cerrado, cita con localización, privacidad, costo, exportación
APA 7, reproducibilidad. NotebookLM gana en 3 (contexto cerrado, cita con localización,
costo), empata en 2, pierde en 1 (reproducibilidad del protocolo, compensada
documentando por escrito el protocolo de prompts). Se eligió **NotebookLM**,
principalmente por su capacidad de citar con localización exacta dentro del documento
— verificada en la práctica durante el experimento.

## 3. Corpus

10 documentos verificados con procedencia documentada (`documentacion/PROCEDENCIA.md`):
Richards et al. (LumbarDISC), Cai/Xin Yi et al. (biomecánica L4-L5), Trento et al.,
Beyond Accuracy (preprint), Al-Tameemi et al., Bagley et al., Miskin et al., Abdelrahman
et al., Chai et al. y Zhao et al. Todos de acceso abierto salvo dos referencias descartadas o
pendientes de resolución (Furman/Medscape, fuente terciaria; Walsh et al., con acceso
institucional). Durante la auditoría del corpus se identificaron y corrigieron 4 fallos
de citación en la bibliografía original del anteproyecto (documentados en
`documentacion/INVENTARIO_DE_FALLOS_consolidado.md`).

## 4. Origen del banco de preguntas

18 preguntas (`documentacion/banco_preguntas.md`): 14 con respuesta en el corpus y 4 sin
respuesta en el corpus para probar abstención, dos de ellas diseñadas como "preguntas
trampa" que podrían inducir al sistema a mezclar datos reales de fuentes distintas.
Las 18 se aplicaron a NotebookLM: resultado 17 de 18 (la pregunta 17 fue la única no
utilizable). Respuestas literales en `entregables/respuestas_notebooklm_2026-10-17.pdf`
y detalle en `documentacion/RESULTADOS_banco_preguntas.md`.

---
*Repositorio: `github.com/juandacacua-gif/agente-consultoria`. Los PDF del corpus están en
`fuentes/`; la documentación, en `documentacion/`; los entregables, en `entregables/`; y el
experimento, en `experimento/`.*
