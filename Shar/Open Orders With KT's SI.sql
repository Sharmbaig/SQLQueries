/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
[item_id],
 count (distinct [order_id]) as count
   
  FROM [PH_PROD].[dbxx].[order_lines]
  --where item_id in ('KT3008', 'kt3011', 'kt3009', 'SI2004' )
  where item_id like 'KT%' OR item_id like 'SI%'
  GROUP BY [item_id],[received_date]