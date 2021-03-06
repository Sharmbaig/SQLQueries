/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	DATENAME(month,D.[Date]) AS [Month]
	,SUM(C.[Orders Affected]) AS [Orders Affected]
	,SUM(D.[Orders Shipped]) AS [Orders Shipped]
	,1.0 -(CAST(SUM(C.[Orders Affected])AS DECIMAL)/CAST(SUM(D.[Orders Shipped])AS DECIMAL)) AS [Order Accuracy]
FROM
(SELECT 
		CAST(date_shipped AS DATE) AS [Date]
        ,COUNT(DISTINCT [Original Order ID]) AS [Orders Affected]
  FROM [Metrics Reports].[dbo].[reships] AS A
				INNER JOIN
		[PH_PROD].[dbxx].[hi_orders] AS B
				ON A.[Original Order ID] = B.[order_id]
WHERE CAST(date_shipped AS DATE) >= '01/01/14'
AND [Reship Reason] in ('Missing Product','Wrong Item Received')
GROUP BY CAST(date_shipped AS DATE),[Reship Reason])AS C
INNER JOIN
(SELECT
	CAST(date_shipped AS DATE) AS [Date]
	,COUNT(order_id) AS [Orders Shipped]
FROM PH_PROD.dbxx.hi_orders
WHERE CAST(date_shipped AS DATE) >= '01/01/14'
GROUP BY CAST(date_shipped AS DATE))AS D
	ON C.[Date] = D.[Date]
GROUP BY DATENAME(month,D.[Date])
