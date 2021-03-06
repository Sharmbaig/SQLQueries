
SELECT
	B.[order_id]
	,B.[item_id]
	,B.[location_id_from]
	,A.[exception_type]
	,A.[New Item]
	,C.[location_id]
FROM 
(SELECT  
      A.[activity_date]
      ,[exception_type]
      ,SUBSTRING([exception_text],11,6) AS[New Item]
      ,A.[item_id]
      ,A.[order_id]
	  ,B.[location_id_from]
  FROM [PH_PROD].[dbxx].[exceptions2]AS A
				INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS B
				On A.[order_id] = B.[order_id]
				AND A.[item_id] = B.[item_id]
  WHERE CAST(B.[activity_date] AS DATE) = CAST(GETDATE()AS DATE)
  AND A.screen_id LIKE 'W_CARTON%'
  AND if_tran_code = 'POP-PICK')AS A
		RIGHT JOIN
 (SELECT 
		[order_id]
		,[item_id]
		,[location_id_from]
FROM [PH_PROD].dbxx.[if_transaction]
WHERE CAST(activity_date as DATE) = CAST(GETDATE() AS DATE)
AND if_tran_code = 'POP-PICK' AND [order_id] in (SELECT order_id FROM [PH_PROD].[dbxx].[exceptions2] 
WHERE CAST(activity_date AS DATE)=CAST(getdate()AS DATE))) AS B
		ON B.[order_id] = A.[order_id]
		AND B.[item_id] = A.[item_id]
		LEFT JOIN
(SELECT [item_id]
		,[location_id]
FROM [PH_PROD].[dbxx].[item_location]
WHERE SUBSTRING(location_id,1,2) in ('A-','B-','C-','D-','E-','F-','G-','H-')) AS C
		ON A.[New Item] = C.[item_id]
		AND substring(A.location_id_from,1,2) = substring(C.location_id,1,2)
  
