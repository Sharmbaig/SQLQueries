/*
Written by Cary Hawkins-Solutions Analyst November 2014

This query takes the 1.0 divided by the inspection rate decimal to obtain a multiplier 
which then multiplies the total exceptions by this to have expected exceptions at 100% order
verification*/
SELECT
	  A.[Date] , 
	  A.[Total Exceptions] , 
	  B.[Inspection Rate] , 
	  CAST( A.[Total Exceptions] * 1.0 / B.[Inspection Rate] AS int
		 )AS [Exceptions at 100%]
  FROM
	  ( /* This Subquery returns the total exceptions by day*/
	    SELECT
			 CAST( activity_date AS date
				)AS [Date] , 
			 COUNT( exception_type
				 )AS [Total Exceptions]
		 FROM PH_PROD.dbxx.exceptions2
		 WHERE CAST( activity_date AS date
				 )
			  >= 
			  '01/01/14'
		 GROUP BY
				CAST( activity_date AS date
				    )
	  )AS A
	  INNER JOIN
	  ( /*Subquery that returns the inspection percentage by day*/
	    SELECT
			 CAST( [Inspected Orders].[Date] AS date
				)AS [Date] , 
			 ROUND( CAST( ISNULL( [Inspected Orders].Orders , 0
							)AS float
					  ) / CAST( ISNULL( [Inspected Orders].Orders , 0
								   ) + ISNULL( [Non Inspected Orders].Orders , 0
										   )AS float
							) , 3
				 )AS [Inspection Rate]
		 FROM
			 ( /*Obtains the orders that were inspected*/
	    SELECT
			 CAST( O.date_shipped AS date
				)AS [Date] , 
			 COUNT( O.order_id
				 )AS Orders
		 FROM
			 PH_PROD.dbxx.if_transaction AS I
			 INNER JOIN
			 PH_PROD.dbxx.hi_orders AS O
			 ON I.order_id
			    = 
			    O.order_id
		 WHERE if_tran_code
			  = 
			  'VERIFY'
		   AND CAST( date_shipped AS date
				 )
			  >= 
			  '01/01/14'
		 GROUP BY
				CAST( date_shipped AS date
				    )
			 )AS [Inspected Orders]
			 LEFT JOIN
			 ( /*Obtains the orders that were not inspected*/
	    SELECT
			 CAST( O.date_shipped AS date
				)AS [Date] , 
			 COUNT( O.order_id
				 )AS Orders
		 FROM
			 PH_PROD.dbxx.if_transaction AS I
			 INNER JOIN
			 PH_PROD.dbxx.hi_orders AS O
			 ON I.order_id
			    = 
			    O.order_id
		 WHERE if_tran_code
			  = 
			  'VERIFY-Q'
		   AND CAST( date_shipped AS date
				 )
			  >= 
			  '01/01/14'
		 GROUP BY
				CAST( date_shipped AS date
				    )
			 )AS [Non Inspected Orders]
			 ON [Inspected Orders].[Date]
			    = 
			    [Non Inspected Orders].[Date]
		 GROUP BY
				CAST( [Inspected Orders].[Date] AS date
				    ) , 
				[Inspected Orders].Orders , 
				[Non Inspected Orders].Orders
	  )AS B
	  ON A.[Date]
		= 
		B.[Date]
  ORDER BY
		 [Date];