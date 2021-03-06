SELECT
			INS.Date,
			INS.Lane,
			Errors.Orders AS Errors,
			INS.Orders AS Picked,
			CAST(Errors.Orders AS DECIMAL)/CAST(INS.orders AS DECIMAL) AS ErrorRate
FROM
(SELECT
			CAST(e.activity_date AS DATE) AS [Date],
			SUBSTRING(location_id_from,1,1) AS [Lane],
			COUNT(DISTINCT e.order_id)AS Orders
FROM PH_PROD.dbxx.exceptions2 e
					INNER JOIN
			PH_PROD.dbxx.if_transaction it
					ON e.order_id = it.order_id
WHERE if_tran_code  =  'POP-PICK'
and CAST(e.activity_date AS DATE)  >= '2015-01-01'
GROUP by CAST(e.activity_date AS DATE),
			SUBSTRING(location_id_from,1,1)) Errors
RIGHT JOIN
(SELECT
			CAST(activity_date AS DATE) AS [Date],
			SUBSTRING(location_id_from,1,1) AS Lane,
			COUNT(distinct order_id) AS Orders
FROM PH_PROD.dbxx.if_transaction 
WHERE if_tran_code = 'POP-PICK'
AND order_id IN (
SELECT order_id
FROM PH_PROD.dbxx.if_transaction 
WHERE if_tran_code = 'VERIFY')
GROUP BY CAST(activity_date AS DATE),
			SUBSTRING(location_id_from,1,1) ) AS INS
ON Ins.Date = Errors.Date AND INS.Lane = Errors.Lane