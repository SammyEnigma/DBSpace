USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@AccessPurposeID int

EXEC	@return_value = [dbo].[usp_InsertAccessPurpose]
		@AccessPurposeName = N'Annual Inspection',
		@AccessPurposeDescription = N'inspect property for miscellaneous assundries',
		@AccessPurposeID = @AccessPurposeID OUTPUT

SELECT	@AccessPurposeID as N'@AccessPurposeID'

SELECT	'Return Value' = @return_value

GO
