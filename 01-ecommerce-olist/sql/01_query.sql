-- "¿Cuáles son las categorías y productos que más ingresos generan?"
--CATEGORY RANK
DROP VIEW IF EXISTS vw_category_rank;
CREATE VIEW vw_category_rank AS (
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
FROM earnings_category_cte);

--ITEMS RANK
DROP VIEW IF EXISTS vw_items_rank;
CREATE VIEW vw_items_rank AS (WITH earnings_items_cte AS (
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
earnings_items_cte);

