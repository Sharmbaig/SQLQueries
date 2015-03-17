	SELECT  
      CAST(O.[date_ordered] AS DATE) AS [date_ordered]
	  ,SUM(L.[pieces_to_pick]) AS [TotalPieces]
FROM 
	[PH_PROD].[dbxx].[orders] AS O
		left join 
	[PH_PROD].[dbxx].[order_status] AS S
		ON O.order_status = S.order_status
		left join 
	[PH_PROD].[dbxx].[order_lines] AS L
		ON O.order_id = L.order_id
WHERE O.[order_status] = '010'
GROUP BY	
	CAST(O.[date_ordered] AS DATE)
ORDER BY
	CAST(O.[date_ordered] AS DATE)
	
