DECLARE @StartDate AS DATETIME
DECLARE @EndDate AS DATETIME
SET @StartDate = '04/15/14 10:30'
SET @EndDate = '04/15/14 19:30'


SELECT 
	[Shipped Inspected].[full_name]
	,([Shipped Inspected].[Hours]+[Shipped Non Inspected].[Hours]) AS [Total Hours]
	,[Shipped Inspected].[Hours]
	,[Shipped Non Inspected].[Hours]
	,([Inspected].[Total Inspected Orders]+[Not Inspected].[Total Non Inspected Orders]) AS [Total Orders]
	,[Inspected].[Total Inspected Orders]
	,[Not Inspected].[Total Non Inspected Orders]
	,[Shipped Inspected].[Total Inspected Units]
	,[Shipped Non Inspected].[Total Units]AS [Total Non inspected Units]
FROM
(SELECT  
       U.[full_name]
      ,SUM(CONVERT(int,[slot0])) AS [Total Orders]
      ,SUM(CONVERT(INT,[slot2])) AS [Total Inspected Units]
      ,SUM(cast([slot4]as int))/60.0/60.0 AS [Hours]

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
      SUBSTRING(CAST(I.[activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST(I.[activity_time] AS VARCHAR(50)),1,12)                    
              between @StartDate and @EndDate
              AND 
		[if_tran_code] in( 'SHP-CART','SHIP-PACK')
GROUP BY 
       U.full_name) AS [Shipped Inspected]
	   INNER JOIN 
(SELECT  
       U.[full_name]
      ,SUM(CONVERT(int,[slot0])) AS [Total Orders]
      ,SUM(CONVERT(INT,[slot2])) AS [Total Units]
      ,SUM(cast([slot4]as int))/60.0/60.0 AS [Hours]

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
      SUBSTRING(CAST(I.[activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST(I.[activity_time] AS VARCHAR(50)),1,12)                    
              between @StartDate and @EndDate
              AND 
       [if_tran_code] in ('SHP-CARTQ', 'SHIP-PACKQ')
GROUP BY 
       U.full_name)AS [Shipped Non Inspected]
	   ON [Shipped Inspected].[full_name]= [Shipped Non Inspected].[full_name]
	   INNER JOIN
(SELECT
		U.[full_name]
		,COUNT(I.[order_id]) AS [Total Inspected Orders]

FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
		SUBSTRING(CAST(I.[activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST(I.[activity_time] AS VARCHAR(50)),1,12)  
					BETWEEN @StartDate and @EndDate
					AND
		[if_tran_code] = 'VERIFY'
GROUP BY 
       U.full_name) AS [Inspected]
	   ON [Shipped Inspected].full_name = [Inspected].full_name
	   INNER JOIN

(SELECT
		U.[full_name]
		,COUNT(I.[order_id]) AS [Total Non Inspected Orders]

FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
		SUBSTRING(CAST(I.[activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST(I.[activity_time] AS VARCHAR(50)),1,12)  
					BETWEEN @StartDate and @EndDate
					AND
		[if_tran_code] = 'VERIFY-Q'
GROUP BY 
       U.full_name) AS [Not Inspected]
	   ON [Shipped Non Inspected].[full_name] = [Not Inspected].[full_name]
ORDER BY [Shipped Inspected].[full_name]