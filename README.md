# Data Analyst Portfolio

> Tomo una pregunta de negocio, la traduzco a un análisis reproducible con código (SQL + Python), y la entrego como un dashboard interactivo en el que tomas decisiones.

## Proyectos

| # | Proyecto | Estado | Stack |
|---|----------|--------|-------|
| 00 | SQL Práctica | ✅ Completado | SQLite, CTEs, Window Functions |
| 01 | E-commerce Olist | ✅ Completado | SQL, Python/Pandas, Apache Superset |

---

## 00 — SQL Práctica

> Entrenamiento de funciones de ventana, agregaciones y análisis de negocio con SQL.

**Motor:** SQLite | **Dominio:** E-commerce simulado (inspirado en Olist)

| # | Ejercicio | KPI | Concepto SQL |
|---|-----------|-----|--------------|
| 1.1 | `01_1_pedidos_por_estado.sql` | Tasa de cancelación | COUNT, CASE WHEN, subquery |
| 1.2 | `01_2_ingresos_por_categoria.sql` | Revenue por categoría | JOIN, SUM, ROUND |
| 2.1 | `02_1_ranking_productos.sql` | Top productos por categoría | ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY |
| 2.2 | `02_2_top_clientes.sql` | Clientes más valiosos | Triple JOIN, ROW_NUMBER global |
| 3.1 | `03_1_crecimiento_mensual.sql` | Variación de ingresos mes a mes | LAG, STRFTIME, CTEs |
| 3.2 | `03_2_dias_entre_compras.sql` | Frecuencia de compra por cliente | LAG + JULIANDAY, RFM |
| 3.3 | `03_3_estacionalidad_abril.sql` | Validar si la caída es estacional | PARTITION BY, MoM vs YoY |
| 4.1 | `04_1.sql` | Running total de ingresos | SUM() OVER (ORDER BY) |
| 4.2 | `04_2.sql` | Ticket promedio acumulado | AVG() OVER (ORDER BY) |
| 5.1 | `05_1.sql` | Segmentación frecuentes vs ocasionales | CTE + CASE WHEN |
| 5.2 | `05_2.sql` | Top producto por estado | ROW_NUMBER + PARTITION BY, 4 JOINs |
| 6.1 | `6.sql` | Análisis de cohortes (retención) | CTEs encadenadas, LAG, SUBSTR, COUNT DISTINCT |
