DECLARE @wave int;

SET @wave = '';

WITH Orders AS (
SELECT
	A.pick_rule
	,item_id
	,SUM(pieces_ordered) AS Needed
FROM PH_PROD.dbxx.orders AS A
			INNER JOIN
	 PH_PROD.dbxx.order_lines AS B
			ON A.order_id = B.order_id
WHERE wave_seq_num = @wave
GROUP BY A.pick_rule,item_id)

SELECT
	A.item_id
	,ABS((pieces_onhand-pieces_hard)-Needed)
FROM 
	Orders AS A
	INNER JOIN
	PH_PROD.dbxx.item_location AS B
	ON A.item_id = B.item_id AND RIGHT(pick_rule,1) = SUBSTRING(location_id,1,1)
WHERE Needed > (pieces_onhand-pieces_hard)