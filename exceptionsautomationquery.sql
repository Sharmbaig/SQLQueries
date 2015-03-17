
SELECT D.[PickerAccount],A.[Total Pieces], A.[Number of Orders], C.[Orders Affected], (CAST(C.[Orders Affected] AS DECIMAL)/ CAST(A.[Number of Orders]AS DECIMAL))AS [Error Rate] FROM
(SELECT 
		
		E.[exception_type]
		,COUNT(E.[exception_type])AS [Number of Exceptions]
		,P.PickerName AS [PickerAccount]
	FROM 
		[PH_PROD].[dbxx].[exceptions2] AS E
			INNER JOIN
		[PH_PROD].[dbxx].[usrs] AS U
			ON E.[usr_id] = U.[usr_id]
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON (E.[order_id] = T.[order_id] AND E.[item_id] = T.[item_id])
			INNER JOIN
		[LPPick].[dbo].[Pickers] AS P ON T.usr_id = P.PickerBarCode
	
	WHERE 
		E.[screen_id] = 'W_CARTON_PICKVERIFY_SHIP_POP_EXCEPTION'
			AND

		E.[exception_type] not in ('PACKER', 'DEFECTIVE', 'INVENTORY')
		AND CAST(E.[activity_date] AS DATE) = CAST(GETDATE() AS DATE)
	GROUP BY	E.[exception_type]
				,P.PickerName)AS D
				INNER JOIN	

(SELECT  
       P.[PickerName] as [PickerAccount]
      ,COUNT(R.[order_id]) AS [Number of Orders]
	  ,SUM(I.[pieces]) AS [Total Pieces]
  FROM	[PH_PROD].[dbxx].[if_transaction] AS I
			JOIN [LPPick].[dbo].[Pickers]AS P
			ON I.[usr_id] = P.[PickerBarCode]
			JOIN [PH_PROD].[dbxx].[if_transaction] AS R
			ON R.[order_id] = I.[order_id]
  WHERE 
		 I.[if_tran_code] = 'POP-PICK'
		 AND R.[if_tran_code] = 'VERIFY'
AND CAST(I.[activity_date] AS DATE) = CAST(GETDATE() AS DATE)
  GROUP BY	I.[usr_id],
			P.[PickerName])AS A 
			ON D.[PickerAccount] = A.[PickerAccount]
					INNER JOIN       

(SELECT 
		P.PickerName AS [PickerAccount]
		,COUNT(DISTINCT E.[order_id]) AS [Orders Affected]
FROM 
		[PH_PROD].[dbxx].[exceptions2] AS E
			INNER JOIN
		[PH_PROD].[dbxx].[usrs] AS U
			ON E.[usr_id] = U.[usr_id]
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON (E.[order_id] = T.[order_id] AND E.[item_id] = T.[item_id])
         INNER JOIN
		  [LPPick].[dbo].[Pickers] AS P ON T.usr_id = P.PickerBarCode
	
	WHERE 
		E.[screen_id] = 'W_CARTON_PICKVERIFY_SHIP_POP_EXCEPTION'
		AND E.[exception_type] not in ('PACKER', 'DEFECTIVE', 'INVENTORY')
		AND CAST(E.[activity_date] AS DATE) = CAST(GETDATE() AS DATE)
	GROUP BY	
				P.PickerName) AS C  
								ON C.PickerAccount =A.PickerAccount			  
	ORDER BY [Error Rate] DESC
