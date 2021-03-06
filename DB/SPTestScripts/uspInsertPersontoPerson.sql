USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoPerson]
		@Person1ID = 4282,
		@Person2ID = 4346,
		@RelationshipType = 6,
		@isGuardian = 1,
		@isPrimaryContact = 1

SELECT	'Return Value' = @return_value

GO

select * from PersontoPerson

Select [P1].[LastName],[P1].[FirstName],[P1].[Age],[P1].[Gender]
		, [P2].[LastName],[P2].[FirstName],[P2].[Age],[P2].[Gender]
		, [RT].[RelationshipTypeName]
		from [RelationshipType] as [RT]
		JOIN [PersontoPerson] AS [P2P] on [RT].[RelationshipTypeID] = [P2P].[RelationshipTypeID]
		JOIN [Person] AS [P1] on [P1].[PersonID] = [P2P].[Person1ID]
		JOIN [Person] AS [P2] on [P2].[PersonID] = [P2P].[Person2ID]