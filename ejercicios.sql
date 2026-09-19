-- ============================================================
-- SQL ANALÍTICO — EJERCICIOS PROGRESIVOS
-- Base de datos: ecommerce_practice.db
-- Cada ejercicio está ligado a un KPI de negocio real.
-- ============================================================

-- Antes de empezar, conectate a la BD:
--   sqlite3 ecommerce_practice.db
--   .mode column
--   .headers on

-- ============================================================
-- NIVEL 1: AGREGACIONES + CASE WHEN
-- KPI: Ticket promedio, tasa de cancelación por estado
-- ============================================================

-- Ejercicio 1.1
-- ¿Cuántos pedidos hay por estado? ¿Cuál es la tasa de cancelación?
-- Pista: usa COUNT + CASE WHEN para calcular el %


-- Ejercicio 1.2
-- ¿Cuál es el ingreso total por categoría de producto?
-- Pista: JOIN order_items con products, SUM(quantity * unit_price)


-- ============================================================
-- NIVEL 2: FUNCIONES DE VENTANA — ROW_NUMBER / RANK / DENSE_RANK
-- KPI: Top productos, ranking de clientes por gasto
-- ============================================================

-- Ejercicio 2.1
-- Ranking de productos por ingreso total (mayor a menor).
-- Muestra: product_name, ingreso_total, ranking
-- Pista: SUM(quantity * unit_price) OVER(ORDER BY ... DESC)


-- Ejercicio 2.2
-- Top 5 clientes que más gastaron en TOTAL.
-- Muestra: customer_id, customer_name, total_gastado, ranking
-- Pista: SUM(quantity * unit_price) OVER(PARTITION BY ... ORDER BY ...)


-- Ejercicio 2.3
-- ¿Cuál es la diferencia entre ROW_NUMBER, RANK y DENSE_RANK?
-- Ejecuta este query y observa los resultados:
--   SELECT product_id, category, price,
--          ROW_NUMBER() OVER(ORDER BY price DESC) as rn,
--          RANK()       OVER(ORDER BY price DESC) as rnk,
--          DENSE_RANK() OVER(ORDER BY price DESC) as drnk
--   FROM products;
-- ¿Cuándo usar cada uno en un contexto de negocio?


-- ============================================================
-- NIVEL 3: LAG / LEAD
-- KPI: Crecimiento mes a mes, variación entre pedidos consecutivos
-- ============================================================

-- Ejercicio 3.1
-- Ingresos mensuales y su variación porcentual respecto al mes anterior.
-- Pista:
--   1. Agrupa ingresos por mes (strftime('%Y-%m', order_date))
--   2. Usa LAG(ingresos) OVER(ORDER BY mes) para obtener el mes anterior
--   3. Calcula: (ingresos - lag) / lag * 100


-- Ejercicio 3.2
-- Para cada cliente, ¿cuántos días pasaron entre un pedido y el siguiente?
-- Pista: LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)
-- y luego JULIANDAY() para calcular la diferencia


-- ============================================================
-- NIVEL 4: SUM() OVER / AVG() OVER (_RUNNING TOTAL)
-- KPI: Acumulado de ingresos, ticket promedio acumulado
-- ============================================================

-- Ejercicio 4.1
-- Ingresos acumulados día a día (running total).
-- Pista: SUM(ingresos_diarios) OVER(ORDER BY fecha)


-- Ejercicio 4.2
-- Para cada pedido, muestra el monto del pedido Y el promedio acumulado
-- de todos los pedidos hasta ese punto.
-- Pista: AVG(monto_pedido) OVER(ORDER BY order_date)


-- ============================================================
-- NIVEL 5: CTEs + VENTANAS COMBINADAS
-- KPI: Segmentación de clientes (RFM simplificado)
-- ============================================================

-- Ejercicio 5.1 — CLIENTES FRECUENTES vs OCASIONALES
-- Usando una CTE, clasifica clientes:
--   - Frecuente: tiene 3+ pedidos
--   - Ocasional: tiene 1-2 pedidos
-- Muestra: customer_name, total_pedidos, clasificacion
-- Pista: CTE con COUNT, luego CASE WHEN en el SELECT final


-- Ejercicio 5.2 — TOP PRODUCTO POR ESTADO
-- ¿Cuál es el producto más vendido (por cantidad) en cada estado?
-- Pista: ROW_NUMBER() OVER(PARTITION BY state ORDER BY total_cantidad DESC)


-- ============================================================
-- EJERCICIO FINAL: ANÁLISIS COMPLETO
-- KPI: Dashboard de retención y rendimiento
-- ============================================================

-- Ejercicio 6.1 — ANÁLISIS DE COHORTES (simplificado)
-- Clasifica a cada cliente por el mes de su primer pedido (cohort_month).
-- Luego cuenta cuántos clientes de cada cohort hicieron pedidos
-- en meses posteriores.
-- Pista:
--   CTE 1: primer_pedido por cliente (MIN(order_date))
--   CTE 2: unir con orders para comparar meses
--   SELECT: cohort_month, months_since_first, COUNT(DISTINCT customer_id)
