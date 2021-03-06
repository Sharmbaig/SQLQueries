
SELECT  
		[usr_id]
		,[Lane]
		,[Pack Station]
      ,SUM((DATEDIFF(second, [login_time], logout_time)/60.0/60.0)-3.0)AS [Expected Time]
  FROM [PH_PROD].[dbxx].[hi_usr_login] AS A
				INNER JOIN
		[METRICS_SUMMARIES].[dbo].[PackLanes] AS B
				ON A.[host_name] = B.[host_name]
  WHERE A.[host_name] like 'O2-PACK%'
  AND [logout_time] is not null
  AND [login_time] between '06/10/14 06:00:00' and '06/10/14 16:30:00'
  GROUP BY [usr_id]
		   ,[Lane]
		   ,[Pack Station]