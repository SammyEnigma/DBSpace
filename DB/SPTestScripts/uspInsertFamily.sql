USE [LCCHPDev]
GO

DECLARE	@Family_ID int

EXEC	[dbo].[usp_InsertFamily]
		@LastName = N'Dostoevsky',
		@NumberofSmokers = NULL,
		@PrimaryLanguageID = 2,
		@Notes = 'Make lead flies',
		@ForeignTravel = 1,
		@New_Travel_Notes = 'Went to Bermuda',
		@Travel_Start_Date = '20120503',
		@Travel_End_Date = '20120603',
		@Pets = 5,
		@Petsinandout = 1,
		@PrimaryPropertyID = 5697,
		@FrequentlyWashPets = 1,
		@FID = @Family_ID OUTPUT

SELECT	@Family_ID as N'@FID'
select * from Family order by FamilyID desc
GO

select * from FamilyNOTES 
LEFT OUTER JOIN Family on FamilyNOtes.FamilyID = Family.FamilyID
order by Family.familyID desc

Select * FROM TravelNotes order by CreatedDate desc

-- select * from ErrorLog order by errorid desc