
Declare @startdate as date, @enddate as date

set @startdate = '5/28/2014'
Set @enddate = '5/28/2014'

SELECT 
	   count(a.if_tran_code) as total_work_performed,
	   cast(a.activity_date as date) as [Date_completed]
 
  FROM 
		[PH_PROD].[dbxx].[if_transaction] AS A

LEFT JOIN

		[PH_PROD].[dbxx].[if_tran_code] AS B
			on a.if_tran_code = b.if_tran_code
  WHERE 
		cast(a.activity_date as date) between @startdate and @enddate 
			and 
		a.if_tran_code = 'cr-pick'
		
	group by  cast(a.activity_date as date)

	order by date_completed desc


	SELECT 
		A.[usr_id],
		count(a.if_tran_code) as total_work_performed,
		cast(a.activity_date as date) as [Date_completed]
     
 
  FROM 
		[PH_PROD].[dbxx].[if_transaction] AS A

LEFT JOIN

		[PH_PROD].[dbxx].[if_tran_code] AS B
			on a.if_tran_code = b.if_tran_code
  WHERE 
		cast(a.activity_date as date) between @startdate and @enddate 
			and 
		a.if_tran_code = 'cr-pick'

		
	group by usr_id, a.if_tran_code,cast(a.activity_date as date)

	order by date_completed desc
	


	SELECT 
	  a.usr_id,
	   count(A.[usr_id]) as 'Total Movements',
     cast(a.activity_date as date) as Date_completed
 
  FROM 
		[PH_PROD].[dbxx].[if_transaction] AS A

LEFT JOIN

		[PH_PROD].[dbxx].[if_tran_code] AS B
			on a.if_tran_code = b.if_tran_code
  WHERE 
		cast(a.activity_date as date) between @startdate and @enddate 
			and
		a.if_tran_code in ('MOVE-CONT')
		group By a.if_tran_code, a.usr_id, cast(a.activity_date as date)
	order by Date_completed desc
	

	SELECT 
	 count(A.[usr_id]) as 'Total Movements',
     cast(a.activity_date as date) as Date_completed
 
  FROM 
		[PH_PROD].[dbxx].[if_transaction] AS A

LEFT JOIN

		[PH_PROD].[dbxx].[if_tran_code] AS B
			on a.if_tran_code = b.if_tran_code
  WHERE 
		cast(a.activity_date as date) between @startdate and @enddate 
			and
		a.if_tran_code in ('MOVE-CONT')
		group By cast(a.activity_date as date)
	order by Date_completed desc
	