DECLARE
@startdate as datetime,
@enddate as datetime
SET @startdate = '7/01/2014 2:00 am'
SEt @enddate = '7/05/2014 23:00'


SELECT      
a.order_id 

FROM            ph_prod.dbxx.hi_work_cartons as a
INNER JOIN
                         ph_prod.dbxx.hi_orders as b 
						 ON a.order_id = b.order_id and a.release_num = b.release_num
WHERE        (CAST(a.ship_date AS datetime) BETWlEEN CAST(@StartDate AS datetime) AND CAST(@EndDate AS datetime))