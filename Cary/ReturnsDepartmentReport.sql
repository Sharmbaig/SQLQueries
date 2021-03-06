/****** Script for SelectTopNRows command from SSMS  ******/
SELECT CAST([Date] AS DATE) AS [Date]
	  ,[CSR User]
      ,COUNT(DISTINCT [Original Order ID]) As [Original Orders Processed]
      ,COUNT([Order ID]) AS [Total Reship Orders Created]
  FROM [Metrics Reports].[dbo].[reships]
  WHERE 
  [CSR User] in 
  ('Chris Perrino'
,'Ryann Padilla'
,'Jasmin Ortiz'
,'Cindy Bunch'
,'Leizel Roedell'
,'Pam Johnson'
,'Julia Flores'
,'Salia Olomua'
,'Jyoti Tumber'
,'Nikki Rango')
AND CAST([Date] AS DATE) between '10/01/14' and '10/10/14'
GROUP BY [Date],[CSR User]
ORDER BY [CSR User],[Date]
