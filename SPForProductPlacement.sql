/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
		L.[item_id]
		,SUM(L.[pieces_ordered]) AS [total units]
  FROM [PH_PROD].[dbxx].[hi_order_lines] AS L
  LEFT JOIN [PH_PROD].[dbxx].[hi_orders] AS H
  ON H.[order_id] = L.[order_id]
  WHERE CAST(H.date_ordered AS DATE) between '02/18/14' and '02/23/14'
  AND L.[item_id] like 'SP%'
  GROUP BY
			L.[item_id]