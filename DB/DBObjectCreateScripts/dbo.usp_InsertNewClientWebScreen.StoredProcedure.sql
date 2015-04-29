USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertNewClientWebScreen]    Script Date: 4/28/2015 11:36:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@First_Name varchar(50) = NULL,
	@Middle_Name varchar(50) = NULL,
	@Last_Name varchar(50) = NULL,
	@Birth_Date date = NULL,
	@Gender_ char(1) = NULL,
	@Language_ID tinyint = NULL,
	@Ethnicity_ID int = NULL,
	@Moved_ bit = NULL,
	@Travel bit = NULL, --ForeignTravel  REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Travel_Notes varchar(3000) = NULL,  -- REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Out_of_Site bit = NULL, 
	@Hobby_ID smallint = NULL,
	@Hobby_Notes varchar(3000) = NULL,
	@Child_Notes varchar(3000) = NULL,
	@Release_Notes varchar(3000) = NULL,
	@is_Smoker bit = NULL,
	@Occupation_ID smallint = NULL,
	@Occupation_Start_Date date = NULL,
	@OverrideDuplicatePerson bit = 0,
	@EmailAddress VARCHAR(320) = NULL,
	@is_Client bit = 1,
	@is_Nursing bit = NULL,
	@is_Pregnant bit = NULL,
	@ClientID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL)
		BEGIN
			RAISERROR ('Family name must be supplied', 11, -1);
			RETURN;
		END;

		-- If the family doesn't exist, return an error
		IF ((select FamilyID from family where FamilyID = @Family_ID) is NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Unable to associate non-existent family. Family does not exist.'
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END
	
		if (@Last_Name is null)
		BEGIN
			select @Last_Name = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- insert new person
			EXEC	[dbo].[usp_InsertPerson]
					@FirstName = @First_Name,
					@MiddleName = @Middle_Name,
					@LastName = @Last_Name,
					@BirthDate = @Birth_Date,
					@Gender = @Gender_,
					@Moved = @Moved_,
					@ForeignTravel = @Travel,
					@EmailAddress = @EmailAddress,
					@OutofSite = @Out_of_Site,
					@New_Notes = @Child_Notes,
					@Hobby_Notes = @Hobby_Notes, 
					@Release_Notes = @Release_Notes,
					@Travel_Notes = @Travel_Notes,
					@isSmoker = @is_Smoker,
					@isClient = @is_Client,
					@isNursing = @is_Nursing,
					@isPregnant = @is_Pregnant,
					@OverrideDuplicate = @OverrideDuplicatePerson,
					@PID = @CLientID OUTPUT;

			-- Associate person to Ethnicity
			IF (@Ethnicity_ID IS NOT NULL)
			EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
					@PersonID = @ClientID,
					@EthnicityID = @Ethnicity_ID

			-- Associate person to family
			if (@Family_ID is not NULL)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @ClientID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			if (@Language_ID is not NULL)
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @Language_ID, @PersonID = @ClientID, @isPrimaryLanguage = 1;

			-- associate person to Hobby
			if (@Hobby_ID is not NULL)
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby_ID, @PersonID = @ClientID;

			-- associate person to occupation
			if (@Occupation_ID is not NULL)
			EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
					@PersonID = @ClientID,
					@OccupationID = @Occupation_ID
		END TRY
		BEGIN CATCH -- insert person
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
		END CATCH; -- insert new person
	END

	IF (@Family_ID is not NULL AND @PersontoFamily_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to family', 11, -1);
		RETURN;
	END
	
	IF (@Hobby_ID is not NULL AND @PersontoHobby_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to Hobby', 11, -1);
		RETURN;
	END
	
	IF (@Language_ID is not NULL AND @PersontoLanguage_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to language', 11, -1);
		RETURN;
	END
	
	IF (@Occupation_ID is not NULL and @PersontoOccupation_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to occupation', 11, -1);
		RETURN;
	END
END

GO

