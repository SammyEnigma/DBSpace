USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoEthnicity]
		@PersonID = 1899,
		@EthnicityID = 6

SELECT	'Return Value' = @return_value

GO

Select P.LastName,P.FirstName,E.Ethnicity from Person AS P
JOIN PersontoEthnicity AS P2E on P.PersonID = P2E.PersonID
JOIN Ethnicity AS E on P2E.EthnicityID = E.EthnicityID

