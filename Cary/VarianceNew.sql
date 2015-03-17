SELECT 
       [cyc_id]
      ,[item_id]
	  ,[location_id]
      ,[description]
      ,[inv_type]
      ,[cfg_code]
      ,[piece_count]
      ,[act_piece_count]
	  ,(act_piece_count - piece_count) AS [Variance]
	  ,ABS((act_piece_count - piece_count)/act_piece_count) AS [Variance Percentage]
  FROM [PH_TEST].[dbxx].[cyc_paper_detail]
  WHERE act_piece_count > 0