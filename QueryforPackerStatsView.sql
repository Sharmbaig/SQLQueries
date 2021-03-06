
SELECT DISTINCT 
	 A.[usr_id]
	,A.[activity_date]
	,A.[slot3] AS [Start_Time]
	,A.[activity_time] AS [Ship Time]
	,B.[activity_time] AS [Verify Time]
	,A.[location_id_from]
	,A.[requester]
	,a.[slot0] AS [Tot_Orders]
	,A.[slot1] AS [Tot_Lines]
	,A.[slot2] AS [Tot_units]
	,A.[slot4] AS [Tot_time_in_Seconds]
	,B.[if_tran_code]
	
FROM
(SELECT 
       [usr_id]
      ,[activity_date]
      ,[activity_time]
      ,[location_id_from]
      ,[job_number]
      ,[requester]
      ,[slot0]
      ,[slot1]
      ,[slot2]
      ,[slot3]
      ,[slot4]
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE [if_tran_code] in ( 'SHIP-PACK','SHP-PACK','SHIP-PACKQ','SHP-PACKQ')AND location_id_from <> 'KPS-01')AS A
		
				LEFT JOIN
(SELECT 
       [if_tran_code]
	  ,[usr_id]
      ,[activity_date]
      ,[activity_time]
      ,[location_id_from]
      ,[order_id]
      ,[requester]
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE [if_tran_code] in ( 'VERIFY','VERIFY-Q')
  AND location_id_from <> 'KPS-01') AS B
				ON A.[usr_id] = B.[usr_id] and A.[location_id_from] = B.[location_id_from] and A.[activity_date] = B.[activity_date] AND A.[requester] = B.[requester]

