UPDATE PH_PROD.dbxx.orders
SET route_code = 'STDS',
route_code_cart = 'STDS'
WHERE order_id in 
(SELECT	
	order_id
FROM PH_PROD.dbxx.order_lines
WHERE item_id = 'SI2004')
AND route_code like 'STD%'
AND s_state <> 'PR'