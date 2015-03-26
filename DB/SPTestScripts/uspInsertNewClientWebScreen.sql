USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@ClientID int

EXEC	@return_value = [dbo].[usp_InsertNewClientWebScreen]
		@Family_ID = 1398,
		@First_Name = N'Jannelle',
		@Middle_Name = N'P.',
		@Last_Name = N'Parkinson',
		@Birth_Date = '19871129',
		@Gender_ = N'F',
		@Language_ID = 1,
		@Ethnicity_ID = 5,
		@Moved_ = NULL,
		@Travel = NULL,
		@Travel_Notes = NULL,
		@Out_of_Site = 0,
		@Hobby_ID = NULL,
		@Hobby_Notes = NULL,
		@Child_Notes = N'nursing mother',
		@Release_Notes = NULL,
		@is_Smoker = 0,
		@Occupation_ID = NULL,
		@Occupation_Start_Date = NULL,
		@is_Client = 1,
		@is_Nursing = 1,
		@is_Pregnant = 0,
		@ClientID = @ClientID OUTPUT

SELECT	@ClientID as N'@ClientID'

SELECT	'Return Value' = @return_value

GO

select * from person order by personID desc