WITH RawData AS (SELECT
	CAST(date_ordered AS DATE) AS [Date],
	order_id,
	tot_to_pick
FROM PH_PROD.dbxx.hi_orders ho
WHERE CAST(date_ordered AS DATE) BETWEEN '01/01/14' AND '12/31/14'
UNION ALL
SELECT
	CAST(date_ordered AS DATE) AS [Date],
	order_id,
	tot_to_pick
FROM PH_ANCIENT_PROD.dbxx.hi_orders ho
WHERE CAST(date_ordered AS DATE) BETWEEN '01/01/14' AND '12/31/14')

SELECT
	Date,
	COUNT(order_id) AS Orders,
	SUM(tot_to_pick) AS Units,
	CAST(SUM(tot_to_pick)AS DECIMAL)/CAST(COUNT(order_id) AS DECIMAL) AS UnitsperOrder
FROM RawData rd
GROUP BY rd.[Date]
ORDER BY UnitsperOrder
	