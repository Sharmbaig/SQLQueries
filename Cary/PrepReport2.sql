SELECT 
    B.item_class
	,A.item_id
	,B.description
	,CASE WHEN A.item_id in (SELECT item_id FROM [Metrics Reports].dbo.FallSkus)
		  THEN 'Fall'
		  Else 'Old'
		  END AS [Type]
	,A.[Total Orders] AS [Total Sales]
	,
	,ISNULL(Picking.[Total Available],0)+ISNULL(LM.[Total Available],0)+ISNULL(UM.[Total Available],0) AS [Completed]
FROM
(SELECT 
      A.[item_id]
	  ,SUM(pieces_ordered) AS [Total Orders]
  FROM [PH_PROD].[dbxx].[order_lines]AS A
  GROUP BY A.[item_id])AS A
  LEFT JOIN
  (SELECT
	item_id
	,(sum(pieces_onhand)-SUM(pieces_onhold)) AS [Total Available]
FROM PH_PROD.dbxx.item_location
WHERE location_type = 'PTL'
GROUP BY item_id) AS [Picking]
	ON A.[item_id]= [Picking].item_id
LEFT JOIN
(SELECT
	item_id
	,(sum(pieces_onhand)-SUM(pieces_onhold)) AS [Total Available]
FROM PH_PROD.dbxx.item_location
WHERE substring(location_id,1,2) = 'UM'
GROUP BY item_id) AS [UM]
ON A.item_id = UM.item_id
LEFT JOIN
(SELECT
	item_id
	,(sum(pieces_onhand)-SUM(pieces_onhold)) AS [Total Available]
FROM PH_PROD.dbxx.item_location
WHERE substring(location_id,1,2) = 'LM'
GROUP BY item_id) AS [LM]
	ON A.item_id = LM.item_id
	INNER JOIN
PH_PROD.dbxx.item_master AS B
	ON A.item_id = B.item_id
WHERE item_class in ('LOCKETS','BEZZLES','EARRINGS')
OR A.item_id like 'CR%'
OR A.item_id in ('CN7030','CN5030')
ORDER BY [Type] ASC,[Total Sales] DESC

