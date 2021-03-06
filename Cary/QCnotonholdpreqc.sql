/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	A.*
	,B.pieces_onhand AS [IN QC]
FROM
(SELECT 
      [item_id]
	  ,location_id
     ,[pieces_onhand]
	 ,[pieces_onhold]
  FROM [PH_PROD].[dbxx].[item_location]
  WHERE item_id in (SELECT item_id 
  FROM [PH_PROD].dbxx.item_location
  WHERE substring(location_id,1,2) = 'QC')
  AND pieces_onhold != pieces_onhand
  AND SUBSTRING(location_id,1,3) in ('S07','S08')) AS A
		INNER JOIN
(SELECT item_id 
,pieces_onhand
  FROM [PH_PROD].dbxx.item_location
  WHERE substring(location_id,1,2) = 'QC')AS B
	ON A.item_id = B.item_id
