WITH maincte AS (
SELECT
c.customer_id,
c.customer_name AS name,
STRFTIME('%Y-%m', MIN(o.order_date)) AS cohort_month
FROM
customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
), secondcte AS (
SELECT m.cohort_month, m.customer_id,
(STRFTIME('%Y', o.order_date) - SUBSTR(m.cohort_month, 1, 4)) * 12 + (STRFTIME('%m', o.order_date) - SUBSTR(m.cohort_month, 6, 2)) AS months_since_first
FROM maincte m
JOIN orders o ON m.customer_id = o.customer_id 
), thirdcte AS(
SELECT
customer_id, months_since_first, cohort_month, COUNT(DISTINCT customer_id) AS num_customers
FROM
secondcte
GROUP BY months_since_first, cohort_month
)
SELECT
num_customers,
cohort_month,
months_since_first
FROM
thirdcte
ORDER BY
cohort_month, months_since_first;