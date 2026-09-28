-- ¿Qué tan bien cumplimos los plazos de entrega?
/* SELECT
order_id
order_purchase_timestamp,
order_delivered_customer_date,
order_estimated_delivery_date
FROM orders LIMIT 5; */

WITH delivery_cte AS (
SELECT
order_id AS id,
order_delivered_customer_date AS delivered,
order_estimated_delivery_date AS estimated,
(order_delivered_customer_date::date - order_estimated_delivery_date::date) AS cnt
FROM
orders
WHERE
order_delivered_customer_date IS NOT NULL
), main_cte AS (
SELECT
id,
delivered,
estimated,
cnt,
CASE
    WHEN cnt > 0 THEN 'late'
    WHEN cnt = 0 THEN 'on_time'
    ELSE 'early'
    END AS title
FROM
delivery_cte)
SELECT
ROUND(AVG(cnt)) AS average_days_late,
COUNT(*) FILTER (WHERE title = 'late') AS count_late,
COUNT(DISTINCT id) AS total_counts, -- (6535 / 96476) * 100
ROUND(COUNT(*) FILTER (WHERE title = 'late')::numeric / COUNT(DISTINCT id) * 100.0, 2) AS late_pct
FROM
main_cte;