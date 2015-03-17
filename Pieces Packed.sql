DECLARE @starttime as date,
		@endtime as date
SET		@starttime =	'4/01/2014'
SET		@endtime =		'4/30/2014'

SELECT
	a.if_tran_code,
	cast(a.activity_date as date) as date,
	sum(b.tot_ordered) as total_pieces,
	b.shipped_usr_id
FROM
	[PH_PROD].[dbxx].[if_transaction] as a
		LEFT JOIN
	[PH_PROD].[dbxx].[hi_orders] as b
		on a.order_id = b.order_id 
WHERE cast(a.activity_date as date) between @starttime and @endtime
		and 
	if_tran_code in ('VERIFY-Q', 'VERIFY') 
		and 
	cast(activity_time as time) between '10:30:00' and '19:30:00'
GROUP BY	a.if_tran_code, 
			a.activity_date, 
			shipped_usr_id
ORDER BY 
			date, 
			shipped_usr_id