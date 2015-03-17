SELECT
	A.[Month]
	,A.[Total Orders Affected]
	,B.[Total Inspected Orders]
	,CAST(A.[Total Orders Affected] AS DECIMAL)/CAST(B.[Total Inspected Orders] AS DECIMAL) AS [Error Rate]
FROM
(SELECT
	DATENAME(month,date_shipped) AS [Month]
	,COUNT(distinct [Original Order ID]) AS [Total Orders Affected]
FROM [Metrics Reports].[dbo].[reships] AS A
			INNER JOIN
	 [PH_PROD].[dbxx].[hi_orders] AS B
			ON A.[Original Order ID] = B.[po_num]
WHERE B.[order_id] in (SELECT
order_id
FROM PH_PROD.dbxx.if_transaction
WHERE if_tran_code = 'VERIFY')
AND CAST(date_shipped AS DATE) >= '01/01/14'
AND [Reship Reason] in ('Missing Product','Wrong Item Received','Shipment Never Received')
GROUP BY DATENAME(month,date_shipped)) AS A
		INNER JOIN
(SELECT
	DATENAME(month,activity_date) AS [Month]
	,COUNT(distinct order_id) AS [Total Inspected Orders]
FROM [PH_PROD].[dbxx].[if_transaction]
WHERE if_tran_code = 'VERIFY'
AND CAST(activity_date AS DATE) >= '01/01/14'
GROUP BY DATENAME(month,activity_date)) AS B
		ON A.[Month] = B.[Month]
