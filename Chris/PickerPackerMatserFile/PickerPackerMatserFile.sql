DECLARE @StartDate AS DATETIME,@EndDate AS DATETIME;
SET @StartDate = '09/19/14 01:00:00'
SET @EndDate = '09/19/14 23:30:00' 



SELECT
a.lane,
a.[expected time],
b.logged_hrs
FROM
(SELECT  
		
		[Lane]
		
      ,SUM((DATEDIFF(second, [login_time], logout_time)/60.0/60.0)-3.0)AS [Expected Time]
  FROM [PH_PROD].[dbxx].[hi_usr_login] AS A
				INNER JOIN
		[METRICS Reports].[dbo].[PackLanes] AS B
				ON A.[host_name] = B.[host_name]
  WHERE A.[host_name] like 'O2-PACK%'
  AND [logout_time] is not null
  AND [login_time] between @startdate and @enddate and lane is not null
  GROUP BY 
		   [Lane]) as a

JOIN

(SELECT 
	  SUM(cast(slot4 as int))/60.0/60.0 as logged_hrs,
	  ps.lane

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I

       

	   LEFT JOIN
	   [METRICS Reports].[dbo].[PackLanes] AS PS
	   on PS.[Pack Station] = location_id_from

	   WHERE 
     CAST(I.activity_date AS date)                 
              between cast(@StartDate as date) and cast(@enddate as date)
              AND 
		if_tran_code in ('SHP-CART','SHIP-PACK','SHP-CARTQ', 'SHIP-PACKQ')

	    group by ps.lane) as b
		on a.lane = b.lane
		order by lane






