/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
		SUM([PickOrderQty]) AS [Total Pecies]
		,Lane
		,SUM(SEC)/60.0/60.0 AS [Time]
		--,B.[pickerName]
		,pickerId

FROM	(

SELECT 
      [ZoneId]
      
      ,[PickOrderQty]
	  ,LEFT([locationBarCode],1) AS [Lane]
   --   ,MAX([PickCompleteTime]) AS [End Time]
	  --,MIN([pickCompleteTime]) AS [Start Time] 
	  ,(DATEDIFF(MILLISECOND, MIN([pickCompleteTime]), MAX([PickCompleteTime])) /100.0) AS Sec
	  ,[PickerId]
      ,[SecondaryLocationName]
      
  FROM [LPPick].[dbo].[PickLines]

  WHERE CAST([PickCompleteTime] AS Date) BETWEEN '07/13/2014' AND '07/19/2014' AND LEFT([LocationBarCode],1) = 'a'
  GROUP BY [SecondaryLocationName],[ZoneId]
      ,[PickerId]
      ,[PickOrderQty]
	  ,LEFT([locationBarCode],1)) AS Pick
	--  LEFT JOIN
	--[LPPICK].[dbo].[Pickers] as b
	--on Pick.PickerId = b.PickerBarCode
GROUP BY 	
		Lane
		
		,PickerId