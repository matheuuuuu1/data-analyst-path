-- Análisis: ¿La caída de abril 2024 es un patrón estacional?
-- Método: MoM (marzo→abril) comparado entre años 2023-2025
-- KPI: validación de estacionalidad antes de sacar conclusiones

WITH ingresos_mensuales AS (
    SELECT
        STRFTIME('%Y', o.order_date) as anio,
        STRFTIME('%m', o.order_date) as mes,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) as ingresos
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'cancelled'
    GROUP BY anio, mes
)
SELECT
    anio,
    mes,
    ingresos,
    LAG(ingresos) OVER(PARTITION BY anio ORDER BY mes) as mes_anterior,
    ROUND((ingresos - LAG(ingresos) OVER(PARTITION BY anio ORDER BY mes)) * 100.0
          / LAG(ingresos) OVER(PARTITION BY anio ORDER BY mes), 1) as variacion_mom
FROM ingresos_mensuales
WHERE mes IN ('03', '04')
ORDER BY anio, mes;

-- RESULTADO:
--   2023: marzo→abril  +101.6% → abril CRECIÓ
--   2024: marzo→abril  -49.9%  → abril CAYÓ a la mitad
--   2025: marzo→abril  -6.6%   → abril casi no cambió
--
-- CONCLUSIÓN: la caída de abril 2024 NO es estacional.
-- Si lo fuera, se repetiría todos los años. Fue un evento puntual.

-- COMPLEMENTO (YoY): misma técnica pero PARTITION BY mes, ORDER BY anio
-- para comparar el mismo mes entre años distintos.
WITH ingresos_anuales AS (
    SELECT
        STRFTIME('%Y', o.order_date) as anio,
        STRFTIME('%m', o.order_date) as mes,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) as ingresos
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'cancelled'
    GROUP BY anio, mes
)
SELECT
    anio,
    mes,
    ingresos,
    LAG(ingresos) OVER(PARTITION BY mes ORDER BY anio) as mismo_mes_anio_anterior,
    ROUND((ingresos - LAG(ingresos) OVER(PARTITION BY mes ORDER BY anio)) * 100.0
          / LAG(ingresos) OVER(PARTITION BY mes ORDER BY anio), 1) as variacion_yoy
FROM ingresos_anuales
ORDER BY mes, anio;

-- CUÁNDO USAR CADA UNA:
-- PARTITION BY anio + ORDER BY mes → MoM (mes vs mes anterior del mismo año)
-- PARTITION BY mes + ORDER BY anio → YoY (mismo mes entre años)