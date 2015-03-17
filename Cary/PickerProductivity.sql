SELECT
	   zonename , 
	   pickername , 
	   --date , 
	   SUM( pieces
		  )AS units , 
	   SUM( lines
		  )AS lines , 
	   SUM( hours
		  )AS hours , 
	   SUM( expectedhours
		  )AS expectedhours , 
	   SUM( pieces
		  ) / SUM( hours
				 )AS [units/hr] , 
	   SUM( lines
		  ) / SUM( hours
				 )AS [lines/hr]
				------this pulls all of the collected data and gives the information by picker by zone----
  FROM( 
		SELECT
			   a.zonename , 
			   a.pickername , 
			   SUM( pieces
				  )AS pieces , 
			   SUM( lines
				  )AS lines , 
			   a.[date] , 
			   SUM( seconds
				  ) / 60.0 / 60.0 AS hours , 
			   b.ExpectedHours
			   -----this pulls all of the collected data and gives the information by picker by zone----
		  FROM
			  ( 
		SELECT
			   zonename , 
			   pickername , 
			   barcode , 
			   pieces , 
			   lines , 
			   CAST( EventDateTime AS date
				   )AS [date] , 
			   DATEDIFF( SECOND , lag( eventdatetime
									 )OVER( PARTITION BY pickername , 
														 zonename , 
														 CAST( eventdatetime AS date
															 )ORDER BY eventdatetime
										  ) , eventdatetime
					   )AS seconds
		  FROM(        
		  ------this takes the diffrence between the time the tote was inducted into the zone to the time the last pick was confirmed----
			  ------ START RAW PICKING TIME -------
		SELECT
			   EventDateTime , 
			   ZoneName , 
			   Barcode , 
			   PickerName , 
			   '0' AS pieces , 
			   '0' AS lines
		  FROM METRICS_SUMMARIES.dbo.LPScanEvents
		  WHERE barcode IN( 'ZoneStarted'
						  )
			AND pickername NOT IN( 'unassigned'
								 )
			AND CAST( EventDateTime AS datetime
					)BETWEEN @startdate AND @enddate
					-----this pulls all of the Zonestarted scanns from the lpscanevents table------
		UNION
		SELECT
			   MAX( PickCompleteTime
				  ) , 
			   b.Zonename , 
			   'ZoneComplete' , 
			   c.PickerName , 
			   SUM( PickedQty
				  )AS pieces , 
			   COUNT( pickedQty
					)AS lines
		  FROM
			  LPPick.dbo.PickLines AS a
			  LEFT JOIN
			  LPPick.dbo.zones AS b
			  ON a.ZoneId
				 = 
				 b.ZoneId
			  LEFT JOIN
			  LPPick.dbo.Pickers AS c
			  ON a.pickerid
				 = 
				 c.pickerid
		  WHERE CAST( pickcompletetime AS datetime
					)BETWEEN @startdate AND @enddate
		  GROUP BY
				   b.Zonename , 
				   c.PickerName , 
				   a.PickOrderId
				   -----this merges the last item picked from the pickorderid to the start time to setup for time diffrences------

			  ------ END RAW PICKING TIME -------

			  )AS a
			  )AS a
			  LEFT JOIN
			  ( 
		SELECT
			   zonename , 
			   CAST( date AS date
				   )AS date , 
			   pickername , 
			   SUM( seconds
				  ) / 60.0 / 60.0 AS ExpectedHours
		  FROM( 
		SELECT
			   zonename , 
			   pickername , 
			   seconds , 
			   starttime , 
			   time , 
			   CAST( date AS date
				   )AS date
		  FROM( 
		SELECT
			   * , 
			   DATEDIFF( SECOND , lag( starttime
									 )OVER( PARTITION BY pickername , 
														 zonename ORDER BY starttime
										  ) , starttime
					   )AS seconds
		  FROM(

			  ------ START RAW EXPECTED PICKING TIME -------

		SELECT
			   *
		  FROM( 
		SELECT
			   zonename , 
			   pickername , 
			   time , 
			   CAST( date AS date
				   )AS date , 
			   CASE
			   WHEN [time]
					= 
					'Start time' THEN starttime
				   ELSE CASE
						WHEN lead( time
								 )OVER( PARTITION BY zonename--, pickername
							 ORDER BY starttime
									  )
							 = 
							 'start time' THEN starttime
							ELSE CASE
								 WHEN MAX( starttime
										 )OVER( PARTITION BY CAST( date AS date
																 ) , 
															 pickername , 
															 zonename
											  )
									  = 
									  starttime THEN starttime
									 ELSE NULL
								 END
						END
			   END AS starttime
			   -----this take the diffrence between the time the picker started the zone to when the picker left the zone-----
		  FROM( 
		SELECT
			   starttime , 
			   zonename , 
			   pickername , 
			   CAST( StartTime AS date
				   )AS date , 
			   'start time' AS time
		  FROM
			  LPPick.dbo.PickerLog AS C
			  INNER JOIN
			  LPPick.dbo.Pickers AS D
			  ON C.PickerID
				 = 
				 D.PickerID
			  INNER JOIN
			  LPPick.dbo.Zones AS E
			  ON C.ZoneId
				 = 
				 E.ZoneID
		  WHERE CAST( StartTime AS datetime
					)BETWEEN @startdate AND @enddate
					-------this gives the time the picker started the zone----
		UNION
		SELECT
			   pickcompletetime , 
			   c.ZoneName , 
			   PickerName , 
			   CAST( pickcompletetime AS date
				   )AS date , 
			   'end time'
		  FROM
			  lppick.dbo.PickLines AS a
			  LEFT JOIN
			  lppick.dbo.pickers AS b
			  ON a.pickerid
				 = 
				 b.pickerid
			  LEFT JOIN
			  lppick.dbo.Zones AS c
			  ON a.zoneid
				 = 
				 c.zoneid
		  WHERE CAST( pickcompletetime AS datetime
					)BETWEEN @startdate AND @enddate
					-----this is the time the picker left the zone-----
			  )AS a
			  )AS a
		  WHERE starttime IS NOT NULL      
			  ------ END RAW EXPECTED PICKING TIME -------
			  )AS a
			  )AS a
		  WHERE time
				= 
				'end time'
				-------this specifies that we only want the time the picker was in the zone not the time the zone was idle-----
			  )AS a
		  GROUP BY
				   pickername , 
				   zonename , 
				   CAST( date AS date
					   )
			  )AS b
			  ON a.zonename
				 = 
				 b.zonename
			 AND a.pickername
				 = 
				 b.pickername
			 AND a.date = b.date
		  WHERE a.barcode
				= 
				'ZoneComplete'
				-------this specifies that we only want the time the picker was picking  not the time the picker was idle-----
		  GROUP BY
				   a.[date] , 
				   a.zonename , 
				   a.pickername , 
				   b.ExpectedHours
	  )AS a

  GROUP BY
		   zonename , 
		   pickername 

  ORDER BY
		   zonename;