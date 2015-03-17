SELECT 
	CAST(a.[ship_date]AS DATE)AS [Date],
	count (a.shipsys_tran_id) as 'Total Shipped Orders',
	SUM(b.tot_to_pick) as 'Total Items'
FROM
	[PH_PROD].[dbxx].[hi_work_cartons] as a
			left join
	[PH_PROD].[dbxx].[hi_orders] as b
				on a.order_id = b.order_id
WHERE
		cast(a.ship_date as time) between '08:30:00' and '19:30:00'
GROUP BY 
	CAST(a.[Ship_date]AS Date)
ORDER BY
		[date] desc


SELECT 
	cast(dateadd (day, -1, [date]) as date) as [date],
	[Total Shipped Orders],
	[total items]
FROM 
 (SELECT 
	CAST(a.[shipsys_tran_id] AS DATE)AS [Date],
	count(CAST(a.shipsys_tran_id AS DATE)) as 'Total Shipped Orders',
	sum(b.tot_to_pick) as 'Total Items'

FROM [PH_PROD].[dbxx].[hi_work_cartons] as a
			left join
	[PH_PROD].[dbxx].[hi_orders] as b
				on a.order_id = b.order_id
WHERE 
	CAST(a.[ship_date] AS TIME) BETWEEN '19:30' and '23:59'
		OR 
	Cast(a.[ship_date] AS TIME) BETWEEN '00:00' AND '04:00'
  GROUP BY 
		a.[shipsys_tran_id]) AS [Total Shipped Orders]
ORDER BY [Date] desc