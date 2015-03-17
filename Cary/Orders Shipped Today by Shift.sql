WITH Shipped AS(
SELECT date_shipped
,order_id
,CASE WHEN CAST(date_shipped AS TIME) between '10:30' and '19:30'
THEN 1
WHEN CAST(date_shipped AS TIME) between '19:30' and '23:59'
THEN 2
WHEN CAST(date_shipped AS TIME) between '00:00' and '01:30'
THEN 2
ELSE 3
END AS [Shift]
FROM [PH_PROD].[dbxx].hi_orders
WHERE CAST(date_shipped AS DATE)= CAST(GETDATE() AS DATE))

SELECT
	CAST(date_shipped AS DATE) AS [Date]
	,[Shift]
	,COUNT(distinct order_id) AS [Orders Shipped]
FROM Shipped
GROUP BY CAST(date_shipped AS DATE),[Shift]