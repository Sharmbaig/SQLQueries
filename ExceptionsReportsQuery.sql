DECLARE @StartDate DATETIME, @EndDate DATETIME;
SET @StartDate = CAST('1/15/2014 07:30:00.000' AS DATETIME);
SET @EndDate = CAST('1/15/2014 09:30:00.000' AS DATETIME);
EXECUTE [DataWarehouseSupport].[dbo].[sp_RawExceptionsReport] @StartDate, @EndDate
EXECUTE [DataWarehouseSupport].[dbo].[sp_PickerExceptionReport] @StartDate, @EndDate
EXECUTE [DataWarehouseSupport].[dbo].[sp_PackerExceptionReport] @StartDate, @EndDate