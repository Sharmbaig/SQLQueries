With [Sales] AS (SELECT
    CAST(date_ordered AS DATE) AS [Date]
	,[item_id]
	,SUM([pieces_ordered]) AS [Total Sold]
FROM [PH_PROD].[dbxx].[hi_orders] AS A
			INNER JOIN 
		[PH_PROD].[dbxx].[hi_order_lines]AS B
				On A.[order_id] = B.[order_id]
WHERE [item_id] like 'ER%'
		AND CAST(date_ordered AS DATE) >= '01/01/14'
GROUP BY CAST(date_ordered AS DATE)
	,[item_id])

SELECT
	[item_id]
	,AVG([Total Sold])
FROM [Sales] 
GROUP BY [item_id]