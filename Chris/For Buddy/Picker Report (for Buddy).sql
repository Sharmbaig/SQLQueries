DECLARE @starttime as date,
		@endtime as date


SET @starttime = '5/15/2014'
SET @endtime = '6/2/2014'

SELECT 
	cast(a.pickcompletetime as date) as date,
	 sum(a.[PickedQty]) as picked_pieces,
	 count(distinct a.[SecondaryLocationName]) as total_orders,
	  a.PickerName,
	  count(c.item_id) as Missing,
	  count(d.item_id) as [Wrong Item]
FROM(
SELECT
 a.pickcompletetime,
 a.[PickedQty],
 a.[SecondaryLocationName],
 b.PickerName,
 a.productbarcode
FROM   
 [LPPick].[dbo].[PickLines] as a
	LEFT JOIN
[LPPick].[dbo].[Pickers] as b
	on a.pickerid = b.pickerid) as a
	
	LEFT JOIN

	(SELECT 
      cast([activity_date] as date) as date
      ,[exception_type]
      ,[item_id]
      ,[order_id]
  FROM [PH_PROD].[dbxx].[exceptions2]
  where exception_type in ('MISSING')) as c
 on a.[SecondaryLocationName] = c.order_id and a.productbarcode = c.item_id

 LEFT JOIN
 (SELECT 
      cast([activity_date] as date) as date
      ,[exception_type]
      ,[item_id]
      ,[order_id]
  FROM [PH_PROD].[dbxx].[exceptions2]
  where exception_type in ('WRONG ITEM')) as D
 on a.[SecondaryLocationName] = D.order_id and a.productbarcode = D.item_id

WHERE cast(a.pickcompletetime as date) between @starttime and @endtime
GROUP BY a.pickername, cast(a.pickcompletetime as date)



