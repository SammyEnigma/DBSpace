USE [LeadTrackingTesting-Liam]
GO

set statistics io on
set statistics time on
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountParticipants]
		@Last_Name = N'Adams'

SELECT	'Return Value' = @return_value

GO


DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountParticipants]
		@Last_Name = N'Bush'

SELECT	'Return Value' = @return_value

GO


DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SlCountParticipants]
--		@Last_Name = N'Adams'

SELECT	'Return Value' = @return_value

GO
