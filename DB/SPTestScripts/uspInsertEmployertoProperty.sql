USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertEmployertoProperty]
		@EmployerID = 3,
		@PropertyID = 11084,
		@StartDate = '20100403'

SELECT	'Return Value' = @return_value

GO

Select E.EmployerName
	, 'StreetAddr' = P.StreetNumber + ' ' + P.Street + ' ' + P.StreetSuffix
	, 'AddrLine2' =  P.City + ', ' + P.State + ' ' + P.Zipcode , E2P.StartDate,E2P.EndDate from Employer as E
JOIN EmployertoProperty as E2P on E.EmployerID = E2P.EmployerID
JOIN Property as P on P.PropertyID = E2P.PropertyID