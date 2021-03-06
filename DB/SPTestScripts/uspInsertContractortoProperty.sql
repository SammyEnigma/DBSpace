USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertContractortoProperty]
		@ContractorID = 1,
		@PropertyID = 10708,
		@StartDate = '20040912',
		@EndDate = '20131012'

SELECT	'Return Value' = @return_value

GO

Select C.ContractorName
	, 'StreetAddr' = P.StreetNumber + ' ' + P.Street + ' ' + P.StreetSuffix
	, 'AddrLine2' =  P.City + ', ' + P.State + ' ' + P.Zipcode , C2P.StartDate,C2P.EndDate 
from Contractor as C
JOIN ContractortoProperty as C2P on C.ContractorID = C2P.ContractorID
JOIN Property as P on P.PropertyID = C2P.PropertyID