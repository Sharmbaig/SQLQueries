/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	DISTINCT [CSR User]
	,[10/13/14]
	,[10/14/14]
	,[10/15/14]
	,[10/16/14]
	,[10/17/14]
FROM (SELECT
	  CAST([Date] AS DATE) AS [Date]
	  ,[CSR User]
      ,[Order ID] 
  FROM [Metrics Reports].[dbo].[reships]
  WHERE 
  [CSR User] in 
 ('Christine Perrino'
,'Ryann Padilla'
,'Jasmin Ortiz'
,'Cindy Bunch'
,'Leizel Rodell'
,'Pam Johnson'
,'Julia Flores'
,'Salia Olomua'
,'Jyoti Tumber'
,'Nicole Rango')
AND CAST([Date] AS DATE) between '10/12/14' and '10/18/14') AS [Source]
PIVOT
(COUNT([Order ID]) FOR [Date] in ([10/13/14],[10/14/14],[10/15/14],[10/16/14],[10/17/14])) AS
[Pivot]