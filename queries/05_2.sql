-- Ejercicio 5.2 — TOP PRODUCTO POR ESTADO
-- ¿Cuál es el producto más vendido (por cantidad) en cada estado?
-- Pista: ROW_NUMBER() OVER(PARTITION BY state ORDER BY total_cantidad DESC)
WITH cte_rank AS (SELECT
c.state as state,
p.product_name as product,
SUM(oi.quantity) as total_cantidad,
ROW_NUMBER() OVER(PARTITION BY c.state ORDER BY SUM(oi.quantity) DESC) AS ranking
FROM
order_items oi 
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY 
p.product_name, c.state
)
SELECT
state,
product,
total_cantidad,
ranking
FROM
cte_rank
WHERE ranking = 1
ORDER BY total_cantidad DESC
;