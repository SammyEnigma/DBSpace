USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@NewOccupationID int

EXEC	@return_value = [dbo].[usp_InsertOccupation]
		@OccupationName = N'Lead Mining',
		@OccupationDescription = N'Mining for lead',
		@LeadExposure = 1,
		@NewOccupationID = @NewOccupationID OUTPUT

SELECT	@NewOccupationID as N'@NewOccupationID'

SELECT	'Return Value' = @return_value

GO

select * from occupation