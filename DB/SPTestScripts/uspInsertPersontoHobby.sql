USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoHobby]
		@PersonID = 2106,
		@HobbyID = 16

SELECT	'Return Value' = @return_value

GO

select * from persontoHobby order by PersonID,HobbyID desc