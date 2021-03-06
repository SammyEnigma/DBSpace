USE [LCCHPDev]
GO

DECLARE	@return_value int
		, @PersonID int
		, @LastName varchar(50)
		, @FirstName varchar(50)
		, @MiddleName varchar(50)
		, @BirthDate date
		, @Gender CHAR(1)
		, @StatusID INT
		, @ForeignTravel BIT
		, @OutofSite BIT
		, @EatsForeignFood BIT
		, @PatientID BIT
		, @RetestDate DATE
		, @Moved BIT
		, @MovedDate DATE
		, @isClosed BIT
		, @isResolved BIT
		, @GuardianID INT
		, @PersonCode smallint
		, @isSmoker BIT
		, @isClient bit
		, @isNursing bit
		, @isPregnant bit

SET @PersonID = 4242
SET @LastName = 'Mchenry'
SET @FirstName = 'Jonathan'
SET @MiddleName = 'F.'
SET @BirthDate = '20131201'
SET @Gender = 'M'
SET @StatusID = 6
SET @ForeignTravel = NULL
SET @OutofSite = 0
SET @EatsForeignFood = 1
SET @PatientID = NULL
SET @RetestDate = '20150701'
SET @Moved = 1
SET @MovedDate = '20150105'
SET @isClosed = 0
SET @isResolved = 0
SET @GuardianID = 2785
SET @PersonCode = NULL
SET @isSmoker = 1
SET @isClient = 0
SET @isNursing = 1
SET @isPregnant = 1

select * from Person where PersonID = @PersonID

EXEC	@return_value = [dbo].[usp_upPerson]
		@Person_ID = @PersonID,
		@New_FirstName = @FirstName,
		@New_MiddleName = @MiddleName,
		@New_LastName = @LastName,
		@New_BirthDate = @BirthDate,
		@New_Gender = @Gender,
		@New_StatusID = @StatusID,
		@New_ForeignTravel = @ForeignTravel,
		@New_OutofSite = @OutofSite,
		@New_EatsForeignFood = @EatsForeignFood,
		@New_PatientID = @PatientID,
		@New_RetestDate = @RetestDate,
		@New_Moved = @Moved,
		@New_MovedDate = @MovedDate,
		@New_isClosed = @isClosed,
		@New_isResolved = @isResolved,
		@New_GuardianID = @GuardianID,
		@New_PersonCode = @PersonCode,
		@New_isSmoker = @isSmoker,
		@New_isClient = @isClient,
		@New_isNursing = @isNursing,
		@New_isPregnant = @isPregnant,
		@DEBUG = 1

SELECT	'Return Value' = @return_value
/*

update Person set Lastname = @LastName, FirstName = @Firstname, MiddleName = @MiddleName
		, BirthDate = @BirthDate, Gender = @Gender, OutofSite = @OutofSite, Moved = @Moved
		, isClosed = @isClosed, isResolved = @isResolved, isSmoker = @isSmoker
		where PersonID = @PersonID
		*/
		Select * from Person where PersonID = @PersonID
		-- SELECT * from personNotes order by PersonNotesID desc
		-- select * from ErrorLog order by ErrorID desc
