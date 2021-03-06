USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@New_PersontoEthnicityID int

EXEC	@return_value = [dbo].[usp_upEthnicity]
		@PersonID = 1845,
		@New_EthnicityID = 1,
		@Current_EthnicityID = NULL,
		@DEBUG = 1,
		@PersontoEthnicityID = @New_PersontoEthnicityID OUTPUT

SELECT	@New_PersontoEthnicityID as N'@PersontoEthnicityID'

SELECT	'Return Value' = @return_value

GO

-- update PersontoEthnicity set EthnicityID = 6 					where PersonID = 1845 AND PersontoEthnicityID = 6

Select [P].[PersonID],[P].[Lastname],[P].[FirstName],[P].[Age],[E].[Ethnicity]
     FROM [Person] AS [P]
	 JOIN [PersontoEthnicity] AS [PE] ON [P].[PersonID] = [PE].[PersonID]
	 JOIN [Ethnicity] AS [E] ON [PE].[EthnicityID] = [E].[EthnicityID]