/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	Starting.item_id,
	Starting.OH AS Starting,
	Adj.AdjustmentsMade AS CountofAdjustments,
	Adj.TotalPieces AS TotalAmountAdj,
	Pick.Units AS Picks,
	Ending.OH AS Ending
FROM
(SELECT 
       [item_id]
      ,SUM([Pieces on Hand]) AS OH
  FROM [Metrics Reports].[dbo].[InventoryOnHand]
  WHERE CAST([Date]AS DATE) = '01/05/15'
  GROUP BY item_id) AS Starting
LEFT JOIN
(SELECT 
       [item_id]
      ,SUM([Count of Adjustments]) AS AdjustmentsMade
      ,SUM([Pieces]) AS TotalPieces
  FROM [Metrics Reports].[dbo].[view_adjustmentsdetail]
  WHERE CAST(activity_date AS DATE) ='01/05/15'
  GROUP BY item_id) AS Adj
  ON Starting.item_id = Adj.item_id
LEFT JOIN
(SELECT
	item_id,
	SUM(pieces) AS Units
FROM PH_PROD.dbxx.if_transaction 
WHERE CAST(activity_date AS DATE) = '01/05/15'
AND if_tran_code = 'POP-PICK'
GROUP BY item_id) as Pick
ON Starting.item_id = Pick.item_id
LEFT JOIN
(SELECT 
       [item_id]
      ,SUM([Pieces on Hand]) AS OH
  FROM [Metrics Reports].[dbo].[InventoryOnHand]
  WHERE CAST([Date]AS DATE) = '01/06/15'
  GROUP BY item_id) AS Ending
ON Starting.item_id = Ending.item_id