/****** Script for SelectTopNRows command from SSMS  ******/
WITH [Locations] AS (SELECT	
	item_id
	,location_id
	,CASE WHEN substring(location_id,1,4) = 'PREP'
			THEN 'PREP'
			WHEN SUBSTRING(location_id,1,3) in ('S01','S02')
			THEN 'Quarantine'
			WHEN SUBSTRING(location_id,1,3) = 'S18'
			THEN 'POST QC/PRE PREP'
			WHEN SUBSTRING(location_id,1,2) = 'QC'
			THEN 'QC'
			WHEN location_type = 'PTL'
			THEN 'On Pick Lines'
			WHEN SUBSTRING(location_id,1,2) in ('LM','UM')
			THEN 'Completed for Backstock'
			WHEN location_id like 'R-%'
			THEN 'Receiving'
			WHEN SUBSTRING(location_id,1,3) in ('S07','S08')
			THEN 'PRE QC'
			WHEN SUBSTRING(location_id,1,3) in ('S24','S25','S26')
			THEN 'POST PREP'
			WHEN location_id in ('FIN PREP','FINPREP')
			THEN 'POST PREP'
			ELSE 'Research'
			END AS [Location Type]
	 ,pieces_onhand
	 ,pieces_onhold
FROM PH_PROD.dbxx.item_location)

SELECT 
	item_id
	,[Location Type]
	,SUM(pieces_onhand) AS [On Hand]
	,SUM(pieces_onhold) AS [On Hold]
FROM Locations
WHERE SUBSTRING(item_id,1,2) in ('CR','BZ','LK','ER')
OR item_id in ('CN7030','CN5030')
GROUP BY item_id,[Location Type]

SELECT 
      A.[item_id]
	  ,SUM(pieces_ordered) AS [Total Orders]

  FROM [PH_PROD].[dbxx].[order_lines]AS A
WHERE SUBSTRING(item_id,1,2) in ('CR','BZ','LK','ER')
OR item_id in ('CN7030','CN5030')
  GROUP BY A.[item_id]
		


 