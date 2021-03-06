SELECT 
		CAST(orderdate AS DATE) AS [Date],
		orderstatusdescription,
		COUNT(DISTINCT o.orderid) AS Orders,
		SUM(quantity) AS Units
FROM Orders  o
			INNER JOIN
			OrderDetails od
				on o.orderid = od.orderid
				INNER JOIN
			OrderStatuses os
					ON o.orderstatusid = os.orderstatusid
WHERE CAST(orderdate as date) >='2015-02-26'
GROUP BY CAST(orderdate AS DATE) ,
		orderstatusdescription
ORDER BY CAST(orderdate AS DATE) ,orderstatusdescription