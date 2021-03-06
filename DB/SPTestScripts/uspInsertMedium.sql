USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewMediumID int

EXEC	@return_value = [dbo].[usp_InsertMedium]
		@MediumName = N'Commercial Soil',
		@MediumDescription = N'soil on commercial property',
		@TriggerLevel = 3500,
		@TriggerLevelUnitsID = N'6',
		@NewMediumID = @NewMediumID OUTPUT

SELECT	@NewMediumID as N'@NewMediumID'

SELECT	'Return Value' = @return_value

GO

select * from units

select M.MediumName,M.MediumDescription, TriggerLevel = cast(M.TriggerLevel as Varchar) + ' ' + U.Units from Medium as M
LEFT OUTER JOIN Units as U on M.TriggerLevelUnitsID = U.UnitsID
