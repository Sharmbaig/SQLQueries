/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	WeightCategory,
	COUNT(DISTINCT order_id) AS [Orders],
	COUNT(DISTINCT package_trace_id) AS [Packages]
FROM
(SELECT 
      [package_trace_id]
      ,[order_id]
      ,CASE WHEN [usr_measured_weight] BETWEEN 0.0 AND 1.00
	  THEN '0-1'
	  WHEN [usr_measured_weight] BETWEEN 1.000001 AND 2.00
	  THEN '1-2'
	  WHEN [usr_measured_weight] BETWEEN 2.000001 AND 3.00
	  THEN '2-3'
	  WHEN [usr_measured_weight] BETWEEN 3.000001 AND 4.00
	  THEN '3-4'
	  WHEN [usr_measured_weight] BETWEEN 4.000001 AND 5.00
	  THEN '4-5'
	  WHEN [usr_measured_weight] BETWEEN 5.000001 AND 6.00
	  THEN '5-6'
	  WHEN [usr_measured_weight] BETWEEN 6.0000001 AND 10.00
	  THEN '6-10'
	  WHEN [usr_measured_weight] BETWEEN 10.0000001 AND 20.00
	  THEN '10-20'
	  WHEN [usr_measured_weight] BETWEEN 20.0000001 AND 30.00
	  THEN '20-30'
	  WHEN [usr_measured_weight] > 30.00
	  THEN '>30'
	  END AS WeightCategory,
	  usr_measured_weight
                       
  FROM [PH_PROD].[dbxx].[hi_work_cartons] 
  WHERE CAST(ship_date AS DATE) BETWEEN '01/01/14' AND '12/31/14')AS RawData
  GROUP BY 
	WeightCategory