USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoEmployer]
		@PersonID = 1987,
		@EmployerID = 8,
		@StartDate = '20140205',
		@EndDate = NULL

SELECT	'Return Value' = @return_value

GO

select P.LastName,P.FirstName,E.EmployerName,P2E.StartDate,P2E.EndDate from Person as P
JOIN PersontoEmployer as P2E on P.PersonID = P2E.PersonID
JOIN Employer as E on P2E.EmployerID = E.EmployerID
