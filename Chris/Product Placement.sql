/****** Script for SelectTopNRows command from SSMS  ******/

DECLARE
@lane as varchar
set @lane = 'H'


SELECT
a.item_id,
a.[location_from],
a.[From_onhand],
a.[location_to],
a.to_onhand,
b.pieces_ordered
FROM(
SELECT
a.item_id,
a.[location_from],
a.[From_onhand],
a.[location_to],
a.to_onhand,
a.[priority],
row_number () over (partition by a.item_id, location_to order by loc_priority ) as rn
FROM(
		SELECT
		a.item_id,
		b.location_id as [location_from],
		b.pieces_onhand as [From_onhand],
		a.location_id as [location_to],
		a.pieces_onhand as to_onhand,
		a.[priority],

		case when location_type = 'PTL-RESTK' then 1 else 
				(case when [location_type] = 'secured QC' then 2 else 
					(case when [location_type] = 'non secure' then 3 else
						(case when [location_type] = 'reserve' then 4 else null end)  end) end) end as [loc_priority]
		FROM(

				SELECT 
				location_id,
				pieces_onhand,
					  case when substring ([location_id],1,1) = 'G' then 1 else 
						(case when substring ([location_id],1,1) = 'H' then 2 else 
							(case when substring ([location_id],1,1) = 'F' then 3 else
								(case when substring ([location_id],1,1) = 'D' then 4 else
									(case when substring ([location_id],1,1) = 'E' then 5 else 
										(case when substring ([location_id],1,1) = 'C' then 6 else 
											(case when substring ([location_id],1,1) = 'B' then 7 else 
												(case when substring ([location_id],1,1) = 'A' then 8 else null end)end) end) end)end) end) end ) end as [priority]
      
					  ,[item_id]
				  FROM [PH_PROD].[dbxx].[item_location]
				  where location_type = 'PTL' and pieces_onhand = 0) as a
  right join
  [PH_PROD].[dbxx].[item_location] as b
  on a.item_id = b.item_id

  where a.[priority] is not null and  location_type in ( 'SECURED QC', 'NON SECURE','PTL-RESTK', 'RESERVE') and substring(b.location_id,1,1) <> 'S' ) as a
  ) as a
  left join
  (select
		item_id,
		sum(pieces_ordered) as pieces_ordered
		From
		ph_prod.dbxx.order_lines
		group by item_id) as b
		on a.item_id = b.item_id
  where rn = 1 
  and substring(location_to,1,1) = @lane
  order by pieces_ordered desc