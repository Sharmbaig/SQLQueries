SELECT
	a.date,
	a.order_type,
	a.item_id,
	a.[Total Orders],
	a.Pieces,
	b.location_id
FROM
(Select 
	CAST(O.[date_ordered] AS Date) AS [Date]
	,[order_type]
	,[item_id]
	,COUNT(O.order_id) AS [Total Orders]
	,SUM([pieces_ordered]) AS Pieces
FROM [PH_PROD].[dbxx].[orders] AS O
LEFT JOIN 
[PH_PROD].[dbxx].[order_lines] AS L
ON o.[order_id] = l.[order_id]
WHERE L.item_id  in (SELECT * from [METRICS_SUMMARIES].[dbo].[retired])
GROUP BY
	CAST(O.[date_ordered] AS Date) 
	,[order_type]
	,[item_id]) as a
		LEFT JOIN
	[PH_PROD].[dbxx].[item_location] as b
	on a.item_id = b.item_id
where b.location_type = 'PTL' and SUBSTRING(b.location_id,1,1) = 'C'