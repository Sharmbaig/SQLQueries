select
item_id,
pieces_onhand
FROM
ph_prod.dbxx.item_location
where substring(location_id,1,1) = 'h' and (pieces_onhand - pieces_hard - pieces_onhold) <=25 and assign_flag = 'Y'