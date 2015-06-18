USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upClientWebScreen]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150325
-- Description:	stored procedure to update data 
--              from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_upClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
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
	@New_ClientNotes varchar(3000) = NULL,
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	--@New_isNursing bit = NULL,
	--@New_isPregnant bit = NULL,
	@New_EthnicityID tinyint = NULL,
	@New_LanguageID tinyint = NULL,
	@New_PrimaryLanguage bit = 1,
	@New_HobbyID int = NULL,
	@New_OccupationID int = NULL,
	@New_Occupation_StartDate date = NULL,
	@New_Occupation_EndDate date = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@updatePerson_return_value int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL OR @Person_ID IS NULL)
		BEGIN
			RAISERROR ('Family and Person must be supplied', 11, -1);
			RETURN;
		END;

		if (@New_LastName is null)
		BEGIN
			select @New_LastName = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- update person
			EXEC	@updatePerson_return_value = [dbo].[usp_upPerson]
						@Person_ID = @Person_ID,
						@New_FirstName = @New_FirstName,
						@New_MiddleName = @New_MiddleName,
						@New_LastName = @New_LastName,
						@New_BirthDate = @New_BirthDate,
						@New_Gender = @New_Gender,
						@New_StatusID = @New_StatusID,
						@New_ForeignTravel = @New_ForeignTravel,
						@New_OutofSite = @New_OutofSite,
						@New_EatsForeignFood = @New_EatsForeignFood,
						@New_EmailAddress = @New_EmailAddress,
						@New_RetestDate = @New_RetestDate,
						@New_Moved = @New_Moved,
						@New_MovedDate = @New_MovedDate,
						@New_isClosed = @New_isClosed,
						@New_isResolved = @New_isResolved,
						@New_PersonNotes = @New_ClientNotes,
						@New_GuardianID = @New_GuardianID,
						@New_PersonCode = @New_PersonCode,
						@New_isSmoker = @New_isSmoker,
						@New_isClient = @New_isClient,
						@New_NursingMother = @New_NursingMother,
						@New_NursingInfant = @New_NursingInfant,
						@New_Pregnant = @New_Pregnant,
						@DEBUG = @DEBUG

			-- Associate person to Ethnicity
			IF ((@New_EthnicityID IS NOT NULL) AND
					(NOT EXISTS (SELECT PersonID from PersontoEthnicity where EthnicityID = @New_EthnicityID and PersonID = @Person_ID)))
				EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
						@PersonID = @Person_ID,
						@EthnicityID = @New_EthnicityID
			-- CODE FOR FUTURE EXTENSIBILITY OF UPDATING ETHNICITY
			--IF (@New_Ethnicity IS NOT NULL)
			--EXEC	@Ethnicity_return_value = [dbo].[usp_upEthnicity]
			--		@PersonID = @Person_ID,
			--		@New_EthnicityID = @New_EthnicityID,
			--		@DEBUG = @DEBUG,
			--		@PersontoEthnicityID = @New_PersontoEthnicityID OUTPUT

			-- Associate person to family
			-- If the person isn't already associated with that family
			if NOT EXISTS(SELECT PersonID from PersontoFamily where FamilyID = @Family_ID and PersonID = @Person_ID)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @Person_ID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			IF (@New_LanguageID is not NULL)
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @New_LanguageID, @PersonID = @Person_ID, @isPrimaryLanguage = @New_PrimaryLanguage;

			-- associate person to Hobby
			IF ((@New_HobbyID is not NULL) AND 
				(NOT EXISTS (SELECT PersonID from PersontoHobby where HobbyID = @New_HobbyID and PersonID = @Person_ID)) )
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @New_HobbyID, @PersonID = @Person_ID;

			-- associate person to occupation
			if ((@New_OccupationID is not NULL))
				IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where OccupationID = @New_OccupationID and PersonID = @Person_ID))
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@StartDate = @New_Occupation_StartDate,
						@EndDate = @New_Occupation_EndDate
			ELSE
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_upOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@Occupation_StartDate = @New_Occupation_StartDate,
						@Occupation_EndDate = @New_Occupation_EndDate,
						@DEBUG = @DEBUG;
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
END



GO
