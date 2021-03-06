USE [LCCHPDev]
GO


select * from family order by createdDate desc
DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_upFamily]
		@Family_ID = 2824,
		@New_Last_Name = N'Galinda',
		@New_Number_of_Smokers = 2,
		@New_Primary_Language_ID = 1,
		@New_Notes = N'updating to make corrections',
		@New_Pets = 1,
		@New_Frequently_Wash_Pets = 1,
		@New_Pets_in_and_out = 1,
		@New_Primary_Property_ID = 11366,
		@New_ForeignTravel = 0,
		@DEBUG = 1

SELECT	'Return Value' = @return_value
select * from family order by createdDate desc
GO
/*
DECLARE @LastName varchar(50), @NumberofSMokers tinyint, @PrimaryLanguageID tinyint, @Pets tinyint
		, @New_Frequently_Wash_Pets bit, @Petsinandout bit, @PrimaryPropertyID int, @ForeignTravel int, @FamilyID int
		SET @FamilyID = 2824;
		SET @LastName = 'Galinda';
		SET @NumberofSMokers = 2;
		SET @PrimaryLanguageID = 2;
		SET @Pets = 1;
		SET @New_Frequently_Wash_Pets = 1;
		SET @Petsinandout = 0;
		SET @PrimaryPropertyID = 11366;
		SET @ForeignTravel  = 1;
		
select * from family order by createdDate desc

update Family set Lastname = @LastName, NumberofSmokers = @NumberofSmokers, PrimaryLanguageID = @PrimaryLanguageID
, Pets = @Pets, FrequentlyWashPets = @New_Frequently_Wash_Pets, Petsinandout = @Petsinandout, ForeignTravel = @ForeignTravel
, PrimaryPropertyID = @PrimaryPropertyID WHERE FamilyID = @FamilyID


select * from family order by createdDate desc
*/

SELECT * From FamilyNotes order by CreatedDate desc