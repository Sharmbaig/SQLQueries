SELECT
    A.*,
    B.Orders,
    CAST(A.[Orders Affected] AS DECIMAL)/CAST(B.[Orders] AS DECIMAL) AS [Error Rate]
FROM
(SELECT
    CAST(B.activity_date as DATE) AS [Date],
    COUNT(DISTINCT A.order_id) AS [Orders Affected]
FROM PH_PROD.dbxx.exceptions2 AS A
	   INNER JOIN
    PH_PROD.dbxx.if_transaction AS B
	   ON A.order_id = B.order_id
WHERE CAST(B.activity_date AS DATE) >= '12/01/14'
AND requester  like 'T8%'
AND if_tran_code = 'POP-PICK'
GROUP BY CAST(B.activity_date AS DATE)) AS A
INNER JOIN

(SELECT 
    CAST(activity_date AS DATE)AS [Date],
    COUNT(DISTINCT order_id) AS [Orders]
FROM PH_PROD.dbxx.if_transaction
WHERE if_tran_code = 'POP-PICK' AND CAST(activity_date AS DATE) >= '12/01/14'
AND requester  like 'T8%'
and order_id in
(SELECT
    order_id
FROM PH_PROD.dbxx.if_transaction
WHERE if_tran_code = 'VERIFY')
GROUP BY CAST(activity_date as DATE))AS B
ON A.[Date] = B.[Date]