DECLARE @StartDate AS DATETIME,@EndDate AS DATETIME;
SET @StartDate = '06/20/14 01:00:00'
SET @EndDate = '06/20/14 23:30:00' ;

WITH ACT as (
SELECT 
	[full_name],
	location_id_from as [Pack Station]
	,ISNULL([Hours],0)AS[Hours]
	,[Total Orders]AS [Orders]
	,ISNULL([Total Units],0)AS [Units]
    ,ISNULL([Total Units],0)/[Hours] as PerHour
FROM(
SELECT  
       U.[full_name],
	   i.location_id_from
      ,SUM(CONVERT(int,[SLOT0])) AS [Total Orders]
      ,SUM(CONVERT(INT,[SLOT1])) AS [Total Units]
      ,SUM(cast([SLOT4]as int))/60.0/60.0 AS [Hours]

       
FROM 
       [PH_PROD].[dbxx].[if_transaction] AS I
              INNER JOIN
       [PH_PROD].[dbxx].[usrs] AS U
              ON I.[usr_id] = U.[usr_id]
WHERE 
      CAST(SUBSTRING(CAST([activity_date] AS VARCHAR(25)),1,11)+' '+SUBSTRING(CAST([Activity_time] AS VARCHAR(50)),1,12)AS DATETIME)                 
              between @StartDate and @EndDate
              AND 
		[if_tran_code] in ('SHP-CART','SHIP-PACK','SHP-CARTQ', 'SHIP-PACKQ')
GROUP BY 
       U.full_name, i.location_id_from
	   ) as G),

EPT as (SELECT  
		USr_ID,
		[Lane]
		
      ,SUM((DATEDIFF(second, [login_time], logout_time)/60.0/60.0)-3.0)AS [Expected Time]
  FROM [PH_PROD].[dbxx].[hi_usr_login] AS A
				INNER JOIN
		[METRICS_SUMMARIES].[dbo].[PackLanes] AS B
				ON A.[host_name] = B.[host_name]
  WHERE A.[host_name] like 'O2-PACK%'
  AND [logout_time] is not null
  AND [login_time] between @startdate and @enddate and lane is not null
  GROUP BY 
		   [Lane], usr_id)



SELECT
		'Expected Average Packing Hours (Excluding Breaks)',
		AVG([Expected time]) as [Expected Average Packing Hours (Excluding Breaks)]
FROM
(SELECT
	usr_id,
	SUM([expected Time]) as [expected time]
	FROM
	EPT 
	GROUP BY USR_id)as a

UNION ALL
SELECT
	'Total Hours Packed',
	sum([hours]) as [Total Hours Packed]
	FROM ACT
