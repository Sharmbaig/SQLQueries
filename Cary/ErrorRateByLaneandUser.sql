SELECT
	P.Date,
	P.Lane,
	P.usr_id,
	P.Orders,
	ISNULL(Ex.[Orders Affected],0) AS Errors,
	CAST(ISNULL(Ex.[Orders Affected],0) AS DECIMAL)/CAST(P.Orders AS DECIMAL) AS ErrorRate
FROM
(SELECT
	CAST(e.activity_date AS DATE) AS [Date],
	SUBSTRING(location_id_from,1,1) AS Lane,
	it.usr_id,
	COUNT(DISTINCT e.order_id) AS [Orders Affected]
FROM PH_PROD.dbxx.exceptions2 AS e
			INNER JOIN
	PH_PROD.dbxx.if_transaction AS it
			ON e.order_id = it.order_id AND e.item_id = it.item_id
WHERE CAST(e.activity_date AS DATE) = '01/29/15'
AND if_tran_code = 'POP-PICK'
GROUP BY CAST(e.activity_date AS DATE),
	SUBSTRING(location_id_from,1,1),it.usr_id) AS Ex
RIGHT JOIN

(SELECT 
	CAST(activity_date AS DATE) AS [Date],
	SUBSTRING(location_id_from,1,1) AS Lane,
	usr_id,
	COUNT(DISTINCT order_id) AS Orders
FROM PH_PROD.dbxx.if_transaction
WHERE CAST(activity_date AS DATE) = '01/29/15'
and if_tran_code = 'POP-PICK'
AND
order_id IN
(SELECT
	order_id
FROM PH_PROD.dbxx.if_transaction 
WHERE CAST(activity_date AS DATE) = '01/29/15'
AND if_tran_code = 'VERIFY')
GROUP BY CAST(activity_date AS DATE) ,
	SUBSTRING(location_id_from,1,1),usr_id) AS P
ON P.Date = Ex.Date AND P.Lane = Ex.Lane AND P.usr_id = Ex.usr_id
