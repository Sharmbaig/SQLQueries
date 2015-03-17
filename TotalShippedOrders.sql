SELECT 
CAST([shipsys_tran_id] AS DATE)AS [Date]
,count(CAST((shipsys_tran_id)AS DATE)) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE  CAST([shipsys_tran_id] AS DATE) ='11/28/14'
  group by [shipsys_tran_id]
order by CAST([shipsys_tran_id] AS DATE) desc