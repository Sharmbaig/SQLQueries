/***Orders by Order Type***/
SELECT 
      Cast([date_ordered] AS DATE) AS [Date Ordered],
	  [order_type]
      ,Count([order_type])AS [Type]
  FROM [PH_PROD].[dbxx].[orders]
  WHERE Cast([date_ordered] AS DATE) = '02/11/14'
  GROUP BY
		 Cast([date_ordered] AS DATE),
		 [order_type]
