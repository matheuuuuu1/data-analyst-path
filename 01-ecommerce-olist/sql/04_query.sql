-- ¿Qué tan bien cumplimos los plazos de entrega?
/* SELECT
order_id
order_purchase_timestamp,
order_delivered_customer_date,
order_estimated_delivery_date
FROM orders LIMIT 5; */
DROP VIEW IF EXISTS vw_delivery_performance;
CREATE VIEW vw_delivery_performance AS (WITH delivery_cte AS (
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
m.title,
COUNT(*) AS amt,
ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER() * 100, 2) AS pct_title
FROM
main_cte m
GROUP BY m.title
ORDER BY amt DESC);