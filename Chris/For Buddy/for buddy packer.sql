DECLARE @startdate as date,
		@enddate as date,
		@splitshift as time
SET	@splitshift = '7:00 AM'

SET @startdate = '5/15/2014'
SET @enddate = '6/2/2014'

SELECT
		a.if_tran_code,
		a.total_orders,
		c.full_name,
		a.date,
		b.hours as Time_worked,
		a.pieces
		
FROM
		(SELECT 
			  case when [if_tran_code] = 'VERIFY' then 'INSPECTED' ELSE 'NON INSPECTED' end as if_tran_code,
			  count([if_tran_code]) as total_orders,
			  a.usr_id,
			  cast([activity_date] as date) as date,
			  sum(c.tot_ordered) as pieces
    
		  FROM [PH_PROD].[dbxx].[if_transaction] as a
		  LEFT JOIN
		  [PH_PROD].[dbxx].[usrs] as b
			on a.usr_id = b.usr_id
			LEFT JOIN [PH_PROD].[dbxx].[hi_orders] as c
				on a.order_id = c.order_id
		  WHERE if_tran_code in ('VERIFY' , 'VERIFY-Q') and cast(activity_date as date) between @startdate and @enddate
		  GROUP BY [if_tran_code], a.usr_id, cast([activity_date] as date)) as a

		  LEFT JOIN


		  (SELECT  
				cast(logout_date as date) as date,
				a.usr_id
			  ,convert(char(13),dateadd(ms,sum((DATEDIFF(millisecond, [login_time], cast(dateadd( hour, -3, [logout_time]) as datetime)))),'01/01/00'),14) as hours
		  FROM [PH_PROD].[dbxx].[hi_usr_login] as a
		  WHERE [host_name] like 'O2-PACK%'
		  AND [logout_time] is not null
		  AND cast([login_time] as date)between @startdate and @enddate
		  GROUP BY logout_date, a.usr_id) as b
				on a.usr_id = b.usr_id and a.date = b.date
				

			LEFT JOIN
			[PH_PROD].[dbxx].[usrs] as c
			on a.usr_id = c.usr_id

	order by c.full_name, a.date