USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlListFamilyMembers]
		@FamilyID = 2667

SELECT	'Return Value' = @return_value

GO
