USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewHomeRemedyID int

EXEC	@return_value = [dbo].[usp_InsertHomeRemedies]
		@HomeRemedyName = N'Centrifuge',
		@HomeRemedyDescription = N'spin very fast on a merry go round',
		@NewHomeRemedyID = @NewHomeRemedyID OUTPUT

SELECT	@NewHomeRemedyID as N'@NewHomeRemedyID'

SELECT	'Return Value' = @return_value

GO

Select * from HomeRemedy