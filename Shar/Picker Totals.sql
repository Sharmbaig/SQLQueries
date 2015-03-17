/** Total Units, Orders and Errors Per Picker**/
DECLARE
		@StartDate AS Date,
		@EndDate AS Date
SET @StartDate = '07/07/2014'
SET @EndDate = '07/11/2014'

 SELECT 
		Verify.Date
		,[PickerName]
		,SUM(Verify.[pieces]) AS [Total Units]
		,COUNT(DISTINCT Verify.Order_Id) AS [Orders Verified]
		,COUNT(Errors.order_id) AS [Orders W/ Errors]
 FROM
		

(SELECT
     E.[order_id],
	 [Item_id]
  FROM [PH_PROD].[dbxx].[exceptions2] AS E
		WHERE [exception_type] in ( 'DEFECTIVE','PACKER','INVENTORY') and CAST(E.[activity_date] AS DATE) between dateadd(day, -1, @StartDate) and dateadd( day, 1,@EndDate)) AS Errors

RIGHT JOIN

(SELECT
		[PickerName]
		,[LocationBarCode]
		,[order_id]
		,[pieces]
		,[if_tran_code] AS [Orders Verified]
		,CAST([activity_date] AS DAte) AS [Date]
		,item_id

FROM 
		[PH_PROD].dbxx.[if_transaction] AS A
INNER JOIN
		[LPPick].[dbo].[Pickers] AS LP
INNER JOIN
		[LPPick].[dbo].[PickLines] AS L

ON
LP.PickerBarCode = A.usr_id
ON
L.LocationBarCode = PickerBarCode
WHERE [if_tran_code] = 'POP-Pick' and order_id IN (Select order_id FROM [PH_PROD].dbxx.[if_transaction] WHERE if_tran_code = 'Verify')  AND CAST([activity_date] AS DATE) between @StartDate and @EndDate) AS Verify

ON
Errors.Order_id = Verify.Order_id AND Errors.item_id = Verify.item_id
GROUP BY
		Verify.Date
		,[PickerName]
		order by pickername, date