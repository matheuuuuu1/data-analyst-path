-- Ejercicio 5.1 — CLIENTES FRECUENTES vs OCASIONALES
-- Usando una CTE, clasifica clientes:
--   - Frecuente: tiene 3+ pedidos
--   - Ocasional: tiene 1-2 pedidos
-- Muestra: customer_name, total_pedidos, clasificacion
-- Pista: CTE con COUNT, luego CASE WHEN en el SELECT final

WITH cte_count AS (
SELECT
c.customer_name AS nombre,
COUNT(o.order_id) as total_pedidos
FROM 
customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
)
SELECT
nombre,
total_pedidos,
CASE WHEN total_pedidos >= 3 THEN 'Frecuente' ELSE 'Ocasional' END AS clasificacion
FROM
cte_count;