UNION ALL
SELECT
	'#Employees Logged in for packing',
	COUNT (DISTINCT [full_name]) as [#Employees Logged in for packing]
	FROM ACT
	
	UNION ALL

SELECT
	'# Employees logged in for <= 1 hr',
	COUNT(full_name) as [# Employees logged in for <= 1 hr]
	FROM(
SELECT
	Full_name,
	SUM(hours) as hours
	FROM
	ACT
	GROUP BY full_name
HAVING SUM(hours) <= 1) as B
UNION ALL
SELECT
		'Expected Average Packing Hours (Excluding Breaks)',
		AVG([Expected time]) as [Expected Average Packing Hours (Excluding Breaks)]
FROM
(SELECT
	usr_id,
	SUM([expected Time]) as [expected time]
	FROM
	EPT 
	GROUP BY USR_id)as a
	UNION ALL
	SELECT
	'[Total Hours Packed]',
	sum([hours]) as [Total Hours Packed]
	FROM ACT
	UNION ALL
	SELECT
	'#Employees Logged in for packing',
	COUNT(full_name) as [#Employees Logged in for packing]
	FROM(
SELECT
	Full_name,
	SUM(hours) as hours
	FROM
	ACT
	GROUP BY full_name
HAVING SUM(hours) > 1) as B
UNION ALL
SELECT
	'Actual Average Packing Hours',
	AVG(hours) as 'Actual Average Packing Hours'
	FROM
	(SELECT
	Full_name,
	sum(hours) as hours
	FROM
	ACT
	GROUP BY FUll_name) as a
UNION ALL
SELECT
'Total Packers with <= 400 units/hour',
Count(distinct full_name) as 'Total Packers with <= 400 units/hour'
FROM
(SELECT
	FULL_NAME,
	avg(perhour) as perhour
	FROM
	ACT
	GROUP BY Full_name
	having avg(perhour) <= 400 ) as R
UNION ALL
SELECT
'# Assigned Packers with <=400 units/hour',
Count(distinct full_name) as '# Assigned Packers with <=400 units/hour'
FROM
(SELECT
	FULL_NAME,
	avg(perhour) as perhour
	FROM
	ACT
	WHERE full_name in ('Michelle Figura',
'OPEN',
'Michael Burnam',
'Chanelle Tilden',
'Dustin Carter',
'Laurie Wise',
'Audrianna Hammer',
'Anthony Hantzsche',
'Noel Sosa',
'Lois Seckletstewa',
'CLOSED',
'Olivia Santillan',
'Rafael Fuentes',
'Jason Wright',
'Dylan Everlove',
'Maria Cota',
'Susannah Tiah',
'Antoinette Smith',
'Paul Garcia',
'Bobbie Hernandez',
'Theresa Romero',
'Monica Ordonez',
'Nadine Mohamed',
'Rethema Yazzie',
'Janice Sanderson',
'Victoria Fahina',
'Colan Yazzie',
'Ashlee Adams',
'Raymund Aguero',
'David Wells',
'Amy Garcia',
'Karina De La Cruz',
'Benjamin Smith',
'Trish Shobe',
'Lorenzo Rodriquez',
'Isabel Herrera',
'Cristina Santillana',
'Colleen Sibounhom',
'Ernest Thomas',
'Teresa Jaurez',
'Teresa Uriarte',
'Monica Hanson',
'Lizeth Cruz',
'Halina Trzaska',
'Nichole Patricio',
'Loreena Honahnie',
'Britt Rutan',
'Maria Rodriguez',
'Alisa Moore',
'Vanessa Garcia',
'Salvador Vega',
'Zack Braden',
'Rhiana Gonzales',
'Kalandra Begaye',
'Sean Whitney',
'Antonio Orona',
'Buck Odell',
'Valerie Ceal',
'Martha Romo',
'Gayleen Gladden',
'Dennis Pioth',
'Peter Charles',
'Kathy Lane',
'Concepcion Samano',
'Juanita Trujillo')
	GROUP BY Full_name
	having avg(perhour) <= 400 ) as R
UNION ALL


SELECT
'# Assigned Packers who changed locations',
Count(distinct full_name) as '# Assigned Packers who changed locations'
FROM
(SELECT
	FULL_NAME,
	count([pack station]) as stations
	FROM
	ACT
	WHERE full_name in ('Michelle Figura',
'OPEN',
'Michael Burnam',
'Chanelle Tilden',
'Dustin Carter',
'Laurie Wise',
'Audrianna Hammer',
'Anthony Hantzsche',
'Noel Sosa',
'Lois Seckletstewa',
'CLOSED',
'Olivia Santillan',
'Rafael Fuentes',
'Jason Wright',
'Dylan Everlove',
'Maria Cota',
'Susannah Tiah',
'Antoinette Smith',
'Paul Garcia',
'Bobbie Hernandez',
'Theresa Romero',
'Monica Ordonez',
'Nadine Mohamed',
'Rethema Yazzie',
'Janice Sanderson',
'Victoria Fahina',
'Colan Yazzie',
'Ashlee Adams',
'Raymund Aguero',
'David Wells',
'Amy Garcia',
'Karina De La Cruz',
'Benjamin Smith',
'Trish Shobe',
'Lorenzo Rodriquez',
'Isabel Herrera',
'Cristina Santillana',
'Colleen Sibounhom',
'Ernest Thomas',
'Teresa Jaurez',
'Teresa Uriarte',
'Monica Hanson',
'Lizeth Cruz',
'Halina Trzaska',
'Nichole Patricio',
'Loreena Honahnie',
'Britt Rutan',
'Maria Rodriguez',
'Alisa Moore',
'Vanessa Garcia',
'Salvador Vega',
'Zack Braden',
'Rhiana Gonzales',
'Kalandra Begaye',
'Sean Whitney',
'Antonio Orona',
'Buck Odell',
'Valerie Ceal',
'Martha Romo',
'Gayleen Gladden',
'Dennis Pioth',
'Peter Charles',
'Kathy Lane',
'Concepcion Samano',
'Juanita Trujillo') 
group by full_name
having count([pack station])>1 ) as R
