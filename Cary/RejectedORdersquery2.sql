/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	A.item_id
	,A.location_id
	,A.[Available]
	,B.[Total Ordered]
	,[Available]-[Total Ordered] AS [Pieces Left]
FROM
(SELECT item_id
	,location_id
	,pieces_onhand-(pieces_hard+pieces_pend) AS [Available]
FROM PH_PROD.dbxx.item_location
WHERE item_id in 
(SELECT DISTINCT
	item_id
FROM PH_PROD.dbxx.order_lines
WHERE order_id in 
(SELECT  
      [order_id]
  FROM [PH_PROD].[dbxx].[wave_order_reject]
  WHERE CAST([reject_date] AS DATE) = CAST(GETDATE() AS DATE))
GROUP BY item_id)
AND location_type = 'PTL')As A
INNER JOIN 
(SELECT 
	item_id
	,sum(pieces_ordered) AS [Total Ordered]
FROM PH_PROD.dbxx.order_lines
WHERE order_id in 
(SELECT  
      [order_id]
  FROM [PH_PROD].[dbxx].[wave_order_reject]
  WHERE CAST([reject_date] AS DATE) = CAST(GETDATE() AS DATE))
GROUP BY item_id) AS B
ON A.item_id = B.item_id
ORDER BY [Pieces Left]