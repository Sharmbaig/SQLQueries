SELECT
	ho.order_id,
	email_address1,
	s_contact,
	s_address1,
	s_address2,
	s_city,
	s_state,
	s_zip,
	s_country,
	s_phone,
	package_trace_id,
	date_ordered,
	date_shipped
FROM PH_PROD.dbxx.hi_orders as ho
		INNER JOIN
	PH_PROD.dbxx.hi_work_cartons as hwc
		ON ho.order_id = hwc.order_id and ho.release_num = hwc.release_num
WHERE ho.order_id like 'CA%'