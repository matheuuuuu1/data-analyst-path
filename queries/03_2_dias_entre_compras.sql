-- Ejercicio 3.2: Días entre compras por cliente (LAG + JULIANDAY)
-- KPI: frecuencia de compra (input para análisis RFM)
--
-- VERSIÓN CON ERROR (documentada para aprendizajes):
-- SELECT customer_id, order_date, last_date, COUNT(*), AVG(...)
-- GROUP BY customer_id
-- ⚠️ ERROR: order_date y last_date NO están en el GROUP BY ni en una función.
-- SQLite las rellena con valores arbitrarios del grupo.
-- Ejemplo: el cliente 1 aparecía con order_date 2023-10-08 cuando su
-- último pedido real es 2025-11-06. Dato falsamente atribuido.

WITH lagd AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) as last_date
    FROM orders
    WHERE status != 'cancelled'
)
SELECT
    customer_id,
    COUNT(*) as total_pedidos,
    MAX(order_date) as ultimo_pedido,
    CAST(ROUND(AVG(JULIANDAY(order_date) - JULIANDAY(last_date))) AS INTEGER) as dias_promedio_entre_compras
FROM lagd
WHERE last_date IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY dias_promedio_entre_compras;

-- LECCIÓN: toda columna que no esté en GROUP BY debe ir dentro de una
-- función (COUNT, MAX, AVG...). Si no, el resultado es indefinido.

-- INTERPRETACIÓN DE NEGOCIO:
-- - Cliente 28: 12 pedidos, compra cada ~78 días → cliente leal
-- - Cliente 25/71: ~300 días entre compras → en riesgo de churn
-- Este cálculo es la "Frecuencia" del marco RFM.