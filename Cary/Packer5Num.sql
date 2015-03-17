SELECT
	MIN(b.Units_per_hour) AS MinUPH,
	MAX(b.Units_per_hour) AS MaxUPH,
	MIN(b.Order_per_Hour) AS MinOPH,
	MAX(b.Order_per_Hour) AS MAxOPH   
FROM
(SELECT
	  usr_id , 
	  station , 
	  ISNULL( a.Hours , 0
		   )AS [Total Hours] , 
	  ISNULL( a.Orders , 0
		   )AS [Total Orders] , 
	  ISNULL( a.units , 0
		   )AS [Total Units] , 
	  ISNULL( a.units , 0
		   ) / ISNULL( a.Hours , 0
				   )AS [Units_per_hour] , 
	  ISNULL( a.Orders , 0
		   ) / ISNULL( a.Hours , 0
				   )AS [Order_per_Hour] 
  FROM
	  ( 
	    SELECT DISTINCT
			 usr_id , 
			 Station , 
			 SUM( CONVERT( int , [Total Orders]
					   )
			    )AS Orders , 
			 SUM( CONVERT( int , [Total Units]
					   )
			    )AS Units , 
			 SUM( CONVERT( decimal , [Time in Seconds]
					   )
			    ) / 60.0 / 60.0 AS Hours
		 FROM Metrics_Summaries.dbo.PackerProductivity
		 WHERE CAST(activity_date AS DATE) BETWEEN '12/01/14' AND '01/31/15'
		 GROUP BY
				usr_id , 
				Station
	  )AS a
	  WHERE a.Hours > 2.00) AS b
