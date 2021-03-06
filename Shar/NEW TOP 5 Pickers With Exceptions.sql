/***Top 5 Exception per Picker***/
DECLARE
		@StartDate AS Date,
		@EndDate AS Date
SET @StartDate = '02/22/2015'
SET @EndDate = '02/28/2015'


SELECT TOP 6


	A.[PickerName]
	,A.[Total Orders Affected]
	,a.[Orders Verified]
	,(CAST(A.[Total Orders Affected]AS DECIMAL)/CAST(a.[Orders Verified] AS DECIMAL)) AS [Error Rate]


FROM(
SELECT 
	A.[PickerName]
	,sum(A.[Total Orders Affected]) as [Total Orders Affected]
	,SUM(T.[Orders Verified]) as [Orders Verified]
FROM 
(SELECT
       CAST(E.[activity_date] AS DATE) AS [Date]
	   ,P.[PickerName]
      ,COUNT(DISTINCT E.[order_id]) AS [Total Orders Affected]
  FROM [PH_PROD].[dbxx].[exceptions2] AS E
			INNER JOIN
		[PH_PROD].[dbxx].[usrs] AS U
			ON E.[usr_id] = U.[usr_id]
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON (E.[order_id] = T.[order_id] AND E.[item_id] = T.[item_id])
			INNER JOIN
		[LPPick].[dbo].[Pickers] AS P 
			ON T.usr_id = P.PickerBarCode
		WHERE [exception_type] not in ( 'DEFECTIVE','PACKER','INVENTORY')
GROUP BY 
		 CAST(E.[activity_date] AS DATE)
	   ,P.[PickerName]) AS A
LEFT JOIN
			
(SELECT
		COUNT([if_tran_code]) AS [Orders Verified]
		,CAST([activity_date] AS DAte) AS [Date]

FROM 
		[PH_PROD].dbxx.[if_transaction] AS A

WHERE [if_tran_code] = 'Verify'

Group BY 
		CAST(activity_date AS Date) ) AS T

ON A. Date = T.Date

WHERE 
		CAST(a.date AS date) BETWEEN @StartDate AND @EndDate
GROUP BY A.[PickerName]) as a

order by  [Error Rate] DESC 