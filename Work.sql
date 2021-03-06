/****** Script for SelectTopNRows command from SSMS  ******/
Declare @startdate as date, @enddate as date

set @startdate = '4/09/2014'
Set @enddate = '4/14/2014'

SELECT 
       a.if_tran_code,
	   count(a.if_tran_code) as total,
	   A.[usr_id]
     
 
  FROM 
		[PH_PROD].[dbxx].[if_transaction] AS A

LEFT JOIN

		[PH_PROD].[dbxx].[if_tran_code] AS B
			on a.if_tran_code = b.if_tran_code
  WHERE 
		cast(a.activity_date as date) between @startdate and @enddate 
			and 
		a.screen_id not in ('CARTON PICK VERIFY AND SH','CARTON PICK PACK SHIP SIN', 'LTNPICK', 'W_CUT_ORDER')
			and 
		a.if_tran_code not in ('NEW-PALL', 'CR-DEL', 'DEL-PALL', 'PALL-PKP', 'PALL-STG', 'CR-STG', 'HOLD-CHG', 'HOLD-PLACE', 'HOLD-REL', 'MOVE-PALL', 'POP-PICK', 'TRASH-PALL', 'BLOCK-CHG', 'BLOCK-PLC', 'BLOCK-REL')
		
	group by usr_id, a.if_tran_code

	order by if_tran_code
	