-- Ejercicio 2.2: Top 5 clientes que más gastaron
-- KPI: clientes más valiosos
SELECT
    c.customer_name,
    c.customer_id,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) as total_gastado,
    ROW_NUMBER() OVER(ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as ranking
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name, c.customer_id
ORDER BY total_gastado DESC
LIMIT 5;
