SELECT 
               [ship_date]
              ,C.[ship_method]
              ,C.[order_id]
			  ,H.[order_type]
			  ,H.[route_code]
              ,[s_zip]
              ,[s_state]
              ,[usr_measured_weight]

  FROM [PH_PROD].[dbxx].[hi_work_cartons] AS C
                           INNER JOIN
              [PH_PROD].[dbxx].[hi_orders] AS H
                           ON C.[order_id] = H.[order_id]
WHERE CAST(ship_date AS DATE) = '08/27/2014'