/***1st Shift True Inspection Rate***/

Select
((Select
count(if_tran_code) as total_orders_shipped
from
ph_prod.dbxx.if_transaction as a
where if_tran_code in ( 'VERIFY' ) and cast((activity_date+' '+activity_time) as datetime) BETWEEN '12/23/2014 7:00am' AND '12/23/2014 5:30pm')*1.0)/

((Select
count(if_tran_code) as total_orders_shipped
from
ph_prod.dbxx.if_transaction as a
where if_tran_code in ( 'VERIFY' , 'VERIFY-Q') and cast((activity_date+' '+activity_time) as datetime) BETWEEN '12/23/2014 7:00am' AND '12/23/2014 5:30pm' )*1.0)

/***2nd Shift True Inspection Rate***/

Select
((Select
count(if_tran_code) as total_orders_shipped
from
ph_prod.dbxx.if_transaction as a
where if_tran_code in ( 'VERIFY' ) and cast((activity_date+' '+activity_time) as datetime) BETWEEN '12/08/2014 5:45pm' AND '12/09/2014 4:30am')*1.0)/

((Select
count(if_tran_code) as total_orders_shipped
from
ph_prod.dbxx.if_transaction as a
where if_tran_code in ( 'VERIFY' , 'VERIFY-Q') and cast((activity_date+' '+activity_time) as datetime) BETWEEN '12/08/2014 5:45pm' AND '12/09/2014 4:30am' )*1.0)