SELECT
		hol.order_id AS orderid,
		hol.order_line AS orderline,
		itemid = '', --See William or Cary for this number from exigo
		hol.item_id  AS itemcode,
		im.description AS ItemDescription,
		pieces_ordered AS Quantity,
		PriceEach = '', --This is the price paid for the item??
		PriceTotal = '', --Is this a calculated field
		Tax='', --calculated field 
		WeightEach = '', --is this used?
		[Weight] = '', --Calculated Field?
		BusinessVolumeEach= '',--Is this a set field?
		BusinessVolume = '', --Calculated by BVeach times quantity?
		CommissionableVolumeEach = '', --set field?
		CommissionableVolume = '', --Calculated by CV Each times quanity?
		Other1Each = '', -- ?
		Other1 = '',--?
		Other2Each = '', -- ?
		Other2 = '',--?
		Other3Each = '', -- ?
		Other3 = '',--?
		Other4Each = '', -- ?
		Other4 = '',--?
		Other5Each = '', -- ?
		Other5 = '',--?
		Other6Each = '', -- ?
		Other6 = '',--?
		Other7Each = '', -- ?
		Other7 = '',--?
		Other8Each = '', -- ?
		Other8 = '',--?
		Other9Each = '', -- ?
		Other9 = '',--?
		Other10Each = '', -- ?
		Other10 = '',--?
		ParentItemID = '', --This is for kitting and BOM?
		Taxable = '',--This flag is to indicate that the item should have tax
		FedTax = '',
		StateTax = '',
		CityTax = '',
		CityLocalTax = '',
		CountyTax = '',
		CountyLocalTax = '',
		ManualTax = '',
		isStateTaxOverride = ''

FROM PH_PROD.dbxx.hi_order_lines hol
					INNER JOIN 
			PH_PROD.dbxx.item_master im
				ON hol.item_id = im.item_id