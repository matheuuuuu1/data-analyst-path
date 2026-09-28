-- ¿Los clientes vuelven a comprar?
DROP VIEW IF EXISTS vw_cohort;
CREATE VIEW vw_cohort AS (
WITH maincte AS (
SELECT
c.customer_unique_id AS customer_name,
TO_CHAR(MIN(o.order_purchase_timestamp::date), 'YYYY-MM') AS cohort_month
FROM
customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_name -- Acomoda
), secondcte AS (
SELECT m.cohort_month, m.customer_name,
(EXTRACT(YEAR FROM AGE(o.order_purchase_timestamp::date, (m.cohort_month || '-01')::date)) * 12 + EXTRACT(MONTH FROM AGE(o.order_purchase_timestamp::date, (m.cohort_month || '-01')::date))) AS months_since_first
FROM maincte m
JOIN customers c ON m.customer_name = c.customer_unique_id
JOIN orders o ON c.customer_id = o.customer_id
), thirdcte AS (
SELECT
months_since_first, cohort_month,
COUNT(DISTINCT customer_name) AS num_customers
FROM secondcte
GROUP BY months_since_first, cohort_month
)
SELECT
num_customers,
cohort_month,
months_since_first
FROM
thirdcte
ORDER BY
cohort_month, months_since_first);