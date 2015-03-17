	SELECT  
      CAST(O.[date_ordered] AS DATE) AS [date_ordered]
      --,O.[order_type]
      --,O.[order_priority]
      --,O.[route_code]
	  --,S.[description]
	  ,COUNT(O.[order_id]) AS [TotalOrders]
	  ,SUM(L.[pieces_to_pick]) AS [TotalPieces]
FROM 
	[PH_TEST].[dbxx].[orders] AS O
		left join 
	[PH_TEST].[dbxx].[order_status] AS S
		ON O.order_status = S.order_status
		left join 
	[PH_TEST].[dbxx].[order_lines] AS L
		ON O.order_id = L.order_id
GROUP BY	
	CAST(O.[date_ordered] AS DATE)
    --O.[order_type],
    --O.[order_priority],
    --O.[route_code],
	--S.[description]
ORDER BY
	CAST(O.[date_ordered] AS DATE)
	
