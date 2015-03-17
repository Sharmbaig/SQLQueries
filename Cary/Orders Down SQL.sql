select 
	if_action_id='A'						--Done
	,warehouse_id='OOWH'					--Done
	,owner_id='OOWL'						--Done
	,order_id=o.OrderID						--Done
	,release_num=''							--Done
	,carrier_id=''							--leave blank
	,truck_id=''							--leave blank
	,parcel_code='P'						--Done - Always P = Parcel
	,ship_method=N''	--Leave blank
	,b_company=ca.PrimaryBillingName		--Done
	,b_address1=substring(ca.PrimaryBillingAddress,1,35) --Done
	,b_address2=substring(ca.PrimaryBillingAddress,36,35) --Done
	,b_address3=substring(ca.PrimaryBillingAddress,71,35) --Done
	,b_address4=''							--leave blank
	,b_address5=''							--leave blank
	,b_city=ca.PrimaryBillingCity			--Done
	,b_state=ca.PrimaryBillingState			--Done
	,b_zip=ca.PrimaryBillingZip				--Done
	,b_country=ca.PrimaryBillingCountry		--Done
	,b_contact=c.LastName + ', ' + c.FirstName		--Done
	,b_phone=c.Phone						--Done
	,b_fax=''								--leave blank
	,s_company=o.Company					--Done
	,s_address1=substring(o.address1,1,35)
	,s_address2=case when len(o.address1) > 35 then substring(o.address1,36,35) 
		 when len(o.address1) <= 35 then substring(o.Address2, 1, 35) 
		 else '' end
	,s_address3=case when len(o.address1) > 35 then substring(Address2,1, 35)
		 when len(o.address1) <= 35 and len(address2) > 35 then substring(address2,36,35) 
		 when len(o.address1) <= 35 and len(address2) <= 35 then '' 
		 else '' end
	,s_address4=case when len(o.address1) > 35 and len(address2) > 35 then substring(address2, 36,35) else '' end
	,s_address5=''							--leave blank
	,s_city=o.City							--Done
	,s_state=o.State						--Done
	,s_zip=o.Zip							--Done
	,s_country=o.Country					--Done
	,s_contact=c.LastName + ', ' + c.FirstName	--Done
	,s_phone=case when len(o.Phone) < 2 then '(888) 491-0331' else o.phone end  --Done
	,s_fax=''								--leave blank
	,po_num=o.OrderID						--Done
	,date_ordered=OrderDate
	,pallet_type=''							--leave blank
	,min_delivery_date=''					--leave blank
	,best_delivery_date=''					--leave blank
	,late_delivery_date=''					--leave blank
	,location_id_load=''					--leave blank
	,order_type=case when o.OrderTypeID = 1 then 'SPC'
					 when o.OrderTypeID = 2 then 'PTH'
	                 when o.OrderTypeID = 3 then 'REG'
					 when o.OrderTypeID = 11 and PriceTypeID = 1 then 'WEB'
					 when o.OrderTypeID = 11 and PriceTypeID = 2 then 'DSN'
			    else null end		--Currently in Zoyto it's WEB,DSN, PTH etc - do these values matter at all in Powerhouse? 
	,order_priority=''						--leave blank
	,expedite_flag='N'						--Done
	,stretch_flag='N'						--Done
	,qc_inspect_flag='N'					--Done
	,pick_complete_flag=''					--leave blank
	,pick_group_code=''						--leave blank
	,ship_group_code=''						--leave blank
	,cust_id=case when o.OrderTypeID = 11 and o.PriceTypeID = 2 and o.WarehouseID = 1 then o.Other13 else o.CustomerID end
	,label_form_id=''						--leave blank
	,report_form_id=''						--leave blank
	,pick_rule=''							--leave blank
	,total_value=o.SubTotal					--Done
	,ship_comment=replace(replace(replace(o.notes, char(10), ''),char(13),''),'"','')					--Done
	,usr_id=''								--May need to delete - it's expecting a PH ID I think
	,invoice_num=''							--leave blank
	,invoice_flag=''						--leave blank
	,tax_rate=null							--Need to blank out - we calc that not Exigo
	,shipping_charge=null					--Need to blank out - we calc that not Exigo
	,handling_charge=''						--leave blank
	,chrg_frt_flag=''						--leave blank
	,prepack_qty=''							--leave blank
	,service_level=''						--leave blank
	,inside_delivery=''						--leave blank
	,std_account_num=''						--leave blank
	,san_shipment=''						--leave blank
	,freight_terms=''						--leave blank
	,ship_by_date=''						--leave blank
	,frt_charge=''							--leave blank
	,group1=convert(varchar(100), o.PartyID)						--Needs Value
	,group2=''								--leave blank
	,group3=''								--leave blank
	,allow_recalc_flag='Y'					--Done
	,allow_ship_flag='Y'					--Done
	,suspend_flag=''						--leave blank
	,cod_flag=''							--leave blank
	,cod_amount=''							--leave blank
	,cod_cash_only_flag=''					--leave blank
	,sat_delivery_flag=''					--leave blank
	,declared_value=''						--leave blank
	,cert_mail_flag=''						--leave blank
	,return_receipt_flag=''					--leave blank
	,hazardous_flag=''						--leave blank
	,or_cust1=''							--leave blank
	,or_cust2=o.other13
	,or_cust3=''							--leave blank
	,or_cust4=''							--leave blank
	,or_cust5=''							--leave blank
	,or_cust6=''							--leave blank
	,or_cust7=''							--leave blank
	,or_cust8=''							--leave blank
	,or_cust9=''							--leave blank
	,or_cust10=convert(Varchar(100), o.other20)						--leave blank
	,master_batch=''						--leave blank
	,master_order_flag=''					--leave blank
	,backorder_flag='N'						--Done
	,consol_id=''							--leave blank
	,thirdparty_id=''						--leave blank
	,allow_explode_flag=''					--leave blank
	,load_seq_num=''						--leave blank
	,stop_seq_num=''						--leave blank
	,fob_shipto_flag=''						--leave blank
	,store_id=''							--leave blank
	,ship_to_gln=''							--leave blank
	,buy_for_gln=''							--leave blank
	,dept_number=''							--leave blank
	,vendor_number=''						--leave blank
	,purchase_order_type=''					--leave blank
	,f_company=''							--leave blank
	,f_address1=''							--leave blank
	,f_address2=''							--leave blank
	,f_address3=''							--leave blank
	,f_address4=''							--leave blank
	,f_address5=''							--leave blank
	,f_city=''								--leave blank
	,f_state=''								--leave blank
	,f_zip=''								--leave blank
	,f_country=''							--leave blank
	,f_contact=''							--leave blank
	,f_phone=''								--leave blank
	,f_fax=''								--leave blank
	,residential_flag='Y'					--Can we make this smart? - Ignore for now
	,ship_complete_flag=''					--leave blank
	,email_address1=o.Email					--Done
	,email_address2=''						--leave blank
	,email_address3=''						--leave blank
	,close_complete_flag='Y'				--Done
	,unship_flag=''							--leave blank
	,cust_code=''							--leave blank
	,p_company=''							--leave blank
	,p_address1=''							--leave blank
	,p_address2=''							--leave blank
	,p_address3=''							--leave blank
	,p_address4=''							--leave blank
	,p_address5=''							--leave blank
	,p_city=''								--leave blank
	,p_state=''								--leave blank
	,p_zip=''								--leave blank
	,p_country=''							--leave blank
	,p_contact=''							--leave blank
	,p_phone=''								--leave blank
	,p_fax=''								--leave blank
	,packing_location_id=''					--leave blank
	,valadd_flag=case when (o.other20 is not null and o.other20 <> '') then 'Y' else 'N' end 	--This is the flag we use to detemrine if this order contains any customization items (Y/N) - Ignore for now
	,auto_pick_flag='N'						--Done
	,auto_ship_flag='N'						--Done
	,auto_recreate_flag='N'					--Done
	,email_address1_type='1'				--0- separate, 1- TO, 2- CC, 3- BCC - Done
	,email_address2_type=''					--leave blank
	,email_address3_type=''					--leave blank
	,signature_req_flag=''					--leave blank
	,division_id=''							--leave blank
	,expiration_th=''						--leave blank
	,pro_number=''							--leave blank
	,rma_flag=''							--leave blank
	,f_tax_id=''							--leave blank
	,s_tax_id=''							--leave blank
	,b_tax_id=''							--leave blank
	,p_tax_id=''							--leave blank
	,order_added_flag=''					--leave blank
	,host_id1=''							--leave blank
	,host_id2=''							--leave blank
	,host_id3=''							--leave blank
	,host_id4=''							--leave blank
	,is_backorder_flag=''					--leave blank
	,[shipmethod]=case when o.ShipMethodID in (2,3,6,9,10,18,22) then 'STD'
					   when o.ShipMethodID in (4,7,12,11,15,19) then '2DY'
					   when o.ShipMethodID in (5,8,13,14,16) then 'OVN'
					   when o.ShipMethodID in (17) then 'STDP'
					   WHEN o.shipmethodid IN (23,25,26,27,28,30) THEN 'STDA'
				  else '' end				--Done
FROM orders o
LEFT JOIN ordertypes ot 
	ON o.OrderTypeID = ot.OrderTypeID
LEFT JOIN shipmethods s
	ON o.shipmethodid = s.ShipMethodID
LEFT JOIN warehouses w
	ON o.warehouseid = w.Warehouseid
LEFT JOIN CustomerAccounts ca
	ON o.CustomerID = ca.CustomerID
LEFT JOIN customers c
	on o.CustomerID = c.CustomerID