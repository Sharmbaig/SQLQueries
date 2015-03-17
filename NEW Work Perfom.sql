
Declare @startdate as date, @enddate as date

set @startdate = '1/1/2014'
Set @enddate = '1/31/2014'

SELECT
		'Avg Work Orders Per Day',
		round((sum(total_work_performed) *1.0) / (count(date_completed)*1.0), 2)
FROM
	(SELECT
		date_completed,
		sum(total_work_performed) as total_work_performed
	FROM
		(SELECT 
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

		
			group by usr_id, a.if_tran_code,cast(a.activity_date as date)) as a
GROUP BY Date_completed) as a


			UNION

SELECT
	'Avg Work Orders Per Person',
	round((sum(total_work_performed)* 1.0) / (count(A.[usr_id])* 1.0),2)
FROM
	(SELECT 
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

		
		group by usr_id, a.if_tran_code,cast(a.activity_date as date)) as a

			UNION

SELECT
	'Avg Product Moves Per Day',
	round((sum(total_movements) * 1.0) / (count(Date_completed) *1.0),2)
FROM
	(SELECT
		sum(Total_Movements) as total_movements,
		Date_completed
		FROM
		(SELECT 
		   count(A.[usr_id]) as 'Total_Movements',
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
			group By a.if_tran_code, a.usr_id, cast(a.activity_date as date)) as a
			GROUP BY date_completed) as a

		UNION

SELECT
	'Avg Product Moves Per Person',
	round((sum(b.Total_Movements) *1.0) / (count(usr_id)* 1.0),2)
FROM
	(SELECT
		usr_id,
		sum(Total_Movements) as Total_Movements
	FROM
		(SELECT 
			  a.usr_id,
			   count(A.[usr_id]) as 'Total_Movements',
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
				group By a.if_tran_code, a.usr_id, cast(a.activity_date as date)) as a
GROUP BY usr_id) as b

	
		UNION


SELECT
	'Total Work Orders',
	round(sum(total_work_performed),2)
FROM
	(SELECT 
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
		
		GROUP BY  cast(a.activity_date as date)) as a

		
		UNION


	
SELECT
	'Total Product Moves',
	round(sum(Total_Movements),2)
	
FROM
	(SELECT 
		 count(A.[usr_id]) as 'Total_Movements',
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
			group By cast(a.activity_date as date)) as a
	