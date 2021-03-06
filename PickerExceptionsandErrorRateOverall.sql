
SELECT 
	 A.[Date]
	,A.[PickerName]
	,A.[Total Orders Affected]
	,B.[Number of Orders]
	,(CAST(A.[Total Orders Affected]AS DECIMAL)/CAST(B.[Number of Orders] AS DECIMAL)) AS [Error Rate]
FROM 
(SELECT
       CAST(E.[activity_date] AS DATE) AS [Date]
	   ,P.[PickerName]
      ,COUNT(DISTINCT E.[order_id]) AS [Total Orders Affected]
  FROM [PH_PROD].[dbxx].[exceptions2] AS E
			INNER JOIN
		[PH_PROD].[dbxx].[usrs] AS U
			ON E.[usr_id] = U.[usr_id]
			INNER JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
			ON (E.[order_id] = T.[order_id] AND E.[item_id] = T.[item_id])
			INNER JOIN
		[LPPick].[dbo].[Pickers] AS P ON T.usr_id = P.PickerBarCode
		WHERE [exception_type] not in ( 'DEFECTIVE','PACKER','INVENTORY')
GROUP BY 
		 CAST(E.[activity_date] AS DATE)
	   ,P.[PickerName]) AS A
	   INNER JOIN 
	   (SELECT  
       P.[PickerName] as [PickerAccount]
	   ,CAST(I.activity_date AS DATE) AS [Date]
      ,COUNT(I.[order_id]) AS [Number of Orders]
  FROM	[PH_PROD].[dbxx].[if_transaction] AS I
			JOIN [LPPick].[dbo].[Pickers]AS P
			ON I.[usr_id] = P.[PickerBarCode]
  WHERE 
		 I.[if_tran_code] = 'POP-PICK'

  GROUP BY	I.[usr_id],
			P.[PickerName]
			,CAST(I.activity_date AS DATE)) AS B
			ON A.[PickerName] = B.[PickerAccount] AND A.[Date] = B.[Date]