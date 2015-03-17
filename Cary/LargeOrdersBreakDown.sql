DECLARE @Order AS INT;
SET @Order = ''

SELECT
	order_id
	,item_class
	,COUNT(A.item_id) AS [Number of Lines]
	,SUM(pieces_ordered) AS Units
FROM PH_PROD.dbxx.order_lines AS A
		INNER JOIN
	 PH_PROD.dbxx.item_master AS B
		ON A.item_id = B.item_id
WHERE order_id = @Order
GROUP BY order_id, item_class