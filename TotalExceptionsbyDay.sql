SELECT 
	[Orders].[Date]
	,(CAST(Exceptions.Orders AS FLOAT)/CAST(Orders.[Total Orders] AS FLOAT)) AS [Error Rate]
	,[Orders].[Total Orders]
	,[Orders].[Total Units]
	,[Exceptions].[Orders]
	,[Exception Units].[Units]
	,Wrong.[Wrong]
	,Missing.[Missing]
	,Extra.[Extra Item]
	,Defective.[Defective]
	,[Inventory].[Inventory]
FROM
(SELECT
	CAST(O.[date_shipped]AS Date) AS [Date]
	,COUNT(O.order_id) AS [Total Orders]
	,SUM(O.tot_to_pick) AS [Total Units]
FROM [PH_PROD].[dbxx].[hi_orders] AS O
WHERE CAST(O.[date_shipped]AS DATE) >= '01/01/14'
GROUP BY CAST(O.[date_shipped]AS Date))AS [Orders]
	INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(DISTINCT order_id)AS [Orders]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
GROUP BY CAST([activity_date] AS DATE) )AS [Exceptions]
		ON [Orders].[Date] = Exceptions.[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(order_id)AS [Units]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
GROUP BY CAST([activity_date] AS DATE) )AS [Exception Units]
ON [Exceptions].[Date] = [Exception Units].[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(exception_type)AS [Wrong]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
AND exception_type = 'WRONG ITEM'
GROUP BY CAST([activity_date] AS DATE) )AS Wrong
	ON Orders.[Date] = Wrong.[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(exception_type)AS [Missing]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
AND exception_type = 'MISSING'
GROUP BY CAST([activity_date] AS DATE) )AS Missing
	ON Orders.[Date] = Missing.[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(exception_type)AS [Extra Item]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
AND exception_type = 'EXTRA ITEM'
GROUP BY CAST([activity_date] AS DATE) )AS Extra
	ON Orders.[Date] = Extra.[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(exception_type)AS [Defective]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
AND exception_type = 'DEFECTIVE'
GROUP BY CAST([activity_date] AS DATE) )AS Defective
	ON Orders.[Date] = Defective.[Date]
INNER JOIN
(SELECT
		CAST([activity_date] AS DATE)AS [Date]
		,COUNT(exception_type)AS [Inventory]
FROM [PH_PROD].[dbxx].[exceptions2]
WHERE CAST([activity_date] AS DATE) >= '01/01/14'
AND exception_type = 'INVENTORY'
GROUP BY CAST([activity_date] AS DATE) )AS Inventory
	ON Orders.[Date] = Inventory.[Date]

