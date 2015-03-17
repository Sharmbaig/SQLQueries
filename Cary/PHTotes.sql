SELECT
    *
FROM
(SELECT
	  A.order_id ,
	  B.date_ordered ,
	  requester , 
	  activity_date , 
	  activity_time , 
	  A.usr_id , 
	  location_id_from,
	  DATEDIFF(minute,activity_time,DATEADD(hour,3,CAST(GETDATE()AS TIME)))/60.0 AS [Hours]
  FROM PH_PROD.dbxx.if_transaction AS A
		  INNER JOIN
	   PH_PROD.dbxx.orders AS B
		  ON A.order_id = B.order_id
  WHERE if_tran_code LIKE 'VERIFY%'
    AND CAST( activity_date AS date
		  )
	   = 
	   CAST( GETDATE(
				 )AS date
		  )
    AND A.order_id IN( 
				 SELECT
					   order_id
				   FROM PH_PROD.dbxx.orders
				   WHERE order_status
					    = 
					    090
			    ))AS A
WHERE [Hours] > .5