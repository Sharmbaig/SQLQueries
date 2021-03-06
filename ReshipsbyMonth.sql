
SELECT
	  DATENAME(month,date_shipped) AS [Month]
	   ,[Reship Reason]
      ,COUNT([Original Order ID]) AS [Total Orders]
     
  FROM [Metrics Reports].[dbo].[reships] AS R
				INNER JOIN
		[PH_PROD].[dbxx].[hi_orders] AS O
				ON R.[Original Order ID] = O.[order_id] 
WHERE CAST(date_shipped AS DATE) >= '01/01/14'
GROUP BY DATENAME(month,date_shipped)
	   ,[Reship Reason]
ORDER BY [Month],[Reship Reason]