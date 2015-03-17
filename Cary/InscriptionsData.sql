SELECT  
       ino.[INTPK]
       ,ino.[orderid]
       ,o.order_id
       ,ino.[lineitemid]
       ,ino.[stencilid1]
       ,ino.[sku1]
       ,ol.[item_id]
       ,ino.[font1]
       ,ino.[textlines1_1]
       ,ino.[textlines1_2]
       ,ino.[textlines1_3]
       ,ino.[DateCreated]
       ,o.[or_cust10]
       ,ol.[ol_cust9]
       ,ol.[ol_cust10]
       ,'//o2getesting.azurewebsites.net/images/' + CAST(ino.[orderid] AS VARCHAR) + '/' + CAST(ino.[lineitemid] AS VARCHAR)
FROM 
       PH_PROD.dbxx.hi_orders AS o
              INNER JOIN
       PH_PROD.dbxx.hi_order_lines ol
              ON o.order_id = ol.[order_id]
              RIGHT JOIN           
       [Metrics Reports].[dbo].[InscriptionOrders] ino
              ON ino.[orderid] = o.[or_cust10] AND ino.[lineitemid] = ol.[ol_cust9]

              --ON o.order_id = ol.order_id and ino.sku1 = ol.item_id
WHERE 
   o.order_id = '30040555'
