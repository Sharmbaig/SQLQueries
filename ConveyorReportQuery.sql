SELECT 
      [STATE_NAME]
	  ,[ACTIVE_TIMESTAMP]
      ,[CLEARED_TIMESTAMP]    
  FROM [DataWarehouseSupport].[dbo].[HMI_Alert_Log]
  where ACTIVE_TIMESTAMP between '03/02/2014' and '3/04/2014'
  order by ACTIVE_TIMESTAMP desc
 