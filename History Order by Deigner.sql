/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	cast(a.cust_id as int),
    COUNT (a.cust_Id)
FROM [ph_prod].dbxx.[hi_orders] AS A 
WHERE cast(a.Date_Ordered as date) between '1/1/2014' and '1/31/2014'
GROUP BY Cust_Id
order by cast(cust_id as int) asc
