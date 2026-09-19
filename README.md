# SQL Analítico — Práctica con Datos de E-commerce

> Entrenamiento de funciones de ventana, agregaciones y análisis de negocio con SQL.

## Base de datos

- **Motor:** SQLite
- **Dominio:** E-commerce simulado (inspirado en Olist)
- **Tablas:** customers (100), products (20), orders (200), order_items (~400)

### Setup

```bash
cd sql-practice
python3 setup_db.py
sqlite3 ecommerce_practice.db
.mode column
.headers on
```

## Ejercicios completados

| # | Archivo | KPI | Concepto SQL |
|---|---------|-----|--------------|
| 1.1 | `01_1_pedidos_por_estado.sql` | Tasa de cancelación | COUNT, CASE WHEN, subquery |
| 1.2 | `01_2_ingresos_por_categoria.sql` | Revenue por categoría | JOIN, SUM, ROUND |
| 2.1 | `02_1_ranking_productos.sql` | Top productos por categoría | ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY |
| 2.2 | `02_2_top_clientes.sql` | Clientes más valiosos | Triple JOIN, ROW_NUMBER global |
| 3.1 | `03_1_crecimiento_mensual.sql` | Variación de ingresos mes a mes | LAG, STRFTIME, CTEs |
| 3.2 | `03_2_dias_entre_compras.sql` | Frecuencia de compra por cliente | LAG + JULIANDAY, RFM |
| 3.3 | `03_3_estacionalidad_abril.sql` | Validar si la caída es estacional | PARTITION BY, MoM vs YoY |

## Pendiente

- [ ] LEAD — comparar con mes siguiente
- [ ] SUM() OVER — running totals
- [ ] SUM() OVER — running totals
- [ ] CTEs + ventanas — segmentación de clientes
- [ ] Análisis de cohortes
# sql-practice
# sql-practice
