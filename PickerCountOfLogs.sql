SELECT 
		[PickerName]
		,[Barcode]
		,COUNT([Barcode])
  FROM [LPPick].[dbo].[ScanEvents]
WHERE CAST([EventDateTime] AS DATE) = '06/23/14'
GROUP BY [PickerName]
,[Barcode]
ORDER BY [PickerName]