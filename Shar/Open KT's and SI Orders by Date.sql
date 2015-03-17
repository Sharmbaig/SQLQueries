/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	 [item_id]
		,(O.[order_id]) as [count]
		,tot_to_pick 
		 ,[date_ordered] AS Date
   
FROM [PH_PROD].[dbxx].[order_lines] AS L

INNER JOIN
 		[PH_PROD].[dbxx].[orders] AS O

ON L.[order_id] = O.[order_id]

WHERE item_id = 'KT3019' ---OR item_id like 'SI%'

GROUP BY [item_id],[date_ordered], tot_to_pick,o.[order_id]
ORDER BY tot_to_pick ASC
