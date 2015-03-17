SELECT
	CAST(date_ordered AS DATE) AS [Date]
	,description
	,route_code
	,COUNT(order_id) AS [Orders]
FROM PH_PROD.dbxx.orders AS A
			INNER JOIN
	 PH_PROD.dbxx.order_status AS B
			ON A.order_status = B.order_status
WHERE  route_code not like 'STD%'
AND CAST(date_ordered AS DATE) between '08/18/14' and '08/19/14'
GROUP BY CAST(date_ordered AS DATE)
	,route_code,description