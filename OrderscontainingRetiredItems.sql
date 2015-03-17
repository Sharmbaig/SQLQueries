Select 
	CAST(O.[date_ordered] AS Date) AS [Date]
	,[order_type]
	,[item_id]
	,COUNT(O.order_id) AS [Total Orders]
	--SUM([pieces_ordered]) AS Pieces
FROM [PH_PROD].[dbxx].[orders] AS O
LEFT JOIN 
[PH_PROD].[dbxx].[order_lines] AS L
ON o.[order_id] = l.[order_id]
WHERE L.item_id  LIKE 'KT%' OR 
		item_id like 'HE1007' OR 
		item_id like 'HE1008' --OR 
		--item_id LIKE 'LK1020H' OR 
		--item_id LIKE 'LK1023'OR 
		--item_id LIKE'CR1047' OR 
		--item_id LIKE 'CR1003'OR 
		--item_id LIKE 'CR1004'OR 
		--item_id LIKE 'LK1023' 
		(SELECT * from [PH_PROD].[dbxx].[orders])

		AND O.[date_ordered] = '10/31/14'
GROUP BY
	CAST(O.[date_ordered] AS Date) 
	,[order_type]
	,[item_id]