WITH [Inventory On Hand] AS(SELECT
	[item_id]
	,SUBSTRING(location_id,1,1) AS Lane
	,SUM([pieces_onhand])AS [Total On Hand]
FROM [PH_PROD].[dbxx].[item_location]
WHERE [location_type] = 'PTL'
AND item_id not like 'KT%'
GROUP BY [item_id],SUBSTRING(location_id,1,1))

SELECT
	item_id
	,[Inventory Left]
	,CASE WHEN [Inventory Left] <= 0
		  THEN 'Out of Stock'
		  WHEN [Inventory Left] between 1 and 100
		  THEN 'Very Low Stock'
		  WHEN [Inventory Left] between 101 and 500
		  THEN 'Low Stock'
		  ELSE 'Good Stock'
		  END AS [Stock Level]
FROM
(SELECT 
	A.item_id
	,([Total On Hand]- ISNULL(SUM(pieces_ordered)/6,0)) AS [Inventory Left]
FROM [Inventory On Hand] AS A
		LEFT JOIN
	 [PH_PROD].[dbxx].[order_lines] AS B
		On A.[item_id] = B.[item_id]
WHERE [Lane] = 'D'
GROUP BY A.item_id,[Total On Hand])AS A
ORDER BY [Inventory Left] 