/* This Report is a rough forecast of Order Accuracy for 14 days rolling. Using the inspection rate to find a multiplier to show what should be expected at 100% inspection
The orders affected are multiplied by this and then the result is divided by the total orders.*/

SELECT
	  A.[Date], 
	  1 - (SUM(A.[Orders Affected])*(1.0/(CAST(B.Orders AS DECIMAL)/CAST(D.Orders AS DECIMAL))) / CAST( SUM( D.Orders
					   )AS decimal
				   ))AS [Order Accuracy] , 
	  SUM(D.Orders) AS [Total Orders Shipped],
	  SUM(A.[Orders Affected])*(1.0/(CAST(B.Orders AS DECIMAL)/CAST(D.Orders AS DECIMAL))) AS [Orders With Errors at 100% Inspection]

  FROM
	  ( 
	    SELECT
			 CAST( activity_date AS date
				)AS Date , 
			 COUNT( DISTINCT order_id
				 )AS [Orders Affected] , 
			 COUNT( order_id
				 )AS [Units Affected]
		 FROM PH_PROD.dbxx.exceptions2
		 WHERE CAST( activity_date AS date
				 )
			 between DATEADD(day,-14,CAST(GETDATE()AS DATE)) AND CAST(GETDATE() AS DATE)
		 GROUP BY
				CAST( activity_date AS date
				    )
	  )AS A
	  INNER JOIN
	  ( 
	    SELECT
			 CAST( activity_date AS date
				)AS Date , 
			 COUNT( DISTINCT order_id
				 )AS Orders
		 FROM PH_PROD.dbxx.if_transaction
		 WHERE if_tran_code
			  = 
			  'VERIFY'
		   AND CAST( activity_date AS date
				 )
			 between DATEADD(day,-14,CAST(GETDATE()AS DATE)) AND CAST(GETDATE() AS DATE)
		 GROUP BY
				CAST( activity_date AS date
				    )
	  )AS B
	  ON A.Date = B.Date
	  INNER JOIN
	  ( 
	    SELECT
			 CAST( activity_date AS date
				)AS Date , 
			 SUM( CAST( [Total Units] AS int
					)
			    )AS Units
		 FROM PH_PROD.dbo.View_PackerStats
		 WHERE if_tran_code
			  = 
			  'VERIFY'
		   AND CAST( activity_date AS date
				 )
			  between DATEADD(day,-14,CAST(GETDATE()AS DATE)) AND CAST(GETDATE() AS DATE)
		 GROUP BY
				CAST( activity_date AS date
				    )
	  )AS C
	  ON A.Date = C.Date
INNER JOIN
(SELECT
			 CAST( activity_date AS date
				)AS Date , 
			 SUM( CAST( [Total Units] AS int
					)
			    )AS Units,
			 SUM( CAST( [Total Orders] AS INT
				)
			 ) AS Orders
		 FROM PH_PROD.dbo.View_PackerStats
		 WHERE CAST( activity_date AS date
				 )
			  between DATEADD(day,-14,CAST(GETDATE()AS DATE)) AND CAST(GETDATE() AS DATE)
		 GROUP BY
				CAST( activity_date AS date
				    ))AS D
ON A.Date = D.Date
    
  GROUP BY
		A.[Date],
		B.Orders,
		D.Orders;
