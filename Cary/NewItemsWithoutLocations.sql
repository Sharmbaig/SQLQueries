SELECT 
	B.item_id
	,A.[location_id]
	,B.[Total Orders]
FROM
(SELECT 
	item_id
	,location_id
FROM PH_PROD.dbxx.item_location
WHERE location_type = 'PTL')AS A
RIGHT JOIN

(SELECT DISTINCT
	item_id
	,COUNT(DISTINCT A.order_id) AS [Total Orders]
FROM PH_PROD.dbxx.order_lines AS A
			INNER JOIn
	PH_PROD.dbxx.orders AS B
			ON A.order_id = B.order_id			
WHERE B.[po_num] like 'R%'
AND item_id not like 'KT%'
AND item_id not like 'SA%'
AND item_id <> 'OVERAGE'
AND item_id not like 'PG8%'
GROUP BY item_id) AS B
ON A.item_id = B.item_id
WHERE location_id is null
ORDER BY [Total Orders] DESC