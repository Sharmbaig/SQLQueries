DECLARE @startdate as date,
		@enddate as date

SET @startdate = '06/06/2014'
SET @enddate = '06/06/2014'

SELECT  
				cast(logout_date as date) as date,
				b.full_name
				,[Lane] 
			  ,sum(DATEDIFF(second, [login_time], cast(dateadd( hour, -3, [logout_time]) as datetime))/60.0/60.0) as Hours
		  FROM [PH_PROD].[dbxx].[hi_usr_login] as a
		  LEFT JOIN
		  [PH_PROD].[dbxx].[usrs] as b
			on a.usr_id = b.usr_id
			INNER JOIN
		  [METRICS_SUMMARIES].[dbo].[PackLanes] AS C
			ON A.[host_name] = C.[host_name]
		  WHERE A.[host_name] like 'O2-PACK%'
		  AND [logout_time] is not null
		  AND cast([login_time] as date) between @startdate and @enddate
		  GROUP BY logout_date,
				b.full_name, [Lane]