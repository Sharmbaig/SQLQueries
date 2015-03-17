SELECT
    COUNT(Name) AS ExecutionCount,
    Name,
    MAX(TimeDataRetrieval) AS TimeDataRetrievalMAX,
    MAX(TimeProcessing) AS TimeProcessingMAX,
    MAX(TimeRendering) AS TimeRenderingMAX,
    MAX(ByteCount) AS ByteCountMAX,
    MAX([RowCount]) AS RowCountMAX
FROM
    (
     SELECT
        TimeStart,
        Catalog.Type,
        Catalog.Name,
        TimeDataRetrieval,
        TimeProcessing,
        TimeRendering,
        ByteCount,
        [RowCount]
     FROM
        Catalog
     INNER JOIN ExecutionLog
        ON Catalog.ItemID = ExecutionLog.ReportID
     WHERE
        Type = 2
    ) AS RE
GROUP BY
    Name
ORDER BY
    COUNT(Name) DESC,
    Name