/****** Script for SelectTopNRows command from SSMS  ******/
SELECT A.[item_id]
      ,[description]
	  ,ISNULL(SUM(B.[pieces_onhand]),0) AS [Pieces on Hand]
	  ,CASE WHEN A.item_id = 'CH3078'
			THEN (SELECT SUM(pieces_onhand) FROM PH_PROD.dbxx.item_location WHERE item_id = 'CH3006')
			WHEN A.item_id = 'CH3076'
			THEN (SELECT SUM(pieces_onhand) FROM PH_PROD.dbxx.item_location WHERE item_id = 'CH3004')
			WHEN A.item_id = 'CH3079'
			THEN (SELECT SUM(pieces_onhand) FROM PH_PROD.dbxx.item_location WHERE item_id = 'CH3007')
			WHEN A.item_id = 'CH3083'
			THEN (SELECT SUM(pieces_onhand) FROM PH_PROD.dbxx.item_location WHERE item_id = 'CH3011')
			WHEN A.item_id = 'SM1076'
			THEN (SELECT SUM(pieces_onhand) FROM PH_PROD.dbxx.item_location WHERE item_id = 'CR1076')
			END AS [Pieces]
  FROM [Metrics Reports].[dbo].[FallSkus]AS A
				LEFT JOIN
	   [PH_PROD].[dbxx].[item_location] AS B
				ON A.[item_id] = B.[item_id] 
GROUP BY A.[item_id]
      ,[description]
ORDER BY [item_id]