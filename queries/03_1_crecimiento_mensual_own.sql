/* WITH precios AS (
SELECT
	product_name, price,
	LAG(price) OVER(ORDER BY price DESC) as precio_anterior
FROM
	products)
SELECT 
	product_name, price, precio_anterior,
	ROUND(((price - precio_anterior) / precio_anterior) * 100) AS porcentaje
FROM 
	precios; 
	Este estaba bien, creo... Pero solo me dejaba el porcentaje
	**/

/* WITH precios AS (
SELECT 
	SUM(oi.quantity * oi.unit_price) AS ingresos,
	STRFTIME('%Y-%m', o.order_date) AS mes
FROM
	orders o
JOIN
	order_items oi ON o.order_id = oi.order_id
GROUP BY
	mes
)
SELECT
ingresos,
LAG(ingresos) OVER(ORDER BY mes) as ingresos_anteriores,
mes,
ROUND(((ingresos - LAG(ingresos) OVER(ORDER BY mes)) / LAG(ingresos) OVER(ORDER BY mes)) * 100.0) as pct
FROM precios; 
Este está bien, pero puedo mejorarlo con un segundo CTE para mejorar legibilidad
*/

WITH firstv AS (
SELECT 
	SUM(oi.quantity * oi.unit_price) AS ingresos,
	STRFTIME('%Y-%m', o.order_date) AS mes
FROM
	orders o
JOIN
	order_items oi ON o.order_id = oi.order_id
GROUP BY
	mes
),
precios AS
(
SELECT 
	ingresos,
	mes,
	LAG(ingresos) OVER(ORDER BY mes) AS mes_anterior
FROM
	firstv
)
SELECT 
	mes,
	ingresos,
	mes_anterior,
	ROUND(((ingresos - mes_anterior) / mes_anterior) * 100.0) AS pct
FROM
	precios;