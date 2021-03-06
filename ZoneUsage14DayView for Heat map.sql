
WITH ZoneMap AS 
(SELECT TOP (100) PERCENT 
			location_id_from, 
			SUM(pieces) AS TotalPieces, 
			SUBSTRING(location_id_from, 1, 1) AS Aisle, 
			SUBSTRING(location_id_from, 3, 1) AS Bay, 
			SUBSTRING(location_id_from, 1, 3) AS AisleBay, 
			CASE WHEN SUBSTRING(location_id_from, 3, 1) = 'A' OR
                       SUBSTRING(location_id_from, 3, 1) = 'E' 
								THEN SUBSTRING(location_id_from, 1, 1) + '1' 
					   WHEN SUBSTRING(location_id_from, 3, 1) = 'B' OR
                       SUBSTRING(location_id_from, 3, 1) = 'F' 
								THEN SUBSTRING(location_id_from, 1, 1) + '2' 
					   WHEN SUBSTRING(location_id_from, 3, 1) = 'C' OR
                       SUBSTRING(location_id_from, 3, 1) = 'G' 
								THEN SUBSTRING(location_id_from, 1, 1) + '3' 
					   WHEN SUBSTRING(location_id_from, 3, 1) = 'D' OR
                       SUBSTRING(location_id_from, 3, 1) = 'H' 
								THEN SUBSTRING(location_id_from, 1, 1)  + '4' 
					   END AS AisleZone
                       FROM            PH_PROD.dbxx.if_transaction AS if_transaction
                       WHERE        (CAST(activity_date AS date) BETWEEN CAST(GETDATE() - 14 AS date) AND CAST(GETDATE() AS date)) AND (order_id IS NOT NULL) AND (if_tran_code = 'POP-PICK') AND 
                                                                    (SUBSTRING(location_id_from, 2, 1) = '-')
                       GROUP BY location_id_from
                       ORDER BY location_id_from)
 SELECT
     Zone.Aisle
	 ,Zone.Zone
	 ,ROUND(CAST(Zone.[Units]AS FLOAT)/CAST(Total.[Units]AS float),3) AS Percentage
 FROM
(SELECT
		 Aisle
		,SUBSTRING([AisleZone],2,1)AS [Zone]
		,SUM([TotalPieces])AS [Units]
FROM ZoneMap
GROUP BY
		Aisle,
		SUBSTRING([AisleZone],2,1)) AS Zone
		INNER JOIN

   (SELECT
		 Aisle
		,SUM([TotalPieces])AS [Units]
FROM ZoneMap
GROUP BY
		Aisle) AS Total
	ON Zone.[Aisle] = Total.[Aisle]
 