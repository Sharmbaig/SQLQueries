DECLARE @today DATE
SET @today = CAST(GETDATE()AS DATE)
SELECT 
 count (shipsys_tran_id) as 'Total Shipped Orders'
   FROM [PH_PROD].[dbxx].[hi_work_cartons]  
   WHERE CAST([ship_date] AS DATE) = @today