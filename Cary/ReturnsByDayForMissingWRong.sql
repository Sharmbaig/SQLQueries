/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	A.*
	,B.[Units] AS [Returns Made in Units]
	,C.[Found] AS [Units Found at Inspection]
FROM
(SELECT CAST([activity_date] AS DATE) AS [Date]
      ,SUM([pieces]) AS [Picks]
  FROM [DataWarehouse].[dbo].[PickedItemsbyPicker]
  WHERE CAST(activity_date AS DATE) >= '09/01/14'
  GROUP BY CAST([activity_date] AS DATE)) AS A
  LEFT JOIN	
(SELECT 
		CAST([DateShipped] AS DATE) AS [Date]
		,SUM([ReturnQuantity]) AS [Units]
  FROM [Metrics Reports].[dbo].[ReturnsReport]
  WHERE [PrimaryReason] in ('Wrong Item','Missing Item')
  AND CAST([DateShipped] AS DATE) >= '09/01/14'
  GROUP BY CAST([DateShipped] AS DATE)) AS B
  ON A.[Date] = B.[Date]
  LEFT JOIN
  (SELECT 
      CAST([activity_date] AS DATE) AS [Date]
      ,COUNT([exception_type]) AS [Found]
  FROM [PH_PROD].[dbxx].[exceptions2]
  WHERE CAST(activity_date AS DATE) >= '09/01/14'
  and exception_type in ('MISSING','WRONG ITEM')
  GROUP BY CAST([activity_date] AS DATE)) AS C
	ON A.[Date] = C.[Date]
  