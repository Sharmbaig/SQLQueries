SELECT
		
		 V.[Date]
		,V.[Verified]
		,N.[Not Verified]
		,(S.[Shipped Orders] -V.[Verified]-N.[Not Verified]) AS [Orders Without Errors]
		,A.[Verified Shipped Orders]
		,B.[Non Verified Shipped Orders]
FROM
(SELECT 
		
		CAST(T.activity_date AS DATE) AS [Date]
		,count( R.[order_id])AS Verified
FROM	[PH_PROD].[dbxx].[if_transaction]AS T
				INNER JOIN
		[METRICS_SUMMARIES].[dbo].[RMA] AS R
				ON t.[order_id] = r.[Order_id]
WHERE [if_tran_code] = 'VERIFY'
GROUP BY
		CAST(T.activity_date AS DATE)) AS V

		INNER JOIN

(SELECT
		
		CAST(T.activity_date AS DATE) AS [Date]
		,count(R.[order_id])AS [Not Verified]
FROM	[PH_PROD].[dbxx].[if_transaction]AS T
				INNER JOIN
		[METRICS_SUMMARIES].[dbo].[RMA] AS R
				ON t.[order_id] = r.[Order_id]
WHERE [if_tran_code] = 'VERIFY-Q'
GROUP BY
		
		CAST(T.activity_date AS DATE)) AS N

		ON v.[Date] = N.[Date]
		
		INNER JOIN

(SELECT 
		CAST([date_shipped] AS DATE) AS [Date]
		,COUNT([order_id])AS [Shipped Orders]
FROM [PH_PROD].[dbxx].[hi_orders]
GROUP BY
	CAST([date_shipped] AS DATE))AS S

		ON v.[Date] = S.[Date]
		
		INNER JOIN

(SELECT 
		CAST(O.[date_shipped] AS DATE) AS [Date]
		,COUNT(T.[order_id])AS [Verified Shipped Orders]
FROM	[PH_PROD].[dbxx].[hi_orders] AS O
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON O.[order_id] = T.[order_id]
WHERE t.[if_tran_code] = 'VERIFY'
GROUP BY
	CAST([date_shipped] AS DATE))AS A
	ON v.[date] = a.[Date]

		INNER JOIN

(SELECT 
		CAST(O.[date_shipped] AS DATE) AS [Date]
		,COUNT(T.[order_id])AS [Non Verified Shipped Orders]
FROM	[PH_PROD].[dbxx].[hi_orders] AS O
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON O.[order_id] = T.[order_id]
WHERE t.[if_tran_code] = 'VERIFY-Q'
GROUP BY
	CAST([date_shipped] AS DATE))AS B

	ON v.[date] = B.[Date]

ORDER BY V.[Date]