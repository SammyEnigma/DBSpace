USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewCountryID int

EXEC	@return_value = [dbo].[usp_InsertCountry]
		@CountryName = N'Mexico',
		@NewCountryID = @NewCountryID OUTPUT

SELECT	@NewCountryID as N'@NewCountryID'

SELECT	'Return Value' = @return_value

GO

Select * from Country