USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewRemediationID int

EXEC	@return_value = [dbo].[usp_InsertRemediation]
		@RemediationApprovalDate = '20141115',
		@RemediationStartDate = '20141201',
		@RemediationEndDate = NULL,
		@PropertyID = 4875,
		@AccessAgreementID = 1,
		@FinalRemediationReportFile = NULL,
		@FinalRemediationReportDate = NULL,
		@RemediationCost = NULL,
		@RemediationActionPlanID = 8,
		@OneYearRemediationCompleteDate = NULL,
		@Notes = NULL,
		@OneYearRemediatioNComplete = NULL,
		@NewRemediationID = @NewRemediationID OUTPUT

SELECT	@NewRemediationID as N'@NewRemediationID'

SELECT	'Return Value' = @return_value

GO


Select * from Remediation AS R
JOIN RemediationActionPlan as RAP on R.RemediationActionPlanID = RAP.RemediationActionPlanID
JOIN EnvironmentalInvestigation as EI on RAP.EnvironmentalInvestigationID = EI.EnvironmentalInvestigationID
