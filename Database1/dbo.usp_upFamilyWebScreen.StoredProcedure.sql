USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upFamilyWebScreen]    Script Date: 6/12/2015 8:30:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150329
-- Description:	Stored Procedure to update Family 
--              web screen information
-- =============================================

ALTER PROCEDURE [dbo].[usp_upFamilyWebScreen]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@isNewAddress bit = 0,
	@New_Last_Name varchar(50) = NULL,
	@PropertyID int = NULL,
	@New_ConstructionType int = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL,
	@New_isRemodeled bit = NULL, 
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	@New_Address_Line1 varchar(100) = NULL,
	@New_Address_Line2 varchar(100) = NULL,
	@New_CityName varchar(50) = NULL,
	@New_County varchar(50) = NULL,
	@New_StateAbbr char(2) = NULL,
	@New_ZipCode varchar(10) = NULL,
	@New_Year_Built date = NULL,
	@New_PropertyLinkTypeID tinyint = NULL,
	@New_Movein_Date date = NULL,
	@New_MoveOut_Date date = NULL,
	@New_isPrimaryResidence bit = NULL,
	@New_Owner_id int = NULL,
	@New_is_Owner_Occupied bit = NULL,
	@New_ReplacedPipesFaucets bit = NULL,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_is_Residential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_has_Peeling_Chipping_Patin bit = NULL,
	@New_is_Rental bit = NULL,
	@New_PrimaryPhone bigint = NULL,
	@PrimaryPhonePriority tinyint = 1,
	@New_SecondaryPhone bigint = NULL,
	@SecondaryPhonePriority tinyint = 2,
	@New_Number_of_Smokers tinyint = NULL,
	@New_Primary_Language_ID tinyint = 1,
	@New_Family_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	-- @New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OwnerContactInformation varchar(1000) = NULL,
	@DEBUG BIT = 1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int
			, @Update_Family_return_value int
			, @Update_Property_return_value int
			, @NotesID INT, @Recompile BIT = 1
			, @New_Primary_Property_ID int
			, @Primaryphone_return_value int
			, @Secondaryphone_return_value int
			, @FamilytoProperty_return_value int
			, @InsertedFamilytoPropertyID int
			, @DebugLogID int
	
	BEGIN TRY -- update Family information
		-- Exit if family isn't specified
		IF (@Family_ID IS NULL or @Family_ID = '')
		BEGIN
			RAISERROR ('Family must be specified', 11, 1);
			RETURN;
		END;

		-- Existing property need the primary property id
		IF (@isNewAddress = 0)
		BEGIN
			-- Select the primary property id
			Select @PropertyID = PrimaryPropertyID from Family where FamilyID = @Family_ID;

			EXEC @Update_Property_return_value = [dbo].[usp_upProperty]
				@PropertyID = @PropertyID,
				@New_ConstructionTypeID = @New_ConstructionType,
				@New_AreaID = @New_AreaID,
				@New_isinHistoricDistrict = @New_isinHistoricDistrict,
				@New_isRemodeled = @New_isRemodeled,
				@New_RemodelDate = @New_RemodelDate,
				@New_isinCityLimits = @New_isinCityLimits,
				@New_AddressLine1 = @New_Address_Line1,
				@New_AddressLine2 = @New_Address_Line2,
				@New_City = @New_CityName,
				@New_State = @New_StateAbbr,
				@New_Zipcode = @New_ZipCode,
				@New_YearBuilt = @New_Year_Built,
				@New_Ownerid = @New_Owner_id,
				@New_isOwnerOccuppied = @New_is_Owner_Occupied,
				@New_ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@New_TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				@New_isResidential = @New_is_Residential,
				@New_isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@New_hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@New_County = @New_County,
				@New_isRental = @New_is_Rental,
				@New_OwnerContactInformation = @New_OwnerContactInformation,
				@DEBUG = @DEBUG

			-- SET the new primary property ID
			SET @New_Primary_Property_ID = @PropertyID;
		END

		IF (@isNewAddress = 1)
		BEGIN
			EXEC [dbo].[usp_InsertProperty]
				@ConstructionTypeID = @New_ConstructionType,
				@AreaID = @New_AreaID,
				@isinHistoricDistrict = @New_isinHistoricDistrict, 
				@isRemodeled = @New_isRemodeled,
				@RemodelDate = @New_RemodelDate,
				@isinCityLimits = @New_isinCityLimits,
				@AddressLine1 = @New_Address_Line1,
				@AddressLine2 = @New_Address_Line2,
				@City = @New_CityName,
				@State = @New_StateAbbr,
				@Zipcode = @New_ZipCode,
				@YearBuilt = @New_Year_Built,
				@Ownerid = @New_Owner_id,
				@isOwnerOccuppied = @New_is_Owner_Occupied,
				@ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				-- @isResidential = @New_isResidential,
				@isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@County = @New_County,
				-- @isRental = @New_isRental,
				--@OverRideDuplicate = @New_OverRideDuplicate,
				@OwnerContactInformation = @New_OwnerContactInformation,
				@PropertyID = @New_Primary_Property_ID OUTPUT
		END

		EXEC	@Update_Family_return_value = [dbo].[usp_upFamily]
				@Family_ID = @Family_ID,
				@New_Last_Name = @New_Last_Name,
				@New_Number_of_Smokers = @New_Number_of_Smokers,
				@New_Primary_Language_ID = @New_Primary_Language_ID,
				@New_Notes = @New_Family_Notes,
				@New_Pets = @New_Pets,
				@New_Frequently_Wash_Pets = @New_Frequently_Wash_Pets,
				@New_Pets_in_and_out = @New_Pets_in_and_out,
				@New_Primary_Property_ID = @New_Primary_Property_ID,
				@New_ForeignTravel = @New_ForeignTravel,
				@DEBUG = @DEBUG;

		EXEC @FamilytoProperty_return_value = [usp_InsertFamilytoProperty] 
				@FamilyID = @Family_ID,
				@PropertyID = @New_Primary_Property_ID,
				@PropertyLinkTypeID = @New_PropertyLinkTypeID,
				@StartDate = @New_Movein_Date,
				@EndDate = @New_MoveOut_Date,
				@isPrimaryResidence = @New_isPrimaryResidence,
				@NewFamilytoPropertyID = @InsertedFamilytoPropertyID OUTPUT


		if (@New_PrimaryPhone is not NULL) 
			BEGIN  -- insert Primary Phone
				DECLARE @PrimaryPhoneNumberID_OUTPUT bigint, @PhoneTypeID tinyint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Primary Phone';

				EXEC	@Primaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @New_PrimaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @PrimaryPhoneNumberID_OUTPUT OUTPUT
				
				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @Family_ID,
						@NumberPriority = @PrimaryPhonePriority,
						@PhoneNumberID = @PrimaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
			END  -- insert Primary Phone

			if (@New_SecondaryPhone is not NULL) 
			BEGIN  -- insert Secondary Phone
				DECLARE @SecondaryPhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Secondary Phone';

				EXEC	@Secondaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @New_SecondaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @SecondaryPhoneNumberID_OUTPUT OUTPUT

				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @Family_ID,
						@NumberPriority = @SecondaryPhonePriority,
						@PhoneNumberID = @SecondaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
						
			END  -- insert Secondary Phone

	END TRY -- update Family
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
