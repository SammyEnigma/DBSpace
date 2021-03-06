USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoInsurance]
		@PersonID = 2317,
		@InsuranceID = 12,
		@StartDate = '20141211',
		@GroupID = N'Medicaid'

SELECT	'Return Value' = @return_value

GO

-- select * from InsuranceProvider

select P.LastName,P.FirstName,I.InsuranceProviderName, P2I.GroupID,P2I.StartDate,P2I.EndDate from Person as P
join PersontoInsurance as P2I on P.personID = P2I.PersonID
join InsuranceProvider as I on I.InsuranceProviderID = P2I.InsuranceID

