WITH RankedReports
AS
(
    SELECT
        ReportID,
        TimeStart,
        UserName, 
        RANK() OVER(PARTITION BY ReportID ORDER BY TimeStart DESC) AS iRank
FROM dbo.ExecutionLog t1
    JOIN dbo.Catalog t2
        ON t1.ReportID = t2.ItemID
)

SELECT 
t2.Name AS ReportName,
t1.TimeStart,
t1.UserName,
t2.Path,
t1.ReportID
FROM RankedReports t1
JOIN dbo.Catalog t2
    ON t1.ReportID = t2.ItemID
WHERE t1.iRank = 1
ORDER BY t1.TimeStart