SELECT
	Starting.item_id,
	Starting.OH AS Starting,
	ISNULL(Adj.Adj,0)AS Adjusted,
	Starting.OH + ISNULL(Adj.Adj,0) AS Expected,
	ISNULL(Ending.OH,0) AS Ending
FROM
(SELECT
	item_id,
	SUM(ioh.[Pieces on Hand]) AS OH
FROM [Metrics Reports].dbo.InventoryOnHand ioh
WHERE CAST(Date AS DATE) = '01/03/15'
GROUP BY ioh.item_id) AS Starting
LEFT JOIN

(SELECT
	item_id,
	SUM(ioh.[Pieces on Hand]) AS OH
FROM [Metrics Reports].dbo.InventoryOnHand ioh
WHERE CAST(Date AS DATE) = '02/01/15'
GROUP BY ioh.item_id) AS Ending
ON Starting.item_id = Ending.item_id
LEFT JOIN
(SELECT
	item_id,
	SUM(pieces)AS Adj
FROM
(SELECT
	item_id,
	if_tran_code,
	CASE WHEN sign_code = '-'
		THEN -pieces
		ELSE pieces
		END AS pieces
FROM PH_PROD.dbxx.if_transaction it
WHERE CAST(activity_Date AS DATE) BETWEEN '01/03/15' AND '01/31/15'
AND if_tran_code IN ('REC-INC','REC-DEC','KIT-RAW','KIT-BUILD','CY-INC','CY-DEC','POP-PICK','CUT','INC','DEC','CHG-DEC','CHG-INC','FND-CNT','CUT-PICKED'
,'KIT-EXPAND','LST-CNT','REC','KIT-FG'))AS A
GROUP BY item_id)AS Adj
ON Starting.item_id = Adj.item_id