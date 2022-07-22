--- NO 1
SELECT
	payment_type,
	COUNT(1) AS total_use_payment_type
FROM order_payments_dataset
GROUP BY 1
ORDER BY total_use_payment_type DESC;

--- NO 2
WITH all_data
AS (
	SELECT
		date_part('year',order_purchase_timestamp) AS year,
		payment_type,
		COUNT(1) AS total_use_payment_method
	FROM
		order_payments_dataset AS opd
	JOIN orders_dataset AS od ON od.order_id=opd.order_id
	GROUP BY year, payment_type
	ORDER BY year, total_use_payment_method DESC
)

SELECT
	*,
	CASE WHEN year_2017 = 0 THEN NULL
		 ELSE round((year_2018 - year_2017) / year_2017, 2)
	END AS growth_pct
FROM(
	SELECT 
		payment_type,
		SUM(CASE WHEN year = '2016' THEN total_use_payment_method ELSE 0 END) AS year_2016,
		SUM(CASE WHEN year = '2017' THEN total_use_payment_method ELSE 0 END) AS year_2017,
		SUM(CASE WHEN year = '2018' THEN total_use_payment_method ELSE 0 END) AS year_2018
	FROM all_data
	GROUP BY 1	
) AS year_data
ORDER BY 5 DESC;