SELECT DISTINCT
    CAST(A.[Date Shipped] AS DATETIME) AS [Date],
    A.order_id,
    A.[Reship Reason],
    B.full_name AS [Picker],
    A.shipped_usr_id AS [Packer],
    A.if_tran_code ,
    CASE WHEN if_tran_code = 'VERIFY'
	   THEN 'Packer Error'
	   ELSE 'Picker Error'
	   END AS [Error Type]
FROM
(SELECT 
	  CAST(date_shipped AS DATE) AS [Date Shipped]
       ,B.order_id
      ,[Reship Reason]
	 ,if_tran_code
	 ,shipped_usr_id
  FROM [Metrics Reports].[dbo].[reships] AS A
			 INNER JOIN
       PH_PROD.dbxx.hi_orders AS B
			 ON A.[Original Order ID] = B.order_id
			 INNER JOIN
      PH_PROD.dbxx.if_transaction AS C
			 ON B.order_id = C.order_id
WHERE [Reship Reason] in ( 'Missing Product','Wrong Item Received')
AND if_tran_code in ('VERIFY','VERIFY-Q')
and B.release_num = 1) AS A
    INNER JOIN
(SELECT DISTINCT
    CAST(activity_date AS DATE) AS [Date]
    ,order_id
    ,full_name
FROM PH_PROD.dbxx.if_transaction AS A
		  INNER JOIN
    PH_PROD.dbxx.usrs AS B
		  On A.usr_id = B.emp_number
WHERE if_tran_code = 'POP-PICK') AS B
    ON A.[order_id] = B.order_id 
WHERE A.[Date Shipped] >= '01/01/14'
