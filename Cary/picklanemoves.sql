WITH locations AS (SELECT
	item_id
	,location_id
	,pieces_onhand
FROM PH_PROD.dbxx.item_location
WHERE item_id in
('CH1919'
,'CH1920'
,'CR1009'
,'CH1036'
,'CR1040'
,'CN5031'
,'CN5037'
,'CH1916'
,'CH1825'
,'CN5029'
,'BR1009'
,'CR1050'
,'CR1004'
,'CR1046'
,'CR1076'
,'CR1067'
,'CR1075'
,'CR1074'
,'CR1002'
,'CR1036'
,'CR1005'
,'CR1068'
,'CR1071'
,'CR1045'
,'CR2001'
,'CR1049'
,'CR1069'
,'BZ4007'
,'ER1005'
,'CN4007'
,'LK4004'
,'BR4002'
,'ER2020'
,'ER2022'
,'DG4026'
,'CN5006'
,'LK1017'
,'BR2001'
,'CH1801'
,'CH3008'
,'CH3013'
,'CH3023'
,'LK1015'
,'BR1004'
,'CH3006'
,'CH3015'
,'CH3020'
,'CH3051'
,'DG4018'
,'DG4032'
,'CH1018'
,'CH1027'
,'CH1404'
,'CH1601'
,'CH1624'
,'CH1625'
,'CH1630'
,'CH1632'
,'CH1633'
,'CH1650'
,'CH1802'
,'CH1803'
,'CH1808'
,'CH3004'
,'CH3007'
,'CH3014'
,'CH3017'
,'CH3019'
,'CH3024'
,'CH3050'
,'CH3057'
,'CH3061'
,'CH3062'
,'CN7005'
,'DG4022'
,'DG6022'
,'ER3003'
,'PR3018'
,'BR1001'
,'CH1017'
,'CH1028'
,'CH1029'
,'CH1032'
,'CH1316'
,'CH1915'
,'CH3010'
,'CH3016'
,'CH3018'
,'CH3021'
,'CH3049'
,'CH3054'
,'CH3056'
,'CH3069'
,'CH4001'
,'CH6008'
,'CH9005'
,'CH9023'
,'CN5019'
,'DG4015'
,'DG5022'
,'DG5030'
,'DG8006'
,'DG8009'
,'DG9006'
,'EES103'
,'ER2017'
,'LK1002'
,'LK1012'
,'PG3017'
,'PG3018'
,'PG3019'
,'PR3009'
,'PS3019'
,'PS3021'
,'TAG105'
,'TAG108'
,'TAG116'
,'TAG125'
,'TAG137'
,'WN1010'
,'WN3004'))
SELECT 
	A.item_id
	,ISNULL(X.pieces_onhand,0) AS [A]
	,ISNULL(X.location_id,'N/A') AS [A Location FROM]
	,ISNULL(B.pieces_onhand,0) AS [B]
	,ISNULL(B.location_id,'N/A') AS [B Location From]
	,ISNULL(C.pieces_onhand,0) AS [C]
	,ISNULL(C.location_id,'N/A') AS [C Location From]
	,ISNULL(D.pieces_onhand,0) AS [D]
	,ISNULL(D.location_id,'N/A') AS [D Location From]
	,ISNULL(E.pieces_onhand,0) AS [E]
	,ISNULL(E.location_id,'N/A') AS [E Location From]
	,ISNULL(F.pieces_onhand,0) AS [F]
	,ISNULL(F.location_id,'N/A') AS [F Location To]
	,ISNULL(G.pieces_onhand,0) AS [G]
	,ISNULL(G.location_id,'N/A') AS [G Location To]
	,ISNULL(H.pieces_onhand,0) AS [H]
	,ISNULL(H.location_id,'N/A') AS [H Location to]
FROM
(SELECT DISTINCT
	item_id 
FROM locations) AS A
FULL JOIN 
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'A-')AS X
ON A.item_id = X.item_id
FULL JOIN 
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'B-')AS B
	ON A.item_id = B.item_id
FULL JOIN
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'C-')AS C
	ON A.item_id = C.item_id
FULL JOIN
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'D-')AS D
	ON A.item_id = D.item_id
	FULL JOIN 
	(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'E-')AS E
	ON A.item_id = E.item_id
FULL JOIN 
	(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'F-')AS F
	ON A.item_id = F.item_id
FULL JOIN 
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'G-')AS G
On A.item_id = G.item_id
FULL JOIN
(SELECT
	item_id
	,location_id
	,pieces_onhand
FROM locations
WHERE SUBSTRING(location_id,1,2) = 'H-')AS H
On A.item_id =  H.item_id
