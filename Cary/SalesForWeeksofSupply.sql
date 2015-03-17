SELECT
	A.item_id
	,A.[Total Units Available]
	,[Date]
	,ISNULL(B.[Total Units],0) AS [Sales]
FROM
(SELECT        
	A.item_id, 
	SUM(C.pieces_onhand) AS [Total Units Available] 
 FROM  dbo.FallSkus AS A 
				LEFT OUTER JOIN
    PH_PROD.dbxx.item_location AS C ON A.item_id = C.item_id
	GROUP BY A.item_id)AS A
	LEFT JOIN
(SELECT
     [Date]
    , [item_id]
	 ,[Total Units]
FROM	 dbo.view_totalpicksbyitembyday 
WHERE [Date] between DATEADD(day,-7, CAST(getdate() AS DATE)) and CAST(GETDATE() AS DATE)) AS B
ON A.[item_id] = B.[item_id]