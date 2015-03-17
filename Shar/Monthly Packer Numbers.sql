DECLARE @StartDate AS Date
DECLARE @EndDate AS Date

SET @StartDate = '07/01/2014'
SET @EndDate = '07/31/2014'

SELECT
		a.date,
		c.full_name,
		b.Time_worked,
		sum(a.total_orders) as total_orders,
		sum(a.pieces) as pieces,
		a.if_tran_code
		
		

FROM(

SELECT  
       I.usr_id,
	   case when [if_tran_code] in ('SHP-CART','SHIP-PACK') then 'INSPECTED' ELSE 'NON INSPECTED' end as if_tran_code,
	   CAST(I.activity_date AS date) as date
      ,SUM(cast(slot0 as int)) AS Total_Orders
      ,SUM(cast(slot2 as int)) AS pieces
	  

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
WHERE 
     CAST(I.activity_date AS date)                 
              between @StartDate and @enddate
              AND 
		if_tran_code in ('SHP-CART','SHIP-PACK','SHP-CARTQ', 'SHIP-PACKQ')
		
GROUP BY 
       I.usr_id, if_tran_code, CAST(I.activity_date AS date)) as a

	 
LEFT JOIN


	(SELECT  
       I.usr_id,
	   CAST(I.activity_date AS date) as date,
	  SUM(cast(slot4 as int))/60.0/60.0 as Time_worked

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
WHERE 
     CAST(I.activity_date AS date)                 
              between @StartDate and @enddate
              AND 
		if_tran_code in ('SHP-CART','SHIP-PACK','SHP-CARTQ', 'SHIP-PACKQ')
GROUP BY 
       I.usr_id,  CAST(I.activity_date AS date)) as B
	   on a.usr_id = b.usr_id and a.date = b.date

	   LEFT JOIN 
	   [PH_PROD].[dbxx].[usrs] as C
			on a.usr_id = C.usr_id
	   	GROUP BY a.if_tran_code,
		C.full_name,
		a.date,
		b.Time_worked