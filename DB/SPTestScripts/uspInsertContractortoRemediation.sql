USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertContractortoRemediation]
		@ContractorID = ,
		@RemediationID = 4,
		@StartDate = '20141112',
		@EndDate = '20141224',
		@isSubContractor = 0

SELECT	'Return Value' = @return_value

GO


Select 'StreetAddr' = P.StreetNumber + ' ' + P.Street + ' ' + coalesce(P.StreetSuffix,'')
	, 'AddrLine2' =  P.City + ', ' + P.State + ' ' + P.Zipcode 
	, C.ContractorName, R.RemediationApprovalDate, R.RemediationStartDate, R.RemediationEndDate
	, R.FinalRemediationReportDate, R.RemediationCost
	, R.OneYearRemediationCompleteDate, R.OneYearRemediationComplete
	, AP.AccessPurposeName
from ContractortoRemediation AS C2R
JOIN Contractor as C on C2R.ContractorID = C.ContractorID
JOIN Remediation as R on C2R.RemediationID = R.RemediationID
JOIN Property AS P on R.PropertyID = P.PropertyID
JOIN AccessAgreement AS A on R.AccessAgreementID = A.AccessAgreementID
JOIN AccessPurpose AS AP on A.AccessPurposeID = AP.AccessPurposeID