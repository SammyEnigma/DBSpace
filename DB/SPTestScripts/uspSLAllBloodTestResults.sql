USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SLAllBloodTestResults]
		@Person_ID = 1556
		, @Min_Lead_Value = 35.0
		--@DEBUG = NULL

SELECT	'Return Value' = @return_value

GO
