DECLARE @StartDate DATE, @EndDate DATE;
SET @StartDate = '01/01/14'
SET @EndDate = '11/12/14'
SELECT
    DATEPART(week,[Date]) AS [Week]
    ,MIN([Date]) AS [Week Start Date]
    ,[Shipment Type]
    ,COUNT(order_id) AS [Total Orders]
    ,SUM(tot_shipped) AS units
FROM
(SELECT
    CAST(date_shipped AS DATE) AS [Date]
    ,CASE WHEN total_value <= 0
	   THEN 'Non Revenue'
	   WHEN total_value > 0
	   THEN 'Revenue'
	   END AS [Shipment Type]
    ,order_id
    ,tot_shipped
FROM PH_PROD.dbxx.hi_orders
WHERE CAST(date_shipped AS DATE) between @StartDate and @EndDate)AS A
WHERE [Shipment Type] IS NOT NULL
GROUP BY DATEPART(WEEK,[Date]),[Shipment Type]
ORDER BY [Week],[Shipment Type]
