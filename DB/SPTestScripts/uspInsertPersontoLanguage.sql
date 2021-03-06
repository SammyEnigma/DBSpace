USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int, @PID int, @LID int;

SET @PID = 2987;
SET @LID = 25;

EXEC	@return_value = [dbo].[usp_InsertPersontoLanguage]
		@PersonID = @PID,
		@LanguageID = @LID,
		@isPrimaryLanguage = 1

SELECT	'Return Value' = @return_value


Select * from Person as P
JOIN PersontoLanguage as P2L on P.PersonID = P2L.PersonID
JOIN Language as L on P2L.LanguageID = L.LanguageID
where P.PersonID = @PID or L.LanguageID = @LID