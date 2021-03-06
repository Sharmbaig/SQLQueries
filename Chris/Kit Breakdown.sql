


SELECT
	a.Item_id,
	sum(a.Pieces_ordered) as Pieces_ordered,
	cast(date_ordered as date)
FROM
	[PH_PROD].[dbxx].[order_lines] as a
	LEFT JOIN
	[PH_PROD].[dbxx].[orders] as b
	on a.order_id = b.order_id
WHERE a.item_id in (
'KT3008',
'KT3009',
'KT3010',
'KT3011',
'KT3012',
'KT3013',
'KT3014',
'SI2004',
'SI2005')
GROUP BY a.Item_id, cast(date_ordered as date)

 

