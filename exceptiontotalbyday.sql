select
cast(activity_date as date) as date,

[item_id]
,COUNT(item_id) AS Items
FROM
	[PH_PROD].[dbxx].[exceptions2] as a
WHERE screen_id = 'W_CARTON_PICKVERIFY_SHIP_POP_EXCEPTION' AND [activity_date] BETWEEN '01/1/2014' AND '6/07/2014' AND [item_id] IN 

('CH1001'
,'CH1108'
,'CH1401'
,'CH1423'
,'CH1601'
,'CH3061'
,'CH3065'
,'CH7006'
,'CH9004'
,'CH9010')

GROUP BY cast(activity_date as date), item_id