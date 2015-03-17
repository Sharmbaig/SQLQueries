SELECT
	a.PO_num As 'Order Number',
	a.s_contact As 'Designer Name',
	a.s_phone as 'Phone Number 1',
	
	cast (a.date_ordered as date) as 'Date Ordered',

	a.cust_id as 'Designer Number'
FROM 
	[PH_PROD].[dbxx].[hi_orders] as A
		join 

where 
	cast (a.date_ordered as date) between '11/28/2014' and '12/02/2014'
		AND
	b.item_id = 'WN3001'

