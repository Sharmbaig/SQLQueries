UPDATE LPPick.dbo.PickOrders
SET PickOrderPriorityClass = 2
WHERE TotalUnits >= 50
and HasBeenInducted = 0
and PickorderId in 
(SELECT   DISTINCT PickOrderId
  FROM [LPPick].[dbo].[PickLines]
  WHERE CAST(PickLineSubmitTime AS DATE) = CAST(GETDATE()AS DATE)
  AND DisplayAttribute NOT lIke '%1%'
  AND DisplayAttribute NOT like '%2%'
  AND SUBSTRING(LocationBarCode,1,1) = '')

