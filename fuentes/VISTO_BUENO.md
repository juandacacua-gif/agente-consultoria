# Visto bueno — Semana 1
**Actividad "Nada sin fuente"** · Juan David Cacua y Camilo Velandia · Universidad Santo Tomás

## 1. Conteo del experimento

Se diseñó un experimento de tres tratamientos sobre 2 consultas bibliográficas reales
del área del proyecto (acuerdo interobservador en estenosis lumbar, y modelos de deep
learning sobre el dataset RSNA 2024): **A** = chat sin fuentes, **B** = buscador con
bases reales, **C** = contexto cerrado (NotebookLM con nuestro corpus). Se clasificaron
30 referencias en total (5 por tratamiento y consulta), cada una por los dos integrantes
de forma independiente.

- **Acuerdo bruto entre clasificadores:** 93.3% (28/30). Kappa de Cohen global = -0.0345
  (p=0.85); el valor negativo pese al alto acuerdo es un artefacto estadístico esperado
  cuando la distribución de categorías está muy desbalanceada (casi todo cae en
  "Utilizable") — no indica desacuerdo real.
- **Proporción utilizable por tratamiento** (IC 95%, Wilson): A = 100% (10/10),
  B = 100% (10/10), C = 90% (9/10, IC 59.6%–98.2%).
- El único caso "no utilizable" reveló un fallo real y documentado: NotebookLM citó
  valores de un artículo (Miskin et al., 2021) que **no estaba en el corpus** en el
  momento de la consulta — confirmado con fecha exacta por los dos integrantes.

## 2. Herramienta elegida y comparación

Se comparó **NotebookLM** contra **Proyecto con archivos** (Claude/ChatGPT Projects)
en 6 criterios: contexto cerrado, cita con localización, privacidad, costo, exportación
APA 7, reproducibilidad. NotebookLM gana en 3 (contexto cerrado, cita con localización,
costo), empata en 2, pierde en 1 (reproducibilidad del protocolo, compensada
documentando por escrito el protocolo de prompts). Se eligió **NotebookLM**,
principalmente por su capacidad de citar con localización exacta dentro del documento
— verificada en la práctica durante el experimento.

## 3. Corpus

9 documentos verificados con procedencia documentada (`fuentes/PROCEDENCIA.md`):
Richards et al. (LumbarDISC), Cai/Xin Yi et al. (biomecánica L4-L5), Trento et al.,
Beyond Accuracy (preprint), Al-Tameemi et al., Bagley et al., Miskin et al., Abdelrahman
et al., y Chai et al. Todos de acceso abierto salvo dos referencias descartadas o
pendientes de resolución (Furman/Medscape, fuente terciaria; Walsh et al., con acceso
institucional). Durante la auditoría del corpus se identificaron y corrigieron 4 fallos
de citación en la bibliografía original del anteproyecto (documentados en
`fuentes/INVENTARIO_DE_FALLOS_consolidado.md`).

## 4. Origen del banco de preguntas

18 preguntas (`fuentes/banco_preguntas.md`): 14 con respuesta verificada y localizada
(documento + página/sección) durante la auditoría del corpus que ya hicimos, y 4 sin
respuesta en el corpus para probar abstención — una ya probada con éxito (el sistema
se abstuvo correctamente), dos diseñadas como "preguntas trampa" que podrían inducir
al sistema a mezclar datos reales de fuentes distintas de forma incorrecta.

---
*Evidencia completa y reproducible en la carpeta `fuentes/` del repositorio:
`github.com/juandacacua-gif/agente-consultoria`.*
