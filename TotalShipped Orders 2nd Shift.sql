SELECT 

concat( cast(dateadd (day, -1, [date]) as date), ' - ', [date]),
[Total Shipped Orders]
 
 FROM 
 (SELECT top 10
CAST([shipsys_tran_id] AS DATE)AS [Date]
,count(CAST((shipsys_tran_id)AS DATE)) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE CAST([ship_date] AS TIME) BETWEEN '19:30' and '23:59'
OR Cast([ship_date] AS TIME) BETWEEN '00:00' AND '04:00'
  group by [shipsys_tran_id]
order by CAST([shipsys_tran_id]AS DATE) desc)AS [Total Shipped Orders]
ORDER BY [Date] 
