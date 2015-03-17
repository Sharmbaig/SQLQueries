SELECT
              Inspected.[usr_id]
              ,Inspected.[location_id_from]
              ,(ISNULL(Inspected.[Hours],0) + ISNULL(NonInspected.[Hours],0)) AS [Total Hours]
              ,(ISNULL(Inspected.Units,0) + ISNULL(NonInspected.Units,0)) AS [Total Units]
              ,(ISNULL(Inspected.Orders,0) + ISNULL(NonInspected.Orders,0)) AS [Total Orders]
              ,((ISNULL(Inspected.Units,0) + ISNULL(NonInspected.Units,0))/(ISNULL(Inspected.[Hours],0) + ISNULL(NonInspected.[Hours],0))) AS [Units Per Hour]
              ,((ISNULL(Inspected.Orders,0) + ISNULL(NonInspected.Orders,0))/(ISNULL(Inspected.[Hours],0) + ISNULL(NonInspected.[Hours],0))) AS [Orders Per Hour] 
              ,ISNULL(Inspected.[Hours],0) AS [Inpsected Hours]
              ,ISNULL(NonInspected.[Hours],0) AS [Non Inspected Hours]
              ,ISNULL(Inspected.Units,0) AS [Inspected Units]
              ,ISNULL(NonInspected.Units,0) AS [Non Inspected Units]
              ,ISNULL(Inspected.[Orders],0) AS [Inspected Orders]
              ,ISNULL(NonInspected.[Orders],0) AS [Non Inspected Orders] 
              ,ISNULL((Inspected.Units/Inspected.[Hours]),0) AS [Inspected Units Per Hour]
              ,ISNULL(NonInspected.Units/NonInspected.[Hours],0) AS [Non Inspected Units Per Hour]
              ,ISNULL(Inspected.Orders/Inspected.[Hours],0) AS [Inspected Orders Per Hour]
              ,ISNULL(NonInspected.Orders/NonInspected.[Hours],0) AS [Non Inspected Orders per Hour]

FROM
(SELECT 
          [usr_id]
      ,[location_id_from]
      ,SUM(CAST([Tot_Orders]AS INT)) [Orders]
      ,SUM(CAST([Tot_units]AS INT)) [Units]
      ,SUM(CAST([Tot_time_in_Seconds] AS INT))/60.0/60.0 [Hours]
  FROM [PH_PROD].[dbo].[vw_PackerProductivity]
  WHERE CAST(activity_date AS DATE) = '01/23/14'
  AND [Start_Time] Between '07:00:00' and '18:15:00'
  AND if_tran_code = 'VERIFY'
  GROUP BY    [usr_id]
      ,[location_id_from]) AS Inspected
         LEFT JOIN
(SELECT 
          [usr_id]
      ,[location_id_from]
      ,SUM(CAST([Tot_Orders]AS INT)) [Orders]
      ,SUM(CAST([Tot_units]AS INT)) [Units]
      ,SUM(CAST([Tot_time_in_Seconds] AS INT))/60.0/60.0 [Hours]
  FROM [PH_PROD].[dbo].[vw_PackerProductivity]
  WHERE CAST(activity_date AS DATE) = '01/23/14'
  AND [Start_Time] Between '07:00:00' and '18:15:00'
  AND if_tran_code = 'VERIFY-Q'
  GROUP BY    [usr_id]
      ,[location_id_from]) AS NonInspected
                     ON Inspected.[usr_id] = NonInspected.[usr_id] AND Inspected.[location_id_from] = NonInspected.[location_id_from] 

