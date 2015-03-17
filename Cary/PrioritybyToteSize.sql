 WITH [Priority] ([PickOrderId],[Lane],[Total Picks],[Priority]) AS 
 (SELECT TOP 100
      [PickOrderId]
      ,SUBSTRING([LocationBarCode],1,1) AS [Lane]
      ,SUM([PickOrderQty]) AS [Total Picks]
	  ,ROW_NUMBER() OVER(Order BY SUM([PickOrderQty])) AS [Priority]
  FROM [LPPick].[dbo].[PickLines]
  WHERE CAST(PickLineSubmitTime AS DATE) = CAST(GETDATE() AS DATE)
  AND SUBSTRING([LocationBarCode],1,1) = 'D'
  GROUP BY [PickOrderId]
      ,SUBSTRING([LocationBarCode],1,1))

UPDATE [LPPick].[dbo].[PickOrders]
SET [PickOrderPriorityClass] = (SELECT [Priority] FROM [Priority]
WHERE PickOrderId in (Select [PickOrderId] FROM [Priority]))
WHERE [PickOrderId] in (Select [PickOrderId] FROM [Priority])