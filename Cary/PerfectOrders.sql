SELECT
		DATEPART(Year, G.[Date Ordered]) AS[Year],
	   DATEPART(week, G.[Date Ordered]) AS [Week] , 
	   [Error Type] , 
	   COUNT( order_id
			)AS Orders
  FROM( 
		SELECT 
			   [Date Ordered] , 
			   CASE
			   WHEN isFulfilledOntime
					= 
					'N'
				AND hasErrors = 'N' THEN 'Time'
			   WHEN hasErrors = 'Y'
				AND isFulfilledOntime
					= 
					'Y' THEN 'Accuracy'
			   WHEN isFulfilledOntime
					= 
					'N'
				AND hasErrors = 'Y' THEN 'Both'
				   ELSE 'Perfect'
			   END AS [Error Type] , 
			   order_id
		  FROM( 
		SELECT
			   E.[Date Ordered] , 
			   E.[Date Shipped] , 
			   E.order_id , 
			   E.route_code , 
			   E.[Ship Type] , 
			   E.[Time to Fulfill] , 
			   E.isFulfilledOntime , 
			   E.hasErrors
		  FROM( 
		SELECT
			   B.[Date Ordered] , 
			   B.[Date Shipped] , 
			   B.order_id , 
			   B.route_code , 
			   B.[Ship Type] , 
			   B.[Time to Fulfill] , 
			   B.isFulfilledOntime , 
			   E.DefectiveCount AS [Defective Product] , 
			   E.FulfillmentErrorCount AS [Fulfillment Error] , 
			   E.OtherCount AS [Other Errors] , 
			   CASE
			   WHEN E.DefectiveCount + E.FulfillmentErrorCount + E.OtherCount
					> 
					0 THEN 'Y'
				   ELSE 'N'
			   END AS hasErrors
		  FROM
			  ( 
		SELECT
			   [Date Ordered] , 
			   [Date Shipped] , 
			   order_id , 
			   route_code , 
			   CASE
			   WHEN route_code LIKE 'STD%' THEN 'Standard'
				   ELSE 'Expedited'
			   END AS [Ship Type] , 
			   Hours AS [Time to Fulfill] , 
			   Bucket , 
			   CASE
			   WHEN Bucket
					= 
					'<1 Business Day'
				AND route_code LIKE 'OVN%' THEN 'Y'
			   WHEN Bucket
					= 
					'<1 Business Day'
				AND route_code LIKE '2D%' THEN 'Y'
			   WHEN Bucket IN( '<1 Business Day' , '1-2 business days'
							 )
				AND route_code LIKE 'STD%' THEN 'Y'
				   ELSE 'N'
			   END AS isFulfilledOntime
		  FROM( 
		SELECT
			   [Date] AS [Date Ordered] , 
			   CAST( date_shipped AS date
				   )AS [Date Shipped] , 
			   order_id , 
			   route_code , 
			   Hours , 
			   Bucket
		  FROM [Metrics Reports].dbo.View_avgtimetofulfillorderreport
			  )AS A
			  )AS B
			  LEFT JOIN
			  ( 
		select [powerhouseorderid],
sum(case when [primaryreason] = 'Product Failure' then 1 else 0 end) DefectiveCount,
sum(case when [primaryreason] in ('Missing Item', 'Wrong Item') then 1 else 0 end) FulfillmentErrorCount,
sum(case when [primaryreason] not in ('Missing Item', 'Wrong Item','Product Failure') then 1 else 0 end) OtherCount
from [Metrics Reports].dbo.RMADailyReports rr
GROUP BY powerhouseorderid

			  )AS E
			  ON B.order_id
				 = 
				CAST( E.[powerhouseorderid] AS VARCHAR)
		  WHERE [Date Ordered] BETWEEN '2014-11-01' AND '2015-03-07'
			  )AS E
			  )AS F
	  )AS G
  GROUP BY
		    DATEPART(week, G.[Date Ordered]), DATEPART(Year, G.[Date Ordered]) ,
		   [Error Type];
