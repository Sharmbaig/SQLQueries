
DECLARE @date as date
SET @date = '12/12/2014'

SELECT
	a.shipsys_tran_id as 'Date',
	a.UPSMI,
	b.USPS,
	c.Ground as 'FedEx Ground',
	d.Express as 'FedEx Express'
FROM(

SELECT  shipsys_tran_id,
	COUNT( distinct package_trace_id) AS UPSMI
FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE carrier_id = 'UPSMI' and cast(shipsys_tran_id as date) = @date
GROUP BY shipsys_tran_id) as a
	
	INNER JOIN

(SELECT  shipsys_tran_id,
	COUNT( distinct package_trace_id) AS USPS
FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE carrier_id = 'USPS' and cast(shipsys_tran_id as date) = @date
GROUP BY shipsys_tran_id) as b

on a.shipsys_tran_id = b.shipsys_tran_id

INNER JOIN

(SELECT Distinct
		shipsys_tran_id,
		count(type) as 'GROUND'
		FROM(

SELECT  shipsys_tran_id,
		[package_trace_id],
	case WHEN len([package_trace_id]) = 12 then 'EXPRESS' else 'GROUND' END as TYPE
FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE carrier_id = 'FDX' and cast(shipsys_tran_id as date) = @date
GROUP BY shipsys_tran_id, package_trace_id) as a
WHERE type = 'GROUND'
GROUP BY shipsys_tran_id) as c

on a.shipsys_tran_id = c.shipsys_tran_id

INNER JOIN

(SELECT Distinct
		shipsys_tran_id,
		count(type) as 'EXPRESS'
		FROM(

SELECT  shipsys_tran_id,
		[package_trace_id],
	case WHEN len([package_trace_id]) = 12 then 'EXPRESS' else 'GROUND' END as TYPE
FROM [PH_PROD].[dbxx].[hi_work_cartons]
WHERE carrier_id = 'FDX' and cast(shipsys_tran_id as date) = @date
GROUP BY shipsys_tran_id, package_trace_id) as a
WHERE type = 'EXPRESS'
GROUP BY shipsys_tran_id) as d

on a.shipsys_tran_id = d.shipsys_tran_id
	
