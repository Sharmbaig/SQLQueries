/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
		CAST([login_time]AS DATE) AS [date]
		,avg(DATEDIFF(minute,[login_time],[logout_time])/60.0) AS [Expected Hours]
  FROM [PH_PROD].[dbxx].[hi_usr_login]
  WHERE CAST([login_date] AS DATE) > '03/31/14'
  AND CAST(login_time AS TIME) between '08:00:00' and '11:00:00'
  AND [host_name] like 'O2-P%'
  GROUP BY CAST(login_time AS DATE)