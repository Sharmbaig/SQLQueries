SELECT
	   I.activity_date , 
	   I.item_id , 
	   M.item_class , 
	   I.if_tran_code , 
	   I.screen_id , 
	   COUNT( I.if_tran_code
			)AS [Count of Adjustments] , 
	   CASE
	   WHEN SUBSTRING( I.item_id , 1 , 2
					 )IN( 'CH' , 'CN' , 'BZ' , 'DG' , 'LK' , 'PG' , 'PR' , 'PS' , 'HP' , 'ER' , 'HE' , 'TA' , 'EE' , 'CE' , 'WN' , 'BR'
						)THEN 'Jewelry'
	   WHEN SUBSTRING( I.item_id , 1 , 2
					 )IN( 'SA' , 'VT' , 'DS'
						)THEN 'Business Materials'
		   ELSE 'Raw Components/Misc'
	   END AS Category , 
	   CASE
	   WHEN sign_code = '-' THEN CAST( -pieces AS int
									 )
		   ELSE CAST( pieces AS int
					)
	   END AS Pieces
  FROM
	  PH_PROD.dbxx.if_transaction AS I
	  INNER JOIN
	  PH_PROD.dbxx.item_master AS M
	  ON I.item_id
		 = 
		 M.item_id
  WHERE CAST( I.activity_date AS date
			)
		>= 
		'01/01/14'
	AND I.if_tran_code IN( 
						   SELECT
								  if_tran_code
							 FROM dbo.adjustmenttrancodes
							 WHERE if_tran_code NOT IN( 'MERGE-INC' , 'MERGE-DEC'
													  )
						 )
  GROUP BY
		   I.activity_date , 
		   I.item_id , 
		   M.item_class , 
		   I.if_tran_code , 
		   I.screen_id , 
		   I.sign_code , 
		   I.pieces;