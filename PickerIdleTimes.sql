SELECT TOP 100 PERCENT [PickLines].[PickLineId]
		, [SecondaryLocationName]
		, [PickOrders].[PickOrderId]
		, [PickOrders].[PickOrderSubmitTime]
		, [PickOrderEndTime]
		, [PickOrders].[PickOrderStartTime]
		, [PickLines].[PickCompleteTime]
		, DATEDIFF(MILLISECOND, [PickOrders].[PickOrderStartTime], MAX([PickLines].[PickCompleteTime]) OVER (PARTITION BY [PickLines].[SecondaryLocationName])) AS OrderPickTime
		, DATEDIFF(MILLISECOND, [PickOrders].[PickOrderStartTime], [PickLines].[PickCompleteTime]) AS RTOTItemPickTime
		, DATEDIFF(MILLISECOND, lag([PickCompleteTime]) OVER (PARTITION BY [SecondaryLocationName]
				ORDER BY	[PickCompleteTime]), ([PickCompleteTime])) AS ItemPickTime
		, [PickLines].[PickerId]
		, [PickLines].[PickOrderQty]
		, [PickLines].[ProductBarCode]
		, [PickLines].[PickLineSubmitTime]
FROM            
		[LPPick].[dbo].[PickLines] [PickLines] 
		LEFT OUTER  JOIN
		[LPPick].[dbo].[PickOrders] [PickOrders] 
		ON [PickLines].[PickOrderId] = [PickOrders].[PickOrderId]
ORDER BY		
		[PickLines].[SecondaryLocationName]
