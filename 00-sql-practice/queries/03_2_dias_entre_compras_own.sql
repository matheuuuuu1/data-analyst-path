WITH lagd AS (
SELECT
	customer_id, order_date,
	LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) as last_date
FROM
	orders
WHERE status != 'cancelled'
)
SELECT 
	customer_id, order_date, last_date,
	ROUND(JULIANDAY(order_date) - JULIANDAY(last_date)) AS diff
FROM 
	lagd
WHERE
	last_date IS NOT NULL;

/* Así como está aquí arriba, está bien para ver cada una de las compras de cada cliente, pero si queremos ver
 como sería con solo el promedio, sería algo así */