USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoForeignFood]
		@PersonID = 1891,
		@ForeignFoodID = 1

SELECT	'Return Value' = @return_value

GO

Select P.LastName, P.FirstName, F.ForeignFoodName, F.ForeignFoodDescription from Person AS P
JOIN PersontoForeignFood as P2F on P.PersonID = P2F.PersonID
JOIN ForeignFood AS F on P2F.ForeignFoodID = F.ForeignFoodID
