/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE
@startdate as date,
@enddate as date
SET @startdate = '02/01/2015'
SET @enddate = '02/10/2015'


SELECT

b.item_id,
c.description,
total_defecs,

pieces_inspected,
(total_defecs*1.0) / (pieces_inspected*1.0) as Defect_ratio

FROM(
SELECT [item_id]
      ,sum([pieces]) as [pieces_inspected]
  FROM [PH_PROD].[dbxx].[if_transaction]
  where cast(activity_date as date) between @startdate and @enddate 
			and 
		order_id in (SELECT order_id from [PH_PROD].[dbxx].[if_transaction] where if_tran_code = 'VERIFY' ) 
			and 
		if_tran_code = 'pop-pick'

GROUP BY item_id) as a

RIGHT JOIN

(SELECT
	item_id,
	count(exception_type) as total_defecs

FROM
[PH_PROD].[dbxx].[exceptions2]
where cast(activity_date as date) between @startdate and @enddate and exception_type = 'DEFECTIVE'
group by item_id) as b

on a.item_id = b.item_id

left join
[PH_PROD].[dbxx].[item_master] as c
on a.item_id = c.item_id
order by total_defecs desc
