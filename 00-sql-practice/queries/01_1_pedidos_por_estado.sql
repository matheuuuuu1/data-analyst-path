-- Ejercicio 1.1: Pedidos por estado y tasa de cancelación
-- KPI: distribución de estados, tasa de cancelación
SELECT
    status,
    COUNT(*) as total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 1) as pct
FROM orders
GROUP BY status;
