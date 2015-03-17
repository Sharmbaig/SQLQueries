

SELECT 
	A.item_id
	,B.location_id
	,pieces_onhand
	,assign_flag
	,SUM(pieces_ordered)
FROM PH_PROD.dbxx.order_lines AS A
			INNER JOIN
	PH_PROD.dbxx.item_location AS B
			ON A.item_id = B.item_id
WHERE B.location_id like 'F-%'
and pieces_onhand <= 50
GROUP BY A.item_id
,B.location_id
	,pieces_onhand
	,assign_flag