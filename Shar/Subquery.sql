SELECT
		 CAST([date_ordered] AS [Date]) AS [Date]
		,O.[order_id] AS [Order Number]
		,[po_num] AS [PO Number]
		,[s_contact] AS [Customer Name]
		,[s_phone] AS [Phone Number]
		,[s_address1] AS [Address]
		,[s_city] AS City
		,[s_state] AS [State]
		,[s_zip] AS [Zip]
		,OL.[item_id] AS Item
		,OL.[Pieces_to_pick] AS [QTY]
				
FROM	[PH_PROD].[dbxx].[orders] AS O

INNER JOIN
		[PH_PROD].[dbxx].[order_lines] AS OL

ON
		O.order_id = OL.order_id

where OL.[item_id] in (select item_id from [METRICS_SUMMARIES].[dbo].[fall2014retired])