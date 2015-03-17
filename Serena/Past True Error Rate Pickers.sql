DECLARE @StartDate AS DATE, @EndDate AS DATE, @StartTime AS TIME, @EndTime AS TIME;
SET @StartDate = '08/10/14'
SET @EndDate = '08/16/14'
SET @StartTime = '07:00'
SET @EndTime = '17:00'
SELECT 
       A.[Date]
       ,[Orders Affected]
       ,[Orders]
       ,(CAST([Orders Affected] AS DECIMAL)/CAST([Orders] AS DECIMAL)) AS [Error Rate]
FROM
( SELECT 
              CAST(activity_date AS DATE) AS [Date]
              ,COUNT( DISTINCT [order_id]) AS [Orders Affected] 
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST(activity_date AS DATE) between @StartDate and @EndDate
AND activity_time between @StartTime and @EndTime
GROUP BY CAST(activity_date AS DATE)) AS A
                     INNER JOIN
(SELECT 
       CAST(activity_date AS DATE) AS [Date]
      ,COUNT(DISTINCT[order_id]) AS [Orders]
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE [if_tran_code] = 'VERIFY'
  AND CAST(activity_date AS DATE) between @StartDate and @EndDate
  AND activity_time between @StartTime and @EndTime
  GROUP BY CAST(activity_date AS DATE))AS B
              ON A.[Date] = B.[Date]
