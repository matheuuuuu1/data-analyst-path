-- "¿Cómo evolucionan los pedidos e ingresos a lo largo del tiempo?"
-- Earnings
WITH cte_date_earnings AS (
SELECT
TO_CHAR(o.order_purchase_timestamp::timestamp, 'YYYY-MM-DD') AS date,
ROUND(SUM(op.payment_value)) AS ingresos
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY date
)
SELECT
date,
ingresos,
SUM(ingresos) OVER(ORDER BY date) AS acumulado
FROM
cte_date_earnings;
-- Orders
WITH cte_orders AS(
SELECT
TO_CHAR(order_purchase_timestamp::timestamp, 'YYYY-MM-DD') AS date,
COUNT(DISTINCT order_id) as cnt
FROM
orders
GROUP BY date
)
SELECT
date,
cnt,
SUM(cnt) OVER(ORDER BY date) AS acumulado_date
FROM
cte_orders
;
-- Combinar en un query
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
cte_main;
-- Alternar por mes en vez de dia
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
cte_main;