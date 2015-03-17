SELECT 

      [activity_date]
	  ,[activity_time]
	  ,[if_tran_code] 
	  ,[adj_code]
      ,[item_id]
	  ,CASE WHEN [sign_code] = '-' THEN CAST(-[pieces] AS INT) ELSE CAST([pieces] AS INT) END AS [Pieces]
  FROM [PH_PROD].[dbxx].[if_transaction]
  where [if_tran_code] in (SELECT [if_tran_code] FROM [METRICS_SUMMARIES].[dbo].[adjustmenttrancodes] WHERE [if_tran_code] NOT IN('REC-DEC','REC-INC','MERGE-INC','MERGE-DEC'))

  
