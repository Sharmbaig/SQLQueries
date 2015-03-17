SELECT  TOP 100
		CAST(activity_date AS DATE) AS [Date]
       ,U.[full_name]
      ,SUM(CONVERT(int,[slot0])) AS [Total Orders]
      
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE [if_tran_code] in ('SHIP-PACK','SHIP-PACkQ','SHP-CART','SHP-CARTQ')
GROUP BY CAST(activity_date AS DATE)
       ,U.[full_name]
ORDER BY [Total Orders] DESC