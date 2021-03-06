/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
     
      cast([activity_date] as date)
     ,COUNT([requester]) AS [Totes processed]
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE [if_tran_code] in ('SHP-CART','SHP-CARTQ','SHIP-PACK','SHIP-PACKQ')
  AND CAST(activity_date AS DATE) >= '06/01/14'
  GROUP BY cast([activity_date] as date)