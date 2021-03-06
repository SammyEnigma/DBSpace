USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoStatus]
		@PersonID = 1273,
		@StatusID = 12,
		@StatusDate = '20130501'

SELECT	'Return Value' = @return_value

GO

Select P.Lastname, P.FirstName, S.StatusName, P2S.Statusdate from Person AS P
JOIN PersonToStatus as P2S on P.PersonID = P2S.PersonID
JOIN [Status] as S on P2S.StatusID = S.StatusID