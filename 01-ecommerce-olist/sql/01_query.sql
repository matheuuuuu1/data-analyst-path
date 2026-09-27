-- "¿Cuáles son las categorías y productos que más ingresos generan?"
SELECT 
oi.order_id,
p.product_id,
p.product_category_name
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;


-- Chequeo a ver si el price de
-- Order Items tiene algo que ver
-- con el payment_value de order_payments

SELECT
o.order_id,
op.payment_value,
oi.price
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
LIMIT 50;

-- Noto que siempre el price de order_items es menor que el payment value de order_payments,
-- asi que asumo que tiene alguna relación, dejame ver la documentación

-- Si, el payment_value es el Valor de Transacción, así que vendría siendo el ingreso a la empresa, por lo tanto

--CATEGORY RANK
SELECT
SUM(op.payment_value) AS earnings,
RANK() OVER(ORDER BY op.payment_value DESC) AS rnk,
p.product_category_name AS category
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_category_name
LIMIT 50;
-- Separa suma de earnings y luego ranking
WITH earnings_category_cte AS 
(
SELECT
ROUND(sum(op.payment_value)) AS earnings,
COALESCE(p.product_category_name, 'Category Unassigned') AS category
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY COALESCE(p.product_category_name, 'Category Unassigned')
)
SELECT
earnings,
category,
RANK() OVER(ORDER BY earnings DESC) as rank
FROM earnings_category_cte
--ITEMS RANK
WITH earnings_items_cte AS (
SELECT
COALESCE(p.product_id, 'Not Registered') AS product_id,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS earnings,
COALESCE(p.product_category_name, 'Category Unassigned') AS category
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY COALESCE(p.product_id, 'Not Registered'), COALESCE(p.product_category_name, 'Category Unassigned')
)
SELECT
product_id,
earnings,
category,
RANK() OVER(ORDER BY earnings DESC) AS rank
FROM
earnings_items_cte;

