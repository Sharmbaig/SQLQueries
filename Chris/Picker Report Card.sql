

DECLARE
	@startdate as DATEtime,
	@enddate as DATEtime,
	@targetrate as int

SET 
	@startdate = '11/3/2014 1:00:00'
SET 
	@enddate = '11/3/2014 16:00:00'
SET 
	@targetrate = 900;


	with dt as (

					SELECT
						a.[pickername],
						SUM(a.[pieces]) as [pieces],
						SUM([seconds])/60.0/60.0 as [hours],
						isnull(sum(errors),0) as errors,
						@targetrate as target_rate,
						(SELECT
							(sum(case when if_tran_code = 'VERIFY' then 1 ELSE null end)*1.0)/ (count(SecondaryLocationName)*1.0)
							FROM(
							select distinct
							secondarylocationname ,
							b.if_tran_code
							from [LPPick].[dbo].[PickLines] as a
								left join
								ph_prod.dbxx.if_transaction as b
								on a.secondarylocationname = b.order_id
							where CAST([pickcompletetime] as DATEtime) between @startdate and @enddate and b.if_tran_code in ('VERIFY', 'VERIFY-Q')) as a) as inspection_rate

						

					FROM
							(SELECT
								[zonename],
								a.[pickername],
								[barcode],
								a.[pieces],
								lines,
								a.order_id,
								CAST([EventDateTime] as DATE) as [date],
								DATEDIFF(SECOND, lag([eventdatetime]) 
														OVER (PARTITION BY a.[pickername], [zonename], cast([eventdatetime] as DATE) 
														ORDER BY [eventdatetime])
												, [eventdatetime]
												) as [seconds],
										b.pieces as errors

										FROM
											(		

	------ START RAW PICKING TIME -------
											SELECT 
														  [EventDateTime]
														 ,[ZoneName]
														 ,[Barcode]
														 ,[PickerName],
														 'o' as order_id,
														 '0' as [pieces],
														 '0' as [lines]

													FROM 
														lppick.[dbo].[ScanEvents]

													WHERE 
														[barcode] in ('ZoneStarted') 
														and [pickername] not in ('unassigned') 
														and CAST([EventDateTime] as DATEtime) between @startdate and @enddate 

											UNION


													SELECT 
														MAX([PickCompleteTime]),
														b.[Zonename],
														'ZoneComplete',
														c.[PickerName],
														a.secondarylocationname,
														SUM([PickedQty]) as [pieces],
														count(pickedQty) as [lines]
     
													FROM 
																[LPPick].[dbo].[PickLines] as a
																	  LEFT JOIN
																[LPPick].[dbo].[zones] as b
																		on a.[ZoneId] = b.[ZoneId]
																	  LEFT JOIN
																[LPPick].[dbo].[Pickers] as c
																		on a.[pickerid] = c.[pickerid]

													WHERE 
														CAST([pickcompletetime] as DATEtime) between @startdate and @enddate 

													GROUP BY
  														 b.[Zonename]
														,c.[PickerName]
														,a.SecondaryLocationName
														,a.[PickOrderId]

		------ END RAW PICKING TIME -------

												) as a

										
					left join

					(select
							a.order_id,
							sum(b.pieces) as pieces,
							c.PickerName
							FROm
							ph_PROD.dbxx.exceptions2 as a
							left join
							ph_prod.dbxx.if_transaction as b
							on a.order_id = b.order_id and a.item_id = b.Item_id
							inner join
							lppick.dbo.pickers as c
							on b.usr_id = c.PickerBarCode
							where a.order_id in (select secondarylocationname from [LPPick].[dbo].[PickLines] where CAST([pickcompletetime] as DATEtime) between @startdate and @enddate) and
								--cast(a.activity_date as date) between dateadd( day, -1 ,cast(@startdate as date)) and dateadd( day , 1 , cast(@enddate as date)) and 
									exception_type in ('MISSING', 'EXTRA ITEM', 'WRONG ITEM')
							group by a.order_id,
							c.pickername) as b
								on a.order_id = b.order_id and a.PickerName = b.PickerName

								) as a

				
				group by 
			a.pickername)




SELECT
*,
(pieces/(((errors *errors *inspection_rate)+(hours*60))/60))/target_rate as grade
from
dt