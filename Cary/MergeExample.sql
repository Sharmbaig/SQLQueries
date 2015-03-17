MERGE [Metrics Reports].dbo.ExigoOrders AS target
USING
 ( SELECT
		orderid,
		customerid,
		orderstatusid,
		orderdate,
		shipmethodid,
		ordertypeid,
		firstname,
		lastname,
		address1,
		address2,
		city,
		[state],
		zip,
		country,
		total,
		subtotal,
		taxtotal,
		shippingtotal,
		other12,
		other13,
		replacementorderid,
		returnorderid,
		createddate,
		modifieddate,
		createdby,
		modifiedby,
		itemcode,
		orderline,
		quantity
	 FROM [Metrics Reports].dbo.ExigoOrders
 ) AS SOURCE
ON target.orderid
   =
   source.orderid
WHEN MATCHED
	  THEN
	  UPDATE
	  SET
		Target.orderid= source.orderid,
		Target.customerid = source.customerid,
		Target.orderstatusid= source.orderstatusid,
		Target.orderdate=source.orderdate,
		Target.shipmethodid=source.shipmethod,
		Target.ordertypeid= source.ordertypeid,
		target.firstname=source.firstname,
		target.lastname=source.lastname,
		target.address1=source.address1,
		target.address2=source.address2,
		target.city=source.city,
		target.[state]=source.[state],
		target.zip=source.zip,
		target.country=source.country,
		target.total=source.total,
		target.subtotal=source.subtotal,
		target.taxtotal=source.taxtotal,
		target.shippingtotal=source.shippingtotal,
		target.other12=source.other12,
		target.other13=source.other13,
		target.replacementorderid=source.replacementorderid,
		target.returnorderid,
		target.createddate,
		target.modifieddate,
		target.createdby,
		target.modifiedby,
		target.itemcode,
		target.orderline,
		target.quantity
WHEN NOT MATCHED
	  THEN
	  INSERT
			 (
			 [orderid] ,
			 [customerid] ,
			 [orderdate] ,
			 [total] ,
			 [subtotal] ,
			 [taxtotal] ,
			 [shippingtotal] ,
			 [other13] ,
			 [other17] ,
			 [returnorderid] ,
			 [replacementorderid] ,
			 [createddate] ,
			 [modifieddate] ,
			 [shippeddate] ,
			 [modifiedby]
			 )
	  VALUES
			 ( source.orderid ,
			   source.customerid ,
			   source.orderdate ,
			   source.total ,
			   source.subtotal ,
			   source.taxtotal ,
			   source.shippingtotal ,
			   source.other13 ,
			   source.other17 ,
			   source.returnorderid ,
			   source.replacementorderid ,
			   source.createddate ,
			   source.modifieddate ,
			   source.shippeddate ,
			   source.modifiedby
			 );
