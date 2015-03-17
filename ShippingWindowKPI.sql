				   SELECT order_id, date_ordered
                          ,DATEDIFF(HOUR, date_ordered,DATEADD(HOUR,3,GETDATE()))as [Hours]
                                                                  , 1 as [HourGroup]
                   FROM    PH_PROD.dbxx.orders
                   WHERE       
                           DATEDIFF(HOUR, date_ordered,DATEADD(HOUR,3,GETDATE())) <= 36 
                                                 UNION
                   SELECT order_id, date_ordered
                              , DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) as [Hours]
                                                                  , 2 as [HourGroup]
                   FROM          PH_PROD.dbxx.orders
                   WHERE        
                                DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) > 36 and
                                DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE()))<= 48  
                                                UNION
                  SELECT order_id, date_ordered
                              , DATEDIFF(HOUR, date_ordered,DATEADD(HOUR,3,GETDATE())) as [Hours]
                                                                  , 3 as [HourGroup]
                   FROM          PH_PROD.dbxx.orders
                   WHERE       
                                 DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) > 48 and
                                DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) <= 72 
                                                UNION
                   SELECT order_id, date_ordered
                              , DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) as [Hours]
                                                                  , 4 as [HourGroup]
                   FROM            PH_PROD.dbxx.orders
                   WHERE         DATEDIFF(HOUR, date_ordered, DATEADD(HOUR,3,GETDATE())) > 72

