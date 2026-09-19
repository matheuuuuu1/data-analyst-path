-- Ejercicio 4.2
-- Para cada pedido, muestra el monto del pedido Y el promedio acumulado
-- de todos los pedidos hasta ese punto.
-- Pista: AVG(monto_pedido) OVER(ORDER BY order_date)

SELECT
o.order_id,
o.order_date,
SUM(oi.quantity * oi.unit_price) AS monto_pedido,
AVG(SUM(oi.quantity * oi.unit_price)) OVER(ORDER BY order_date) AS monto_pedido_avg
FROM
orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date;