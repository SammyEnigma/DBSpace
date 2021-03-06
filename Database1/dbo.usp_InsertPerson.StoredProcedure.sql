USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPerson]    Script Date: 5/19/2015 6:54:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new people records
-- =============================================
-- DROP PROCEDURE usp_InsertPerson
CREATE PROCEDURE [dbo].[usp_InsertPerson]   -- usp_InsertPerson "Bonifacic",'James','Marco','19750205','M'
	-- Add the parameters for the stored procedure here
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(50) = NULL,
	@LastName varchar(50) = NULL, 
	@BirthDate date = NULL,
	@Gender char(1) = NULL,
	@StatusID smallint = NULL,
	@ForeignTravel bit = NULL,
	@OutofSite bit = NULL,
	@EatsForeignFood bit = NULL,
	@EmailAddress VARCHAR(320) = NULL,
	@RetestDate datetime = NULL,
	@Moved bit = NULL,
	@MovedDate date = NULL,
	@isClosed bit = 0,
	@isResolved bit = 0,
	@New_Notes varchar(3000) = NULL,
	@Release_Notes varchar(3000) = NULL,
	@Hobby_Notes varchar(3000) = NULL,
	@Travel_Notes varchar(3000) = NULL,
	@GuardianID int = NULL,
	@isSmoker bit = NULL,
	@isClient bit = 1,
	@NursingMother bit = 0,
	@NursingInfant bit = 0,
	@Pregnant bit = 0,
	@OverrideDuplicate bit = 0,
	@PID int OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;

	-- set default retest date if none specified
	IF @RetestDate is null
		SET @RetestDate = DATEADD(yy,1,GetDate());
	
	Select @PID = PersonID from Person where Lastname = @LastName and FirstName = @FirstName AND BirthDate = @BirthDate;
	IF (@PID IS NOT NULL AND @OverrideDuplicate = 0)
	BEGIN
		DECLARE @ErrorString VARCHAR(3000);
		SET @ErrorString ='Person appears to be a duplicate of personID: ' + cast(@PID as varchar(256))
		RAISERROR (@ErrorString, 11, -1);
		RETURN;
	END	

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into person ( LastName,  FirstName,  MiddleName,  BirthDate,  Gender,  StatusID, 
							  ForeignTravel,  OutofSite,  EatsForeignFood,  EmailAddress,  RetestDate, 
							  Moved,  MovedDate,  isClosed,  isResolved,  GuardianID,  isSmoker, 
							  isClient, NursingMother, NursingInfant, Pregnant) 
					 Values (@LastName, @FirstName, @MiddleName, @BirthDate, @Gender, @StatusID,
							 @ForeignTravel, @OutofSite, @EatsForeignFood, @EmailAddress, @RetestDate,
							 @Moved, @MovedDate, @isClosed, @isResolved,  @GuardianID, @isSmoker, 
							 @isClient, @NursingMother, @NursingInfant, @Pregnant);
		SET @PID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
							@Person_ID = @PID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Release_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonReleaseNotes]
							@Person_ID = @PID,
							@Notes = @Release_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Travel_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonTravelNotes]
							@Person_ID = @PID,
							@Notes = @Travel_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Hobby_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonHobbyNotes]
							@Person_ID = @PID,
							@Notes = @Hobby_Notes,
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
