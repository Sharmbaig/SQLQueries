DECLARE
   @ErrorRate decimal , 
   @Goal int;
SET @ErrorRate = 0.0484;
SET @Goal = 85;

SELECT
	   TotShipped.Date , 
	   TotShipped.Orders AS [Total Orders Shipped] , 
	   ISNULL( Reships.Orders , 0
			 )AS [Reships Already Receieved] , 
	   CAST( TotShipped.Orders AS decimal
		   ) * @ErrorRate AS [Expected Reships] , 
	   ( CAST( TotShipped.Orders AS decimal
			 ) * @ErrorRate - ISNULL( Reships.Orders , 0
									)
	   ) / @Goal AS [Expected FTEs] , 
	   DATEADD( day , 27 , TotShipped.Date
			  )AS [Expected Date of Most Returns]
  FROM
	  ( 
		SELECT
			   CAST( date_shipped AS date
				   )AS [Date] , 
			   COUNT( order_id
					)AS Orders
		  FROM PH_PROD.dbxx.hi_orders
		  WHERE CAST( date_shipped AS date
					)BETWEEN DATEADD( day , -80 , CAST( GETDATE(
															   )AS date
													  )
									)AND DATEADD( day , -1 , CAST( GETDATE(
																		  )AS date
																 )
												)
		  GROUP BY
				   CAST( date_shipped AS date
					   )
	  )AS TotShipped
	  LEFT JOIN
	  ( 
		SELECT
			   CAST( date_shipped AS date
				   )AS [Date] , 
			   COUNT( DISTINCT A.[Original Order ID]
					)AS Orders
		  FROM
			  [Metrics Reports].dbo.reships AS A
			  INNER JOIN
			  PH_PROD.dbxx.hi_orders AS B
			  ON A.[Original Order ID]
				 = 
				 B.order_id
		  WHERE CAST( date_shipped AS date
					)BETWEEN DATEADD( day , -80 , CAST( GETDATE(
															   )AS date
													  )
									)AND DATEADD( day , -1 , CAST( GETDATE(
																		  )AS date
																 )
												)
		  GROUP BY
				   CAST( date_shipped AS date
					   )
	  )AS Reships
	  ON TotShipped.Date
		 = 
		 Reships.Date;