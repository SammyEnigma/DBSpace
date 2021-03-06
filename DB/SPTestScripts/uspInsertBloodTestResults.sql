USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@BloodTestResultID int

EXEC	@return_value = [dbo].[usp_InsertBloodTestResults]
		@isBaseline = 1,
		@PersonID = 4371,
		@SampleDate = '20150205',
		@LabSubmissionDate = '20150209',
		@LeadValue = 5.1,
		@LeadValueCategoryID = NULL,
		@HemoglobinValue = 14.5,
		@HemoglobinValueCategoryID = NULL,
		@HematocritValueCategoryID = NULL,
		@LabID = NULL,
		@BloodTestCosts = 54.50,
		@sampleTypeID = 8,
		@New_Notes = N'very nervous child',
		@TakenAfterPropertyRemediationCompleted = 0,
		@BloodTestResultID = @BloodTestResultID OUTPUT

SELECT	@BloodTestResultID as N'@BloodTestResultID'

SELECT	'Return Value' = @return_value

GO
