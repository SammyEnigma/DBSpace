USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_upOccupation]
		@PersonID = 2874,
		@OccupationID = 4,
		@Occupation_StartDate = '20150325',
		@Occupation_EndDate = '20150328',
		@DEBUG = 1

SELECT	'Return Value' = @return_value

GO


Select [P].[PersonID],[P].[Lastname],[P].[FirstName],[P].[Age],[O].[OccupationName]
     FROM [Person] AS [P]
	 JOIN [PersontoOccupation] AS [PO] ON [P].[PersonID] = [PO].[PersonID]
	 JOIN [Occupation] AS [O] ON [PO].[OccupationID] = [O].[OccupationID]

	 select * from PersontoOccupation where personID = 2874