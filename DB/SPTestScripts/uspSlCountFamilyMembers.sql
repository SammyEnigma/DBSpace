USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountFamilyMembers]
		@FamilyID = 2333

SELECT	'Return Value' = @return_value

GO
