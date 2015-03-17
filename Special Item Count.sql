 /****** Special Items in the system  ******/
SELECT 
		[Date Ordered]
		,items
		,COUNT(DISTINCT [Total Open])AS [Total Open]
FROM
/**Sub Query**/	
(
SELECT	 
		CAST([date_ordered] AS Date) AS [Date Ordered]

		,CASE WHEN [item_id] like 'KT3%' OR item_id LIKE'SI%'
		THEN 'STS'
		WHEN item_id LIKE 'KT1%' 
		THEN 'Business Basics'
		WHEN item_id like 'HE%'
		THEN 'Hostess Exclusive'
		WHEN item_id like 'RG%'
		THEN 'RG'
		WHEN item_id LIKE 'SI%'
		THEN 'Sales Incentive'
		WHEN item_id Like 'SA%' OR item_id LIKE 'CC%'
		THEN 'Business Supply'
		ELSE 'OTHER'
		END AS Items

		,O.[order_id] as [Total Open]
   
FROM [PH_PROD].[dbxx].[order_lines] AS L
	
	INNER JOIN
		[PH_PROD].[dbxx].[orders] AS O

		ON L.[order_id] = O.[order_id]

WHERE (item_id like 'KT%' 
		OR item_id like 'HE%' 
		OR item_id like 'HE' 
		OR item_id LIKE 'RG%' 
		OR item_id LIKE 'SI%' 
		OR item_id LIKE 'CC%' 
		OR item_id LIKE 'SA%') 
		AND Date_ordered BETWEEN '10-01-2014' AND '11-24-2014'
) AS A
GROUP BY [Date Ordered], Items
ORDER BY [Date Ordered]
		




