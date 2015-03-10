USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewContractorID int

EXEC	@return_value = [dbo].[usp_InsertContractor]
		@ContractorDescription = N'General Contractors',
		@ContractorName = N'Mountain Mechanical',
		@NewContractorID = @NewContractorID OUTPUT

SELECT	@NewContractorID as N'@NewContractorID'

SELECT	'Return Value' = @return_value

GO

Select * from Contractor