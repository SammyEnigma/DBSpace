USE [LCCHPDev]
GO

DECLARE	@return_value int, @BeginDate date, @EndDate date

SET @BeginDate = N'1814-12-30 00:00:00.000';
SET @EndDate =  N'2015-01-20 10:23:18.368';



EXEC	@return_value = [dbo].[usp_SlListPeoplebyCreateDateRange]
		@Begin_Date = @BeginDate,
		@End_Date = @EndDate,
		@DEBUG = 1

SELECT	'Return Value' = @return_value

