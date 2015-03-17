SELECT CAST(O.[date_ordered] AS DATE) AS [date_ordered],
	 S.[description], 
      Count(S.[Description]) AS Total_Orders
	  
FROM  
	[PH_PROD].[dbxx].[orders] AS O
		left join 
	[PH_PROD].[dbxx].[order_status] AS S
		ON O.order_status = S.order_status
GROUP BY	
	S.[Description],
	CAST(O.[date_ordered] AS DATE)
ORDER BY
	CAST(O.[date_ordered] AS DATE),
	S.[Description]
	
