USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewRemediationActionPlanID int

EXEC	@return_value = [dbo].[usp_InsertRemediationActionPlan]
		@RemediationActionPlanApprovalDate = '20141001',
		@HomeOwnerConsultationDate = '20141012',
		@ContractorCompletedInvestigationDate = '20140822',
		@EnvironmentalInvestigationID = 1,
		@RemediationActionPlanFinalReportSubmissionDate = '20141101',
		@RemediationActionPlanFile = NULL,
		@PropertyID = 4398,
		@NewRemediationActionPlanID = @NewRemediationActionPlanID OUTPUT

SELECT	@NewRemediationActionPlanID as N'@NewRemediationActionPlanID'

SELECT	'Return Value' = @return_value

GO

Select * from RemediationActionPlan
select * from EnvironmentalInvestigation

