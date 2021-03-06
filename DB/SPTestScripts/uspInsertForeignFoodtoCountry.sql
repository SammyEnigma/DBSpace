USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertForeignFoodtoCountry]
		@ForeignFoodID = 2,
		@CountryID = 3

SELECT	'Return Value' = @return_value

GO

Select * from ForeignFood as FF
JOIN ForeignFoodtoCountry as F2C on FF.ForeignFoodID = F2C.ForeignFoodID
JOIN Country as C on F2C.CountryID = C.CountryID
