SELECT 
	CAST(O.[date_ordered] AS DATE) AS [date ordered],
	O.[route_code], 
    COUNT(O.[route_code]) AS [Total Orders]
	  
FROM  
	[PH_TEST].[dbxx].[orders] AS O
		left join 
	[PH_TEST].[dbxx].[order_status] AS S
		ON O.order_status = S.order_status
GROUP BY	
	O.[route_code],
	CAST(O.[date_ordered] AS DATE)
ORDER BY
	CAST(O.[date_ordered] AS DATE),
	O.[route_code]
	