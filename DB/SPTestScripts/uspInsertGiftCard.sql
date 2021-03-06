USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewGiftCardID int

EXEC	@return_value = [dbo].[usp_InsertGiftCard]
		@GiftCardValue = 50,
		@IssueDate = '20131001',
		@PersonID = 1198,
		@NewGiftCardID = @NewGiftCardID OUTPUT

SELECT	@NewGiftCardID as N'@NewGiftCardID'

SELECT	'Return Value' = @return_value

GO

Select P.Lastname,P.Firstname,G.GiftCardValue,G.IssueDate from GiftCard AS G
JOIN Person AS P ON G.PersonID = P.PersonID
