USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountNewPeople] 3

SELECT	'Return Value' = @return_value

GO
