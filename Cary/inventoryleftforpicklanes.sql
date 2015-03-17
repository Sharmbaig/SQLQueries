SELECT
	A.item_id
	,A.[Total Units]
	,B.[Available]
	,B.available - A.[Total Units] AS [Inventory Left]
	FROM
(SELECT	
	item_id
	,sum(pieces_ordered) AS [Total Units]
FROM PH_PROD.dbxx.order_lines AS A
			INNER JOIN
	PH_PROD.dbxx.orders AS B
			ON A.order_id = B.order_id
WHERE cast(date_ordered AS DATE) = '08/18/14'
and order_status = '010'
GROUP BY item_id)AS A
	LEFT JOIN
(SELECT
	item_id
	,SUM(pieces_onhand)-(SUM(pieces_onhold)+SUM(pieces_hard)) AS [Available]
FROM PH_PROD.dbxx.item_location
WHERE location_type = 'PTL'
GROUP BY item_id)AS B
ON A.item_id =B.item_id
WHERE available is not null
ORDER BY [Inventory Left]
