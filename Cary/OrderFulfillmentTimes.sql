WITH D
	AS ( SELECT
				order_id , 
				route_code , 
				CAST( date_ordered AS date
					)AS Date , 
				date_created , 
				date_shipped , 
				ship_method
		   FROM PH_PROD.dbxx.hi_orders AS A
		   WHERE order_id NOT IN( 
								  SELECT
										 order_id
									FROM PH_PROD.dbxx.hi_order_lines
									WHERE item_id LIKE 'RG%'
									   OR item_id LIKE 'KT3%'
								)
		 UNION ALL
		 SELECT
				order_id , 
				route_code , 
				CAST( date_ordered AS date
					)AS Date , 
				date_created , 
				date_shipped , 
				ship_method
		   FROM PH_PROD.dbxx.orders AS B
		   WHERE order_id NOT IN( 
								  SELECT
										 order_id
									FROM PH_PROD.dbxx.order_lines
									WHERE item_id LIKE 'RG%'
									   OR item_id LIKE 'KT3%'
								)
	   )
	SELECT
		   Date , 
		   DATEPART( weekday , Date
				   )AS Weekday , 
		   order_id , 
		   route_code , 
		   ship_method , 
		   date_shipped , 
		   package_trace_id , 
		   Hours , 
		   CASE
		   WHEN DATEPART( weekday , [Date]
						)NOT IN( 4 , 5 , 6
							   )
			AND Hours <= 24 THEN '<1 Business Day'
		   WHEN DATEPART( weekday , [Date]
						)NOT IN( 4 , 5 , 6
							   )
			AND Hours BETWEEN 24.01 AND 48.00 THEN '1-2 business days'
		   WHEN DATEPART( weekday , [Date]
						)NOT IN( 4 , 5 , 6
							   )
			AND Hours BETWEEN 48.01 AND 72.00 THEN '2-3 business days'
		   WHEN DATEPART( weekday , [Date]
						)NOT IN( 4 , 5 , 6
							   )
			AND Hours BETWEEN 72.01 AND 96.00 THEN '3-4 business days'
		   WHEN DATEPART( weekday , [Date]
						)NOT IN( 4 , 5 , 6
							   )
			AND Hours > 96.01 THEN '>4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				4
			AND Hours <= 120.00 THEN '<1 Business Day'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				5
			AND Hours <= 96.00 THEN '<1 Business Day'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				6
			AND Hours <= 72.00 THEN '<1 Business Day'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				4
			AND Hours BETWEEN 120.01 AND 168.00 THEN '1-2 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				5
			AND Hours BETWEEN 96.01 AND 120.00 THEN '1-2 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				6
			AND Hours BETWEEN 72.01 AND 96.00 THEN '1-2 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				4
			AND Hours BETWEEN 168.01 AND 192.00 THEN '2-3 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				5
			AND Hours BETWEEN 120.01 AND 168.00 THEN '2-3 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				6
			AND Hours BETWEEN 96.01 AND 120.00 THEN '2-3 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				4
			AND Hours BETWEEN 192.01 AND 216.00 THEN '3-4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				5
			AND Hours BETWEEN 168.01 AND 192.00 THEN '3-4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				6
			AND Hours BETWEEN 120.01 AND 168.00 THEN '3-4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				4
			AND Hours >= 216.01 THEN '>4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				5
			AND Hours >= 192.01 THEN '>4 business days'
		   WHEN DATEPART( weekday , [Date]
						)
				= 
				6
			AND Hours >= 168.01 THEN '3-4 business days'
		   END AS Bucket
	  FROM( 
			SELECT
				   CAST( A.Date AS datetime
					   )AS Date , 
				   A.order_id , 
				   A.route_code , 
				   A.ship_method , 
				   A.date_shipped , 
				   B.package_trace_id , 
				   DATEDIFF( second , A.date_created , ISNULL( A.date_shipped , GETDATE(
																					   )
															 )
						   ) / 60.0 / 60.0 - HFTE.Hours AS Hours
			  FROM
				  D AS A
				  INNER JOIN
				  PH_PROD.dbxx.hi_work_cartons AS B
				  ON A.order_id
					 = 
					 B.order_id
				  INNER JOIN
				  DataWarehouse.dbo.HolidayFulfillmentTimeExceptions AS HFTE
				  ON CAST( A.Date AS date
						 )
					 = 
					 CAST( HFTE.Date AS date
						 )
		  )AS C;