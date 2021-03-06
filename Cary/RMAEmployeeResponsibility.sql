/* Takes all orders from RMA and returns the Employee who Shipped the order and the Employee Responsible for Picking the Reported Items*/
SELECT
	  RMA.* , 
	  Packer.date_shipped,
	  Packer.Packer , 
	  LP.PickerName ,
	  Packer.if_tran_code
  FROM
	  ( /*This section pulls all the data needed from the RMA queue*/
	    SELECT
			 PowerhouseOrderID , 
			 ProductSKU , 
			 ReturnQuantity , 
			 PrimaryReason
		 FROM [METRICS_SUMMARIES].dbo.RMAReportingData AS A
		 WHERE PrimaryReason IN( 'Wrong Item' , 'Missing Item'
						   )
	  )AS RMA
	  INNER JOIN
	  ( 
	    SELECT
			 A.order_id , 
			 date_shipped ,
			 B.full_name AS Packer
			 ,if_tran_code
		 FROM
			 PH_PROD.dbxx.hi_orders AS A
			 INNER JOIN
			 PH_PROD.dbxx.if_transaction AS C
			ON A.order_id = C.order_id
			 INNER JOIN
			 PH_PROD.dbxx.usrs AS B
			 ON A.shipped_usr_id
			    = 
			    B.usr_id
			 WHERE CAST(date_shipped AS DATE) >= '11/01/14'
			 and release_num = 1
			 AND if_tran_code in ('VERIFY','VERIFY-Q')
	  )AS Packer
	  ON RMA.PowerhouseOrderId
		= 
		Packer.order_id
		LEFT JOIN
	   (SELECT 
		  SecondaryLocationName
		  ,ProductBarCode
		  ,PickerName
		  ,PickerBarCode
	   FROM LPPick.dbo.PickLines AS A
			 INNER JOIN
		  LPPick.dbo.Pickers AS B
			 ON A.PickerId = B.PickerId) AS LP
	   ON RMA.PowerhouseOrderID = LP.SecondaryLocationName
	   AND RMA.ProductSKU = LP.ProductBarCode