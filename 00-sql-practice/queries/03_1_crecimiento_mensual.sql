-- Ejercicio 3.1: Crecimiento de ingresos mes a mes (LAG)
-- KPI: variación porcentual de ingresos vs mes anterior
WITH ingresos_mensuales AS (
    SELECT
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS ingresos,
        STRFTIME('%Y-%m', o.order_date) AS mes
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY mes
),
con_anterior AS (
    SELECT
        mes,
        ingresos,
        LAG(ingresos) OVER(ORDER BY mes) as mes_anterior
    FROM ingresos_mensuales
)
SELECT
    mes,
    ingresos,
    mes_anterior,
    ROUND(((ingresos - mes_anterior) / mes_anterior) * 100.0, 1) as variacion_pct
FROM con_anterior;