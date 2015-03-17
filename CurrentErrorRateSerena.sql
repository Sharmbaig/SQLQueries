SELECT
	[Affected].[Orders Affected]
	,[Shipped].[Shipped]
	,(CAST([Affected].[Orders Affected]AS DECIMAL)/([Shipped].[Shipped])) AS [Error Rate]
FROM
(SELECT 
	   CAST(activity_date AS DATE) AS [Date]
	   ,COUNT(DISTINCT[order_id]) AS [Orders Affected]
FROM [PH_PROD].[dbxx].[exceptions2]

WHERE 
	CAST(activity_date AS DATE) =CAST(GETDATE() AS DATE)
	GROUP BY CAST(activity_date AS DATE)) AS [Affected]
	INNER JOIN
(SELECT 
	CAST([date_shipped] AS DATE) AS [Date]
	,COUNT(O.[order_id]) AS [Shipped]
FROM [PH_PROD].[dbxx].[hi_orders] AS O
			JOIN
	 [PH_PROD].[dbxx].[if_transaction] AS I
			ON I.[order_id] = O.[order_id] 
WHERE CAST([date_shipped] AS DATE) = CAST(GETDATE() AS DATE)
	  AND [if_tran_code] = 'VERIFY'
GROUP BY CAST([date_shipped] AS DATE)) AS [Shipped]
	ON Affected.[Date] = Shipped.[Date]