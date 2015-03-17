/**Picker Logs by Date and Time**/
SELECT 
		CAST([EventDateTime] AS Date) AS [Date]
		,[PickerName]
		,[Barcode],
		 [EventDateTime]
		,[Barcode]
		
  FROM [LPPick].[dbo].[ScanEvents]
WHERE CAST([EventDateTime] AS DATE) = '07/02/14'

ORDER BY [PickerName]