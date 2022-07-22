WITH

---- NO 1. MONTHLY ACTIVE USERS
calc_mau AS (
SELECT 
	year, 
	round(AVG(mau), 0) AS average_mau
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) as year,
		date_part('month', o.order_purchase_timestamp) as month,
		COUNT(DISTINCT c.customer_id) AS mau
	FROM orders_dataset o 
	JOIN customers_dataset c ON o.customer_id = c.customer_id
	GROUP BY 1,2 
) AS mau_calc
GROUP BY 1
),						

---- NO 2. NEW CUSTOMERS
calc_new AS (
SELECT 
	date_part('year', first_purchase_time) AS year,
	COUNT(1) as new_customers
FROM (
	SELECT 
		c.customer_unique_id,
		MIN(o.order_purchase_timestamp) AS first_purchase_time
	FROM orders_dataset o 
	JOIN customers_dataset c on c.customer_id = o.customer_id
	GROUP BY 1
) AS new_cust_calc
GROUP BY 1
ORDER BY 1
),						

---- NO 3. REPEAT ORDERS
calc_repeat AS (
SELECT 
	year, 
	COUNT(DISTINCT customer_unique_id) AS repeating_customers
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		c.customer_unique_id,
		COUNT(1) AS purchase_frequency
	FROM orders_dataset o 
	JOIN customers_dataset c ON c.customer_id = o.customer_id
	GROUP BY 1, 2
	HAVING COUNT(1) > 1
) AS repeat_order_calc
GROUP BY 1
),						

---- NO 4. AVERAGE ORDER FREQUENCY
calc_avg_order AS (
SELECT 
	year,
	COUNT(DISTINCT(customer_unique_id)) AS unique_customer,
	ROUND(AVG(frequency_purchase),2) AS avg_order_freq_per_cust
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		c.customer_unique_id,
		COUNT(1) AS frequency_purchase
	FROM orders_dataset o 
	JOIN customers_dataset c on c.customer_id = o.customer_id
	GROUP BY 1,2
) AS order_freq_calc
GROUP BY 1
ORDER BY 1
)						


---- NO 5. JOINING ALL THE TABLES
SELECT					
	calc_mau.year,
	calc_mau.average_mau,
	calc_new.new_customers,
	calc_repeat.repeating_customers,
	calc_avg_order.avg_order_freq_per_cust 
FROM calc_mau
JOIN calc_repeat ON calc_mau.year = calc_repeat.year
JOIN calc_avg_order ON calc_mau.year = calc_avg_order.year
JOIN calc_new ON calc_mau.year = calc_new.year
