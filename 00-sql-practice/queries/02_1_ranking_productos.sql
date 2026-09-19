-- Ejercicio 2.1: Ranking de productos por ingreso
-- KPI: top productos con ROW_NUMBER
SELECT
    p.category,
    p.product_name,
    SUM(o.quantity * o.unit_price) as ingreso_total,
    ROW_NUMBER() OVER(PARTITION BY p.category ORDER BY SUM(o.quantity * o.unit_price) DESC) as rn,
    RANK()       OVER(PARTITION BY p.category ORDER BY SUM(o.quantity * o.unit_price) DESC) as rnk,
    DENSE_RANK() OVER(PARTITION BY p.category ORDER BY SUM(o.quantity * o.unit_price) DESC) as drnk
FROM order_items o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, ingreso_total DESC;
