/***Open orders exculding KT's and SI***/

SELECT
		COUNT(distinct([Order_id]))

FROM
		[PH_PROD].[dbxx].[Order_Lines]

WHERE 
		[item_id] NOT LIKE 'KT%' AND [item_id] NOT LIKE 'SI%' AND [item_id] NOT LIKE 'he%' AND [item_id] NOT LIKE 'CR1003' AND [item_id] NOT LIKE 'cr1004'



