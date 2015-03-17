SELECT 
	 [location_id]
	,[item_id] 
	,[pieces_min]
	,[pieces_max]
	,[assign_flag]
FROM 
	[PH_PROD].[dbxx].[item_location]
WHERE 
	([assign_flag] = 'N' and substring([location_id],1,1) in ('A','B','C','D','E','F','G','H')
and 
	[item_id] not in ((SELECT * FROM [METRICS_SUMMARIES].[dbo].[retired])) and [location_id] <> 'C1')
OR 
	([assign_flag] = 'Y' and substring([location_id],1,1) not in ('A','B','C','D','E','F','G','H'))
ORDER BY
	[assign_flag]