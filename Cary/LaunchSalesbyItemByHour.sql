SELECT
	CAST(date_ordered AS DATE) AS [Date]
	,DATEPART(hour,date_ordered) AS [Hour]
	,item_id
	,COUNT(distinct A.order_id) AS [Total Orders]
	,SUM(pieces_ordered) AS [Total Units]
FROM PH_PROD.dbxx.orders AS A
			INNER JOIN 
	 PH_PROD.dbxx.order_lines AS B
			ON A.order_id = B.order_id
WHERE item_id in (SELECT item_id FROM [Metrics Reports].dbo.FallSkus)
AND CAST(date_ordered AS DATE) >= '08/18/14'
GROUP BY CAST(date_ordered AS DATE),DATEPART(hour,date_ordered)
	,item_id
	UNION ALL
SELECT
	CAST(date_ordered AS DATE) AS [Date]
	,DATEPART(hour,date_ordered) AS [Hour]
	,item_id
	,COUNT(distinct A.order_id) AS [Total Orders]
	,SUM(pieces_ordered) AS [Total Units]
FROM PH_PROD.dbxx.hi_orders AS A
			INNER JOIN 
	 PH_PROD.dbxx.hi_order_lines AS B
			ON A.order_id = B.order_id
WHERE item_id in (SELECT item_id FROM [Metrics Reports].dbo.FallSkus)
and CAST(date_ordered AS DATE) >= '08/18/14'
GROUP BY CAST(date_ordered AS DATE),DATEPART(hour,date_ordered)
	,item_id
ORDER BY [Total Orders] DESC