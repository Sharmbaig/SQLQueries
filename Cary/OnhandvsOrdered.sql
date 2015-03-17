SELECT
	Inventory.item_id,
	OH,
	ISNULL(Units,0) AS Sold,
	OH-ISNULL(Units,0) AS Available,
	CASE WHEN OH = 0 
	THEN 0 
	ELSE CAST(ISNULL(Units,0) AS DECIMAL)/CAST(OH AS DECIMAL) 
	END AS [%ofOH],
	CASE WHEN OnlyPTL.item_id IS NOT NULL
	THEN 'Y'
	ELSE 'N'
	END AS PTL_Only
FROM
/*Available Inventory*/
(SELECT
	item_id,
	SUM(pieces_onhand)-SUM(pieces_hard)-SUM(pieces_onhold) AS OH
FROM PH_PROD.dbxx.item_location
GROUP BY item_id)AS Inventory
LEFT JOIN
/*Gets current open sales*/
(SELECT 
	item_id,
	SUM(pieces_ordered) AS [Units]
FROM PH_PROD.dbxx.order_lines
WHERE order_id IN
(SELECT 
order_id 
FROM PH_PROD.dbxx.orders o
WHERE order_status = 010)
GROUP BY item_id) AS Sales
On Inventory.item_id = Sales.item_id
LEFT JOIN
/*this is for finding items only in PTL locations*/ 
(SELECT DISTINCT
	item_id
FROM 
(SELECT
	item_id,
	SUM(pieces_onhand) - SUM(pieces_onhold) AS OH
FROM PH_PROD.dbxx.item_location il
WHERE location_type != 'PTL'
GROUP BY il.item_id
HAVING SUM(pieces_onhand) - SUM(pieces_onhold) =0) AS X) AS OnlyPTL
On Inventory.item_id = OnlyPTL.item_id