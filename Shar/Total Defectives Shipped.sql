/****** Total Defectives Shipped  ******/
SELECT
		[item_id]
		,SUM([pieces_shipped]) AS [Shipped]
FROM 
	[PH_prod].[dbxx].[hi_order_lines]

WHERE	[order_id] IN  

(SELECT 
      [order_id]
      
FROM [PH_PROD].[dbxx].[if_transaction]

WHERE 
	   CAST([activity_date] AS Date) BETWEEN '06/01/2014' AND '06/07/2014' 
			AND if_tran_code = 'VERIFY'
)

AND
	[item_id] IN 
('CH1001'
,'CH1108'
,'CH1401'
,'CH1423'
,'CH1601'
,'CH3061'
,'CH3065'
,'CH7006'
,'CH9004'
,'CH9010')

GROUP BY [item_id]