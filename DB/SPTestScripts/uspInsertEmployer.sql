USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewEmployerID int

EXEC	@return_value = [dbo].[usp_InsertEmployer]
		@EmployerName = 'Leadville Outdoors',
		@NewEmployerID = @NewEmployerID OUTPUT

SELECT	@NewEmployerID as N'@NewEmployerID'

SELECT	'Return Value' = @return_value

GO

select * from Employer