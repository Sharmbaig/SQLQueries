


SELECT 
	cast(a.cust_id as int) as 'Customer_id February',
    COUNT (a.cust_Id) as 'Total_Orders'
FROM [ph_prod].dbxx.[hi_orders] AS A 
WHERE cast(a.Date_Ordered as date) between '2/1/2014' and '2/28/2014'
GROUP BY Cust_Id
order by cast(cust_id as int) asc


SELECT 
	cast(a.cust_id as int)as 'Customer_id YTD',
    COUNT (a.cust_Id) as 'Total_Orders'
FROM [ph_prod].dbxx.[hi_orders] AS A 
WHERE cast(a.Date_Ordered as date) between '1/1/2014' and '2/28/2014'
GROUP BY Cust_Id
order by cast(cust_id as int) asc

SELECT
	
	a.order_id as 'Order Id',
	a.PO_num As 'Zoyto Number',
	cast (a.Date_ordered as date) as 'Date Ordered',
	cast (a.Date_shipped as date) As 'Date Shipped',
	a.cust_id as 'Customer Number',
	a.s_contact As 'Customer Name',
	b.item_id as 'Item',
	D.PickerName as 'Picker Name',
	U.[full_name] AS 'Packer name',
	e.if_tran_code as 'Verification'
FROM 
	[PH_PROD].[dbxx].[hi_orders] as A
		join 
	[PH_PROD].[dbxx].[if_transaction] as B
		on a.order_id = b.order_id
		left join 
	[lppick].[dbo].[pickers] as D
		on b.usr_id = D.pickerbarcode
		left join
	[PH_PROD].[dbxx].[usrs] AS U
		ON A.[shipped_usr_id] = U.[usr_id]
		left join
	[ph_prod].dbxx.if_transaction as E
	on a.order_id = e.order_id
where 
	b.[if_tran_code] = 'pop-pick'
	and
	e.if_tran_code in ('Verify', 'verify-q')
	and
	a.po_num in ('6037954-13',
'6037954-13',
'6281923',
'6281923',
'6281923',
'6315329',
'6033396',
'6286545-5',
'R-6322206',
'6541023',
'6409518-1',
'6069548-3',
'6388935',
'6131175-4',
'6131175',
'6131175',
'6131175-1',
'6451028',
'6177328',
'6177328',
'6423073',
'6423073')