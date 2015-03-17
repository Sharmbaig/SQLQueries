SELECT CAST(DATENAME(month, A.Date) AS VARCHAR) + ' ' + CAST(DATEPART(year, A.Date) AS VARCHAR) AS Month, 1 - CAST(SUM(A.[Orders Affected]) AS DECIMAL) / CAST(SUM(B.Orders) AS DECIMAL) 
                  AS [Order Accuracy], 1 - CAST(SUM(A.[Units Affected]) AS DECIMAL) / CAST(SUM(C.Units) AS DECIMAL) AS [Unit Accuracy], SUM(B.Orders) AS [Total Inspected Orders Shipped], SUM(C.Units) 
                  AS [Total inspected Units Shipped]
FROM     (SELECT CAST(activity_date AS DATE) AS Date, COUNT(DISTINCT order_id) AS [Orders Affected], COUNT(order_id) AS [Units Affected]
                  FROM      PH_PROD.dbxx.exceptions2
                  WHERE   (CAST(activity_date AS DATE) >= '01/01/14')
                  GROUP BY CAST(activity_date AS DATE)) AS A INNER JOIN
                      (SELECT
						[Date],
						SUM(orders) AS Orders
					  FROM
					  (SELECT CAST(activity_date AS DATE) AS Date, COUNT(DISTINCT order_id) AS Orders
                       FROM      PH_PROD.dbxx.if_transaction
                       WHERE   (if_tran_code = 'VERIFY') AND (CAST(activity_date AS DATE) >= '01/01/14')
                       GROUP BY CAST(activity_date AS DATE)
					   UNION ALL
					   SELECT CAST(activity_date AS DATE) AS Date, COUNT(DISTINCT order_id) AS Orders
                       FROM      PH_ANCIENT_PROD.dbxx.if_transaction
                       WHERE   (if_tran_code = 'VERIFY') AND (CAST(activity_date AS DATE) >= '01/01/14')
                       GROUP BY CAST(activity_date AS DATE)) AS x 
					   GROUP BY [Date]) AS B ON A.Date = B.Date INNER JOIN
                      (SELECT CAST(activity_date AS DATE) AS Date, SUM(CAST([Total Units] AS INT)) AS Units
                       FROM      DataWarehouse.dbo.PackingProductivityFACT
                       WHERE   (if_tran_code = 'VERIFY') AND (CAST(activity_date AS DATE) >= '01/01/14')
                       GROUP BY CAST(activity_date AS DATE)) AS C ON A.Date = C.Date
GROUP BY DATENAME(month, A.Date), DATEPART(year, A.Date)