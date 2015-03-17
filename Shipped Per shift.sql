SELECT top 10
CAST([ship_date]AS DATE)AS [Date],
count (shipsys_tran_id) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons] WITH(NOLOCK)
where  cast(ship_date as time) between '08:30:00' and '19:30:00'
  group by CAST([Ship_date]AS Date)
order by [Total Shipped Orders] desc


SELECT top 10

cast(dateadd (day, -1, [date]) as date) as date,
[Total Shipped Orders]
 
 FROM 
 (SELECT
CAST([shipsys_tran_id] AS DATE)AS [Date]
,count(CAST((shipsys_tran_id)AS DATE)) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons] WITH(NOLOCK)
WHERE CAST([ship_date] AS TIME) BETWEEN '19:30' and '23:59'
OR Cast([ship_date] AS TIME) BETWEEN '00:00' AND '04:00'
  group by [shipsys_tran_id])AS [Total Shipped Orders]
  order by [Total Shipped Orders] desc
