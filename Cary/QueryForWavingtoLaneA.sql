/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	DISTINCT	
	    CAST(date_ordered AS DATE) AS [Date]
		,O.[order_id]
FROM [PH_PROD].dbxx.[orders] AS O
			LEFT JOIN
	 [PH_PROD].dbxx.[order_lines] AS L
			ON O.order_id = L.order_id
WHERE L.[item_id]  not in 
(SELECT 
      [item_id]
  FROM [PH_PROD].[dbxx].[item_location]
  WHERE SUBSTRING(location_id,1,1)= 'A' AND  SUBSTRING(location_id,1,4)  not in ('A-AA','A-AB','A-AC','A-BA','A-BB','A-BC','A-AD','A-AE','A-AF','A-BD','A-BE','A-BF'))
AND O.[order_type] = 'RETAIL'
AND CAST(date_ordered AS DATE) < '06/30/14'
and O.[order_status] =010
ORDER BY order_id