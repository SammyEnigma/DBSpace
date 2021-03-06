USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPropertytoCleanupStatus]
		@PropertyID = 1986,
		@CleanupStatusID = 13,
		@CleanupStatusDate = '20140123',
		@CostofCleanup = 32248.87

SELECT	'Return Value' = @return_value

GO

Select 'StreetAddr' = P.StreetNumber + ' ' + P.Street + ' ' + P.StreetSuffix
	, 'AddrLine2' =  P.City + ', ' + P.State + ' ' + P.Zipcode
	, P2C.CleanupStatusDate,P2C.CostofCleanup
	, C.CleanupStatusName
from Property as P 
LEFT OUTER JOIN PropertytoCleanupStatus as P2C on P.PropertyID = P2C.PropertyID
JOIN CleanupStatus as C on P2C.CleanupStatusID = C.CleanupStatusID
