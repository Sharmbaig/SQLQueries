DECLARE @StartDate AS DATETIME,@EndDate AS DATETIME;
SET @StartDate = '06/17/14 01:00:00'
SET @EndDate = '06/17/14 23:30:00';

WITH ACT as (
SELECT 
	[full_name],
	location_id_from as [Pack Station]
	,ISNULL([Hours],0)AS[Hours]
	,[Total Orders]AS [Orders]
	,ISNULL([Total Units],0)AS [Units]
    ,ISNULL([Total Units],0)/[Hours] as PerHour
FROM(
SELECT  
       U.[full_name],
	   i.location_id_from
      ,SUM(CONVERT(int,[SLOT0])) AS [Total Orders]
      ,SUM(CONVERT(INT,[SLOT1])) AS [Total Units]
      ,SUM(cast([SLOT4]as int))/60.0/60.0 AS [Hours]

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
      CAST(SUBSTRING(CAST([activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST([Activity_time] AS VARCHAR(50)),1,12)AS DATETIME)                 
              between @StartDate and @EndDate
              AND 
		[if_tran_code] in ('SHP-CART','SHIP-PACK','SHP-CARTQ', 'SHIP-PACKQ')
GROUP BY 
       U.full_name, i.location_id_from
	   ) as G),

EPT as (SELECT  
		USr_ID,
		[Lane]
		
      ,SUM((DATEDIFF(second, [login_time], logout_time)/60.0/60.0)-3.0)AS [Expected Time]
  FROM [PH_PROD].[dbxx].[hi_usr_login] AS A
				INNER JOIN
		[METRICS_SUMMARIES].[dbo].[PackLanes] AS B
				ON A.[host_name] = B.[host_name]
  WHERE A.[host_name] like 'O2-PACK%'
  AND [logout_time] is not null
  AND [login_time] between @startdate and @enddate and lane is not null
  GROUP BY 
		   [Lane], usr_id)


SELECT
a.lane,
a.[expected time],
b.logged_hrs
FROM
(SELECT
lane,
SUM([expected time]) as [expected time]
FROM
	EPT
	GROUP BY lane )as a

JOIN

(SELECT 
	  SUM(hours) as logged_hrs,
	  ps.lane 
FROM 
       ACT AS I
	   LEFT JOIN
	   [METRICS_SUMMARIES].[dbo].[PackLanes] AS PS
	   on PS.[Pack Station] = i.[pack station]
	    group by ps.lane) as b
		on a.lane = b.lane