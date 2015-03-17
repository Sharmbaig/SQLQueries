
	DECLARE @startdate as date,
	@enddate as date

	SET @startdate = '10/5/2014'
	SET @enddate = '10/5/2014';
	
	
	
	WITH ln AS (
	
	SELECT
	o.item_id,

	isnull(a.location_id , 'NOT ON LINE')as a_location_id,
	a.pieces_available as a_pieces_available,
	a.pieces_max as a_pieces_max,
	a.pieces_min as a_pieces_min,

	isnull(b.location_id , 'NOT ON LINE')as b_location_id,
	b.pieces_available as b_pieces_available,
	b.pieces_max as b_pieces_max,
	b.pieces_min as b_pieces_min,

	isnull(c.location_id , 'NOT ON LINE')as c_location_id,
	c.pieces_available as c_pieces_available,
	c.pieces_max as c_pieces_max,
	c.pieces_min as c_pieces_min,

	isnull(d.location_id , 'NOT ON LINE')as d_location_id,
	d.pieces_available as d_pieces_available,
	d.pieces_max as d_pieces_max,
	d.pieces_min as d_pieces_min,

	isnull(e.location_id, 'NOT ON LINE') as e_location_id,
	e.pieces_available as e_pieces_available,
	e.pieces_max as e_pieces_max,
	e.pieces_min as e_pieces_min,

	isnull(f.location_id, 'NOT ON LINE') as f_location_id,
	f.pieces_available as f_pieces_available,
	f.pieces_max as f_pieces_max,
	f.pieces_min as f_pieces_min,

	isnull(g.location_id, 'NOT ON LINE') as g_location_id,
	g.pieces_available as g_pieces_available,
	g.pieces_max as g_pieces_max,
	g.pieces_min as g_pieces_min,

	isnull(h.location_id, 'NOT ON LINE') as h_location_id,
	h.pieces_available as h_pieces_available,
	h.pieces_max as h_pieces_max,
	h.pieces_min  as h_pieces_min

	FROM(
	select
	distinct item_id
	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL') as o
	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'A') as a
	on o.item_id = a.item_id



	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'b') as b
	on o.item_id = b.item_id



	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'c') as c
	on o.item_id = c.item_id



	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'd') as d
	on o.item_id = d.item_id




	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'e') as e
	on o.item_id = e.item_id





	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'f') as f
	on o.item_id = f.item_id





	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'g') as g
	on o.item_id = g.item_id






	left join

	(select
	 item_id,
	 location_id,
	 pieces_onhand,
	 pieces_onhand - pieces_onhold - pieces_hard as pieces_available,
	 pieces_min,
	 pieces_max

	FROM
	ph_prod.dbxx.item_location as a
	where location_type = 'PTL' and substring(location_id,1,1) = 'h') as h
	on o.item_id = h.item_id),


	loc as (

SELECT*
		FROM(
		SELECT 
			item_id,
			location_id,
			pieces_onhand - pieces_onhold - pieces_hard as pieces_onhand,
			ROW_NUMBER() OVER (PARTITION BY item_id
                                ORDER BY pieces_onhand DESC) as [priority]
		FROM
			ph_prod.dbxx.item_location
		where location_type in( 'PTL') and item_id not in(
							SELECT
							item_id
							FROM
							ph_prod.dbxx.item_location
							where location_type in( 'PTL-RESTK') and pieces_onhand - pieces_onhold- pieces_hard >0 ) 

		UNION

		SELECT
		item_id,
		location_id,
		pieces_onhand - pieces_onhold- pieces_hard as pieces_onhand,
		ROW_NUMBER() OVER (PARTITION BY item_id
                                ORDER BY pieces_onhand DESC) as [priority]
		FROM
		ph_prod.dbxx.item_location
		where location_type in( 'PTL-RESTK') and pieces_onhand - pieces_onhold- pieces_hard >0 
		) as a

		where [priority] = 1)




	SELECT distinct
	a.item_id,
	a.pieces_ordered,
	loc.location_id as location_id_from,
	loc.pieces_onhand as Pieces_onhand_from,

	a_location_id,
	case when  a_pieces_available - a.pieces_ordered <2 then a_pieces_available - a.pieces_ordered else NULL END as a_pieces_available,

	b_location_id,
	case when  b_pieces_available- a.pieces_ordered <2 then b_pieces_available- a.pieces_ordered else NULL END as b_pieces_available,

	c_location_id,
	case when  c_pieces_available - a.pieces_ordered <2 then c_pieces_available - a.pieces_ordered else NULL END as c_pieces_available,

	d_location_id,
	case when  d_pieces_available - a.pieces_ordered <2 then d_pieces_available - a.pieces_ordered else NULL END as d_pieces_available,

	e_location_id,
	case when  e_pieces_available - a.pieces_ordered <2 then e_pieces_available - a.pieces_ordered else NULL END as e_pieces_available,

	f_location_id,
	case when  f_pieces_available - a.pieces_ordered <2 then f_pieces_available - a.pieces_ordered else NULL END as f_pieces_available,

	g_location_id,
	case when  g_pieces_available - a.pieces_ordered <2 then g_pieces_available - a.pieces_ordered else NULL END as g_pieces_available,

	h_location_id,
	case when  h_pieces_available - a.pieces_ordered <2 then h_pieces_available - a.pieces_ordered else NULL END as h_pieces_available




	FROM
	(
	SELECT
	item_id,
	sum(pieces_ordered) as pieces_ordered
	FROM
	PH_prod.dbxx.order_lines as a
	inner join
	ph_prod.dbxx.orders as b
	on a.order_id = b.order_id

	where cast(date_ordered as date) between @startdate and @enddate and order_status = '010'
	group by item_id) as a
	left join
	ln as b
	on a.item_id = b.item_id
	left join
		loc
		on a.item_id = loc.item_id
	where 
	
	(a_pieces_available is null or 
	b_pieces_available is null or 
	c_pieces_available is null or 
	d_pieces_available is null or 
	e_pieces_available is null or 
	f_pieces_available is null or 
	g_pieces_available is null or 
	H_pieces_available is null) or 

	
	
	(a_pieces_available - a.pieces_ordered <2 or
	b_pieces_available- a.pieces_ordered <2 or
	c_pieces_available- a.pieces_ordered <2 or
	d_pieces_available- a.pieces_ordered <2 or
	e_pieces_available- a.pieces_ordered <2 or
	f_pieces_available- a.pieces_ordered <2 or
	g_pieces_available- a.pieces_ordered <2 or 
	h_pieces_available- a.pieces_ordered <2)