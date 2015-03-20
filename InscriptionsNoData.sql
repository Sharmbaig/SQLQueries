SELECT  [INTPK]
      ,ino.[orderid]
		,eo.orderstatusid
      ,eo.orderid
      ,[lineitemid]
      ,[stencilid1]
      ,[sku1]
                  ,eo.itemcode
      ,[font1]
      ,[textlines1_1]
      ,[textlines1_2]
      ,[textlines1_3]
      ,[DateCreated]
	  ,eo.other20
	  ,eo.other9
	  ,eo.other9each
                  ,'//o2getesting.azurewebsites.net/images/' + CAST(ino.orderid AS VARCHAR) + '/' + CAST(lineitemid AS VARCHAR)
  FROM [Metrics Reports].[dbo].[InscriptionOrders] ino
                                                                                                LEFT JOIN
                                                  [Metrics Reports].dbo.ExigoOrdersTEMP eo
															ON ino.orderid = eo.other20 AND ino.lineitemid = eo.other9 AND ino.sku1 = eo.itemcode



