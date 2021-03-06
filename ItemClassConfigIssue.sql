
SELECT 
      [item_id]
      ,[description]
      ,[item_class]
      ,[current_velocity]
      ,[last_count]
      ,[default_cfg]
      ,[default_inv_type]
      ,[host_tracking_flag]
      ,[vendor_id]
      ,[must_include_flag]
      ,[cyc_tolerance]
      ,[allow_explode_flag]
  FROM [PH_PROD_OLD2].[dbxx].[item_master]
  WHERE item_id like'CH%' and item_class <> 'CHARMS' 
  OR item_id like 'DG%' and item_class <> 'DANGLES'
  OR item_id like 'EES%' and item_class <> 'EES'
  OR item_id like 'CES%' and item_class <> 'CES'
  OR item_id in ('HP%', 'PS%', 'PR%', 'PG1%', 'PG2%', 'PG3%') and item_class <> 'PLATES'
  OR item_id like 'CN%' and item_class <> 'CHAINS'
  OR item_id like 'BR%' and item_class <> 'CHAINS'
  OR item_id like 'ER%' and item_class <> 'EARRINGS'
  OR item_id like 'BZ%' and item_class <> 'BEZZLES'
  OR item_id like 'SA%' and item_class <> 'BUSINESS SUPPLY'
  OR item_id like 'LK%' and item_class <> 'LOCKETS'
  OR item_id like 'SP' and item_class <> 'SPECIAL'
  OR item_id like 'KT' and item_class <> 'BUSINESS SUPPLY'
  OR item_id like 'HE%' and item_class <> 'HOSTESS EXCLUSIVE'
  
  




