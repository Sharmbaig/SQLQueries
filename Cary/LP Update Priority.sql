UPDATE LPPick.dbo.PickOrders
SET
    LPPick.dbo.PickOrders.PickOrderPriorityClass = 1 -- int
WHERE PickORderId IN(
SELECT PickOrderId 
FROM LPPick.Dbo.PickLines
WHERE SecondaryLocationName
IN (
--PASTE Order Numbers Here
))