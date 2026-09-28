-- ¿Cuál es el ticket promedio por región?
DROP VIEW IF EXISTS vw_ticket_region;
CREATE VIEW vw_ticket_region AS (
WITH cte_ticket AS (
SELECT
COUNT(o.order_id) AS total_orders,
c.customer_state AS state,
ROUND(SUM(payment_value)) AS total_earnings
FROM
orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_state
)
SELECT
state,
total_orders,
total_earnings,
ROUND(total_earnings / total_orders) AS ticket
FROM
cte_ticket
ORDER BY ticket DESC);
