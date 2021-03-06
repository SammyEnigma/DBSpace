USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upPerson]    Script Date: 6/21/2015 12:54:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to update new people records
-- =============================================
-- DROP PROCEDURE usp_upPerson
CREATE PROCEDURE [dbo].[usp_upPerson]  
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@New_FirstName varchar(50) = NULL,
	@New_MiddleName varchar(50) = NULL,
	@New_LastName varchar(50) = NULL, 
	@New_BirthDate date = NULL,
	@New_Gender char(1) = NULL,
	@New_StatusID smallint = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OutofSite bit = NULL,
	@New_EatsForeignFood bit = NULL,
	@New_EmailAddress varchar(320) = NULL,
	@New_RetestDate date = NULL,
	@New_Moved bit = NULL,
	@New_MovedDate date = NULL,
	@New_isClosed bit = 0,
	@New_isResolved bit = 0,
	@New_PersonNotes varchar(3000) = NULL,
	@New_TravelNotes varchar(3000) = NULL,
	@New_HobbyNotes varchar(3000) = NULL,
	@New_ReleaseNotes varchar(3000) = NULL,
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	@New_ClientStatusID smallint = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePersonsqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if PersonID is valid, if not return
		IF NOT EXISTS (SELECT PersonID from Person where PersonID = @Person_ID)
		BEGIN
			RAISERROR(15000, -1,-1,'usp_upPerson');
		END
		
		-- BUILD update statement
		IF (@New_LastName IS NULL)
			SELECT @New_LastName = LastName from Person where PersonID = @Person_ID;
	
		SELECT @spupdatePersonsqlStr = N'update Person set Lastname = @LastName'

		IF (@New_FirstName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', FirstName = @Firstname'

		IF (@New_MiddleName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MiddleName = @MiddleName'

		IF (@New_BirthDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', BirthDate = @BirthDate'

		IF (@New_Gender IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Gender = @Gender'

		IF (@New_StatusID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', StatusID = @StatusID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', ForeignTravel = @ForeignTravel'

		IF (@New_OutofSite IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', OutofSite = @OutofSite'

		IF (@New_EatsForeignFood IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', EatsForeignFood = @EatsForeignFood'

		IF (@New_EmailAddress IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', EmailAddress = @EmailAddress'

		IF (@New_RetestDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', RetestDate = @RetestDate'

		IF (@New_Moved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Moved = @Moved'

		IF (@New_MovedDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MovedDate = @MovedDate'

		IF (@New_isClosed IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClosed = @isClosed'

		IF (@New_isResolved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isResolved = @isResolved'
			
		IF (@New_GuardianID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', GuardianID = @GuardianID'
			
		IF (@New_PersonCode IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', PersonCode = @PersonCode'

		IF (@New_isSmoker IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isSmoker = @isSmoker'

		IF (@New_isClient IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClient = @isClient'

		IF (@New_NursingMother IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', NursingMother = @NursingMother'

		IF (@New_NursingInfant IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', NursingInfant = @NursingInfant'

		IF (@New_Pregnant IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Pregnant = @Pregnant'

		IF (@New_ClientStatusID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', ClientStatusID = @ClientStatusID'

		-- make sure to only update record for specified person
		SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N' WHERE PersonID = @PersonID'

		IF (@DEBUG = 1)
			SELECT @spupdatePersonsqlStr, LastName = @New_LastName, FirstName = @New_FirstName, MiddleName = @New_MiddleName
					, BirthDate = @New_BirthDate, Gender = @New_Gender, StatusID = @New_StatusID, ForeignTravel = @New_ForeignTravel
					, OutofSite = @New_OutofSite, EatsForeignFood = @New_EatsForeignFood, EmailAddress = @New_EmailAddress, RetestDate = @New_RetestDate
					, Moved = @New_Moved, MovedDate = @New_MovedDate, isClosed = @New_isClosed, isResolved = @New_isResolved
					, GuardianID = @New_GuardianID, PersonCode = @New_PersonCode, isSmoker = @New_isSmoker, isClient = @New_isClient
					, NursingMother = @New_NursingMother, NursingInfant = @New_NursingInfant, Pregnant = @New_Pregnant
					, ClientStatusID = @New_ClientStatusID, PersonID = @Person_ID

		EXEC [sp_executesql] @spupdatePersonsqlStr
				, N'@LastName VARCHAR(50), @FirstName VARCHAR(50), @MiddleName VARCHAR(50), @BirthDate date, @Gender char(1)
				, @StatusID smallint, @ForeignTravel BIT, @OutofSite bit, @EatsForeignFood bit, @EmailAddress varchar(320), @RetestDate date
				, @Moved bit, @MovedDate date, @isClosed bit, @isResolved bit, @GuardianID int, @PersonCode smallint, @isSmoker bit
				, @isClient bit, @NursingMother bit, @NursingInfant bit, @Pregnant bit, @ClientStatusID smallint, @PersonID int'
				, @LastName = @New_LastName
				, @FirstName = @New_FirstName
				, @MiddleName = @New_MiddleName
				, @BirthDate = @New_BirthDate
				, @Gender = @New_Gender
				, @StatusID = @New_StatusID
				, @ForeignTravel = @New_ForeignTravel
				, @OutofSite = @New_OutofSite
				, @EatsForeignFood = @New_EatsForeignFood
				, @EMailAddress = @New_EmailAddress
				, @RetestDate = @New_RetestDate
				, @Moved = @New_Moved
				, @MovedDate = @New_MovedDate
				, @isClosed = @New_isClosed
				, @isResolved = @New_isResolved
				, @GuardianID = @New_GuardianID
				, @PersonCode = @New_PersonCode
				, @isSmoker = @New_isSmoker
				, @isClient = @New_isClient
				, @NursingMother = @New_NursingMother
				, @NursingInfant = @New_NursingInfant
				, @Pregnant = @New_Pregnant
				, @ClientStatusID = @New_ClientStatusID
				, @PersonID = @Person_ID

			IF (@New_PersonNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
								@Person_ID = @Person_ID,
								@Notes = @New_PersonNotes,
								@InsertedNotesID = @NotesID OUTPUT

			IF (@New_ReleaseNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonReleaseNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_TravelNotes,
							@InsertedNotesID = @NotesID OUTPUT

			IF (@New_TravelNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonTravelNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_TravelNotes,
							@InsertedNotesID = @NotesID OUTPUT

			IF (@New_HobbyNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonHobbyNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_HobbyNotes,
							@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END


GO
