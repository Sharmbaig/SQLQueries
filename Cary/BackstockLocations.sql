SELECT
	item_id
	,[Total BackStock]
	,CASE WHEN [Total BackStock] <= 100
			THEN 'URGENT'
			WHEN [Total BackStock] between 101 and 500
			THEN 'Needs Stock'
			WHEN [Total BackStock] >= 501
			THEN 'Good Stock'
			END AS [Stock Priority]
FROM 
(SELECT
	item_id
	,SUM(pieces_onhand) AS [Total BackStock]
FROM PH_PROD.dbxx.item_location
WHERE location_type = 'PTL-RESTK'
AND item_id not like 'KT%'
GROUP BY [item_id]) AS A
ORDER BY [Total BackStock]