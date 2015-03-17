SELECT 
      T.[item_id]
      ,SUM(T.[pieces]) AS [Total Picks]
         ,O.[order_type]
FROM [PH_PROD].[dbxx].[if_transaction] AS T
  LEFT JOIN [PH_PROD].[dbxx].[hi_orders] AS O
  ON T.[order_id] = O.[order_id]
WHERE T.[if_tran_code] = 'POP-PICK'
  AND CAST(T.[activity_date] AS DATE) Between '01/12/14' and '01/18/14'
GROUP BY T.[item_id]
              ,O.[order_type]
ORDER BY [Total Picks] Desc




