USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoTravelCountry]
		@PersonID = 3089,
		@TravelCountryID = 12,
		@StartDate = '20130319',
		@EndDate = '20130326'

SELECT	'Return Value' = @return_value

GO


Select P.lastName,P.Firstname,C.CountryName from Person AS P
JOIN PersonToTravelCountry AS P2T on P.PersonID = P2T.PersonID
JOIN Country AS C on P2T.CountryID = C.CountryID