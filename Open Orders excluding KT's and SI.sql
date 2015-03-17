
SELECT
		COUNT(distinct([Order_id]))
		

FROM
		[PH_PROD].[dbxx].[Order_Lines]

WHERE 
		[item_id] NOT LIKE 'SP%' AND [item_id] NOT LIKE 'SP1031'



