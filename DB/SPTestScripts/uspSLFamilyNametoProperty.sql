USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlFamilyNametoProperty] @IncludeIDS = 1

SELECT	'Return Value' = @return_value

GO
