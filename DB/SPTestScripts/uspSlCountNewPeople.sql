USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountNewPeople]
		@Created_Days_Ago = 90000

SELECT	'Return Value' = @return_value

GO
