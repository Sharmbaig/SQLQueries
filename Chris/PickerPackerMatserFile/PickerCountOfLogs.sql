SELECT
date,
sum([count]) as counts
FROM
(


SELECT
pickername,
barcode,
countoflogs,
date,
case when lag(countoflogs) over (partition by pickername, cast(date as date) order by barcode)= countoflogs then 0 else 1 end as [count]
FROM
(


SELECT 
		[PickerName]
		,[Barcode]
		,COUNT([Barcode]) as countoflogs
		,cast(eventdatetime as date) as date
  FROM [LPPick].[dbo].[ScanEvents]
WHERE CAST([EventDateTime] AS DATE) between '08/18/14' and '9/19/2014' and barcode in ('BEGIN', 'END')
GROUP BY [PickerName]
,[Barcode],
cast(eventdatetime as date) 
) as a) as b
where barcode = 'End'
group by date