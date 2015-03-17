SELECT
	CAST(activity_date AS DATE) AS [Date],
	exception_type,
	COUNT(DISTINCT order_id) AS [Number of Orders]
FROM PH_PROD.dbxx.exceptions2 
WHERE CAST(activity_date AS DATE) BETWEEN DATEADD(day,-14,CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)
AND exception_type IN ('EXTRA ITEM','MISPICK','MISSING','SHORT')
GROUP BY CAST(activity_date AS DATE),
	exception_type