-- Ejercicio 1.2: Ingreso total por categoría de producto
-- KPI: qué categorías generan más ingresos
SELECT
    p.category,
    SUM(o.quantity * o.unit_price) as ingreso_total,
    ROUND(SUM(o.quantity * o.unit_price) * 100.0 / (SELECT SUM(quantity * unit_price) FROM order_items), 1) as pct
FROM order_items o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY ingreso_total DESC;
