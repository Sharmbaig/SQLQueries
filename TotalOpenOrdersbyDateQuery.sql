	SELECT 
	(O.[order_id]) 
	 ,[s_contact]
      ,[s_address1]
	  ,[s_city]
	  ,[s_phone]
	  
	  ,[or_cust2]
	  ,[item_id]
	  

FROM 
	[PH_PROD].[dbxx].[orders] AS O
		inner join 
	[PH_PROD].[dbxx].[order_lines] AS S
		ON O.order_id = s.order_id 
where item_id like 'RG%' 



