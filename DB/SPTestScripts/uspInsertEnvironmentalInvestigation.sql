USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewEnvironmentalInvestigation int

EXEC	@return_value = [dbo].[usp_InsertEnvironmentalInvestigation]
		@ConductEnvironmentalInvestigation = 1,
		@ConductEnvironmentalInvestigationDecisionDate = '20140901',
		@Cost = 22569,
		@EnvironmentalInvestigationDate = '20140905',
		@PropertyID = 4587,
		@StartDate = '20140813',
		@EndDate = '20140819',
		@NewEnvironmentalInvestigation = @NewEnvironmentalInvestigation OUTPUT

SELECT	@NewEnvironmentalInvestigation as N'@NewEnvironmentalInvestigation'

SELECT	'Return Value' = @return_value

GO


Select * from EnvironmentalInvestigation
