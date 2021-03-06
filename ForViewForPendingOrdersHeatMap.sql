WITH ZoneMap AS (SELECT TOP (100) PERCENT 
                location_id
                        ,item_id
                        ,CASE WHEN substring(ItemLoc.location_id,1,1) = 'A' THEN 'RETAIL'
                             WHEN substring(ItemLoc.location_id,1,1) = 'D' THEN 'PARTY'
                                  WHEN substring(ItemLoc.location_id,1,1) = 'E' THEN 'WHOLESALE'
                                  END AS LaneType
                     FROM PH_PROD.dbxx.item_location AS ItemLoc
            WHERE substring(ItemLoc.location_id,1,1) in ('A','D','E')
            GROUP BY location_id, item_id
            ORDER BY location_id)




SELECT   TOP (100) PERCENT
         Z.item_id,
              
              iif(upper(rtrim(order_type)) = 'PARTY',round(SUM(L.pieces_to_pick) / 4, 0), Round(SUM(L.pieces_to_pick) / 2, 0)) AS Units
              , O.order_type, location_id
FROM    PH_PROD.dbxx.orders AS O
              INNER JOIN PH_PROD.dbxx.order_lines L ON L.order_id = O.order_id 
        INNER JOIN ZoneMap AS Z ON O.[order_type] = Z.[LaneType] AND l.[item_id]= Z.[item_id]

GROUP BY O.order_type, Z.item_id, location_id
ORDER BY  Z.item_id
