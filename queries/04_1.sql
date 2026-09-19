-- Ejercicio 4.1
-- Ingresos acumulados día a día (running total).
-- Pista: SUM(ingresos_diarios) OVER(ORDER BY fecha)
SELECT
o.order_id,
o.order_date,
SUM(oi.quantity * oi.unit_price) AS ingresos,
SUM(SUM(oi.quantity * oi.unit_price)) OVER(ORDER BY o.order_date) AS acumulado
FROM
orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY o.order_date;