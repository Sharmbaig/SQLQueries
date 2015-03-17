
SELECT 
	T.order_type,
	T.item_id,
	t.pieces,
	r.pieces_per_case,
	(ceiling(T.pieces/r.pieces_per_case) - 1)* -1 as cases
FROM(
SELECT
	g.order_type,
	g.item_id,
	(h.pieces_available - G.pieces_ordered) as Pieces
FROM(
		SELECT      
		    a.[item_id]
			  ,b.order_type
      
		    ,sum(a.[pieces_ordered]) as pieces_ordered
		 FROM [PH_PROD].[dbxx].[order_lines] as a
				LEFT JOIN
				[PH_PROD].[dbxx].[orders] as B
				on a.order_id = b.order_id
		
			GROUP BY a.item_id, b.ORDER_TYPE) as G
	LEFT JOIN
			(
			SELECT 
			item_available,
			lane_type,
			SUM(pieces) as pieces_available
			FROM
			(
				SELECT 
					(CASE left(location_id,1)
						WHEN 'A' THEN 'RETAIL' 
						WHEN 'B' THEN 'RETAIL'
						WHEN 'C' THEN 'PARTY'
						WHEN 'D' THEN 'PARTY'
						WHEN 'E' THEN 'WHOLESALE'
						WHEN 'F' THEN 'PARTY'
						WHEN 'G' THEN 'WHOLESALE'
						WHEN 'H' THEN 'PARTY'
						end) as lane_type,
					 [item_id] as item_available,
					 ([pieces_onhand] - [pieces_hard]) as Pieces
     
				FROM [PH_PROD].[dbxx].[item_location]

				WHERE assign_flag = 'Y') as B
				
				GROUP BY lane_type, Item_available) as H
	on g.item_id = h.item_available and g.order_type = h.lane_type) as T
		LEFT JOIN
	[PH_PROD].[dbxx].[item_configuration] as R
		on t.item_id = r.item_id

	WHERE Pieces <= 0 and r.standard_cfg = 'Y' 
ORDER BY cases desc