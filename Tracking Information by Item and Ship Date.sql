--- Tracking information by Item and Ship Date
--- Tracking_Number the "," is so that excel will read the proper numbers.
--- s_ = Shipping information
--- b_ = Billing Information

DECLARE
		 @Startdate AS Date
		,@Enddate AS Date
		,@item_id AS CHAR (30)
		,@cust_id AS CHAR (15)
SET
		 @cust_id = '1000'
SET
		 @item_id = 'lk1013'
SET
		 @Startdate = '5/22/2014'
SET
		 @Enddate = '5/23/2014'

SELECT 
		 CONVERT(VARCHAR,c.[date_ordered],101) AS [Order Date]
		,c.[cust_id] AS [Customer ID]
		,c.[s_contact] AS [Customer Name] 
		,c.[s_address1] AS [Address]
		,c.[s_city] AS [City]
		,c.[s_state] AS [State]
		,c.[s_phone] AS [Phone Number]
		,c.[email_address1] AS [Email Address] 
		,b.[order_id] AS [Order Number]
		,c.[order_type] AS [Order Type]
		,c.[po_num] As [PO Number]
		,a.[item_id] AS [Item]
		,a.[pieces_ordered] AS [Pieces Ordered]
		,b.[carrier_id] AS [Carrier]
		,CONCAT(',',[package_trace_id]) As [Tracking Number]
		,CONVERT(VARCHAR,[ship_date], 101) AS [Date Shipped]

FROM [ph_prod].[dbxx].[hi_work_cartons] AS B

INNER JOIN
			[ph_prod].[dbxx].[hi_order_lines] AS A
		ON 
			a.[order_id] = b.[order_id]

INNER JOIN
			[ph_prod].[dbxx].[hi_orders] AS C
		ON
			c.[order_id] = a.[order_id]
WHERE	
		a.[item_id] IN (@item_id) AND CAST([ship_date] AS Date) BETWEEN @Startdate AND @enddate AND c.[cust_id] IN (@cust_id)


