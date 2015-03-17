SELECT 
	count (a.ship_date) as 'Total Orders',
	sum(b.tot_to_pick) as 'Total Items'

   FROM [PH_PROD].[dbxx].[hi_work_cartons] as a
   left join ph_prod.dbxx.hi_orders as b
   on a.order_id = b.Order_id
  where cast (a.ship_date as datetime) between '2/26/2014 15:30' and '2/26/2014 16:30'
  