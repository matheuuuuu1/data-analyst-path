-- "¿Cómo evolucionan los pedidos e ingresos a lo largo del tiempo?"
DROP VIEW IF EXISTS vw_orders_earnings;
CREATE VIEW vw_orders_earnings AS (
WITH cte_main AS(
SELECT
TO_CHAR(o.order_purchase_timestamp::timestamp, 'YYYY-MM-DD') AS date,
ROUND(SUM(op.payment_value)) AS ingresos,
COUNT(DISTINCT o.order_id) AS cnt
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY date
)
SELECT
date,
ingresos,
cnt,
SUM(ingresos) OVER(ORDER BY date) AS ingresos_acumulados,
SUM(cnt) OVER(ORDER BY date) AS conteo_acumulado
FROM
cte_main);
-- Alternar por mes en vez de dia
DROP VIEW IF EXISTS vw_orders_earnings_month;
CREATE VIEW vw_orders_earnings_month AS (
WITH cte_main AS(
SELECT
TO_CHAR(o.order_purchase_timestamp::timestamp, 'YYYY-MM') AS date,
ROUND(SUM(op.payment_value)) AS ingresos,
COUNT(DISTINCT o.order_id) AS cnt
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY date
)
SELECT
date,
ingresos,
cnt,
SUM(ingresos) OVER(ORDER BY date) AS ingresos_acumulados,
SUM(cnt) OVER(ORDER BY date) AS conteo_acumulado
FROM
cte_main);