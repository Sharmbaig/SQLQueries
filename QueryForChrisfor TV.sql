select * from (SELECT top 10
CAST([shipsys_tran_id] AS DATE)AS [Date]
 ,count(CAST((shipsys_tran_id)AS DATE)) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons]  
  group by [shipsys_tran_id]
order by CAST([shipsys_tran_id]AS DATE) desc)AS [Total Shipped Orders]
order by [Date]