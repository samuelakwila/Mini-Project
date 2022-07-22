-- NO 1 
CREATE TABLE total_revenue_per_year AS
SELECT 
	date_part('year', o.order_purchase_timestamp) AS year,
	SUM(revenue_per_order) AS revenue
FROM (
	SELECT 
		order_id, 
		SUM(price+freight_value) AS revenue_per_order
	FROM order_items_dataset
	GROUP BY 1
) AS revenue
JOIN orders_dataset AS o ON revenue.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- NO 2
CREATE TABLE total_cancel_order_per_year AS
SELECT
	date_part('year',order_purchase_timestamp) AS year,
	COUNT(1) AS total_cancel
FROM orders_dataset
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY 1;

-- NO 3
CREATE TABLE top_product_category_by_revenue_per_year as 
SELECT 
	year, 
	product_category_name, 
	revenue
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		p.product_category_name,
		SUM(oi.price + oi.freight_value) AS revenue,
		RANK() OVER(
			PARTITION BY date_part('year', o.order_purchase_timestamp) 
	 		ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rk
	FROM order_items_dataset oi
	JOIN orders_dataset AS o on o.order_id = oi.order_id
	JOIN product_dataset AS p on p.product_id = oi.product_id
	WHERE o.order_status = 'delivered'
	GROUP BY 1,2
) AS rev_cat
WHERE rk = 1;

-- NO 4
CREATE TABLE top_product_category_by_cancel_per_year as 
SELECT
	year, 
	product_category_name, 
	total_cancel 
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		p.product_category_name,
		COUNT(1) AS total_cancel,
		RANK() OVER(
			PARTITION BY date_part('year', o.order_purchase_timestamp) 
	 		ORDER BY COUNT(1) DESC
		) AS rk
	FROM order_items_dataset oi
	JOIN orders_dataset AS o on o.order_id = oi.order_id
	JOIN product_dataset AS p on p.product_id = oi.product_id
	WHERE o.order_status = 'canceled'
	GROUP BY 1,2
) AS cancel_cat
WHERE rk = 1;

-- NO 5
SELECT
	ry.year,
	try.product_category_name AS category_most_revenue,
	try.revenue AS most_revenue,
	ry.revenue AS total_revenue_per_year,
	tcy.product_category_name AS category_most_cancel,
	tcy.total_cancel AS num_most_cancel,
	cpy.count AS total_cancel
FROM total_revenue_per_year AS ry
JOIN total_cancel_order_per_year AS cpy ON ry.year=cpy.year
JOIN top_product_category_by_revenue_per_year AS try ON try.year=ry.year
JOIN top_product_category_by_cancel_per_year AS tcy ON tcy.year=ry.year;
