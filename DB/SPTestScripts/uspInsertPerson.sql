USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@PID int

EXEC	@return_value = [dbo].[usp_InsertPerson]
		@FirstName = N'Jack',
		@MiddleName = N'La',
		@LastName = N'Lane',
		@BirthDate = '19320528',
		@Gender = N'M',
		@StatusID = NULL,
		@ForeignTravel = 1,
		@OutofSite = 1,
		@EatsForeignFood = 1,
		@EmailAddress = N'jacklalane@msn.com',
		@RetestDate = NULL,
		@Moved = 1,
		@MovedDate = '20110205',
		@isClosed = 1,
		@isResolved = 1,
		@New_Notes = N'definitely out of site',
		@Release_Notes = N'he is the picture of health',
		@Hobby_Notes = N'loves to work out',
		@Travel_Notes = N'he has a travel bag of goodies to snack on to avoid toxins.',
		@GuardianID = NULL,
		@isSmoker = 0,
		@isClient = 1,
		@NursingMother = 0,
		@NursingInfant = 0,
		@Pregnant = 0,
		@OverrideDuplicate = 0,
		@PID = @PID OUTPUT

SELECT	@PID as N'@PID'

SELECT	'Return Value' = @return_value

GO


select * from person where personID = 4442