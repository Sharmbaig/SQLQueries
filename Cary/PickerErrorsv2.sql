WITH Errors AS(SELECT
    activity_date,
    CASE WHEN exception_type in ('MISPICK','MISSING')
	   THEN 'Y'
	   ELSE 'N'
	   END AS hasMisput,
    CASE WHEN exception_type in ('EXTRA ITEM','SHORT','OVER')
	   THEN 'Y'
	   ELSE 'N'
	   END AS hasMispick,
    order_id,
    item_id
FROM PH_PROD.dbxx.exceptions2
WHERE exception_type in ('MISPICK','MISSING','EXTRA ITEM','SHORT','OVER')
AND CAST(activity_date AS DATE) >= '12/01/14')

SELECT DISTINCT
    A.*
    ,B.PickerName
FROM
(SELECT
    CAST(A.activity_date AS DATE) AS [Date]
    ,hasMisput
    ,hasMispick
    ,A.order_id
    ,b.usr_id
FROM Errors AS A
	   LEFT JOIN
    PH_PROD.dbxx.if_transaction AS B
	   ON A.order_id = B.order_id and A.item_id = B.item_id
WHERE if_tran_Code = 'POP-PICK') AS A
LEFT JOIN
(SELECT
    PickerBarCode,
    PickerName
FROM LPPick.dbo.Pickers)AS B
ON A.usr_id = B.PickerBarCode

SELECT
    CAST(activity_date AS DATE) AS [Date],
    PickerName,
    COUNT(DISTINCT order_id)
FROM PH_PROD.dbxx.if_transaction AS A
	   INNER JOIN
     LPPick.dbo.Pickers AS B
	   On A.usr_id = B.PickerBarCode
WHERE CAST(activity_date AS DATE) >= '12/01/14'
GROUP BY CAST(activity_date AS DATE),PickerName


SELECT
    CAST(activity_date AS DATE) AS [Date],
    PickerName,
    COUNT(DISTINCT order_id)
FROM PH_PROD.dbxx.if_transaction AS A
	   INNER JOIN
     LPPick.dbo.Pickers AS B
	   On A.usr_id = B.PickerBarCode
WHERE CAST(activity_date AS DATE) = '12/03/14'
AND order_id in (
SELECT
    order_id
FROM PH_PROD.dbxx.if_transaction
WHERE if_tran_code = 'VERIFY')
GROUP BY CAST(activity_date AS DATE),PickerName
