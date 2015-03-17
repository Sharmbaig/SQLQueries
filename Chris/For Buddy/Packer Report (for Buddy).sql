DECLARE @StartDate AS DATETIME,@EndDate AS DATETIME;
SET @StartDate = '06/03/14'
SET @EndDate = '06/03/14' 

SELECT
		a.if_tran_code,
		c.full_name,
		sum(a.total_orders) as total_orders,
		a.date,
		b.Time_worked,
		sum(a.pieces) as pieces

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
	  convert(varchar,DATEadd(ms, SUM(cast(slot4 as int)) * 1000, 0) ,8) as Time_worked

       
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

		order by full_name