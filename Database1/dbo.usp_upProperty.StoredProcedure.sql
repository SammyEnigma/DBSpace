USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upProperty]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to update property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_upProperty]   -- usp_upProperty 
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@New_ConstructionTypeID tinyint = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL, 
	@New_isRemodeled bit = NULL,
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	@New_AddressLine1 varchar(100) = NULL,
	@New_AddressLine2 varchar(100) = NULL,
	@New_City varchar(50) = NULL,
	@New_State char(2) = NULL,
	@New_Zipcode varchar(12) = NULL,
	@New_YearBuilt date = NULL,
	@New_Ownerid int = NULL,
	@New_isOwnerOccuppied bit = NULL,
	@New_ReplacedPipesFaucets tinyint = 0,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_isResidential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_hasPeelingChippingPaint bit = NULL,
	@New_County varchar(50) = NULL,
	@New_isRental bit = NULL,
	@New_OwnerContactInformation varchar(1000) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePropertysqlStr nvarchar(4000);
    -- Insert statements for procedure here
	BEGIN TRY
		if (@PropertyID iS NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Property must be specified';
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		-- BUILD update statement
		IF (@New_isinHistoricDistrict IS NULL)
			SELECT @New_isinHistoricDistrict = isinHistoricDistrict from Property where PropertyID = @PropertyID;
	
		SELECT @spupdatePropertysqlStr = N'update Property set isinHistoricDistrict = @isinHistoricDistrict'

		IF (@New_ConstructionTypeID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ConstructionTypeID = @ConstructionTypeID'

		IF (@New_AreaID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AreaID = @AreaID'

		IF (@New_isRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRemodeled = @isRemodeled'

		IF (@New_RemodelDate IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', RemodelDate = @RemodelDate'

		IF (@New_isinCityLimits IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isinCityLimits = @isinCityLimits'

		IF (@New_AddressLine1 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine1 = @AddressLine1'

		IF (@New_AddressLine2 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine2 = @AddressLine2'	
			
		IF (@New_City IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', City = @City'

		IF (@New_State IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', State = @State'

		IF (@New_Zipcode IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ZipCode = @ZipCode'

		IF (@New_Ownerid IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', OwnerID = @OwnerID'
			
		IF (@New_isOwnerOccuppied IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isOwnerOccuppied = @isOwnerOccuppied'
			
		IF (@New_ReplacedPipesFaucets IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ReplacedPipesFaucets = @ReplacedPipesFaucets'
			
		IF (@New_TotalRemediationCosts IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', TotalRemediationCosts = @TotalRemediationCosts'
			
		IF (@New_isResidential IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isResidential = @isResidential'
			
		IF (@New_isCurrentlyBeingRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isCurrentlyBeingRemodeled = @isCurrentlyBeingRemodeled'
			
		IF (@New_hasPeelingChippingPaint IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', hasPeelingChippingPaint = @hasPeelingChippingPaint'
			
		IF (@New_County IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', County = @County'
			
		IF (@New_isRental IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRental = @isRental'
			
		IF (@New_YearBuilt IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', YearBuilt = @YearBuilt'

		IF (@New_OwnerContactInformation IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', OwnerContactInformation = @OwnerContactInformation'

		SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N' WHERE PropertyID = @PropertyID'

		-- update property table
		IF @DEBUG = 1
			SELECT @spupdatePropertysqlStr, New_ConstructionTypeID = @New_ConstructionTypeID, New_AreaID = @New_AreaID
					, New_isinHistoricDistrict = @New_isinHistoricDistrict, New_isRemodeled = @New_isRemodeled
					, New_RemodelDate = @New_RemodelDate, New_isinCityLimits = @New_isinCityLimits
					, New_AddressLine1 = @New_AddressLine1, New_AddressLine2 = @New_AddressLine2, New_City = @New_City
					, New_State = @New_State, New_Zipcode = @New_Zipcode, New_OwnerID = @New_Ownerid
					, New_isOwnerOccuppied = @New_isOwnerOccuppied, New_ReplacedPipesFaucets = @New_ReplacedPipesFaucets
					, New_PropertyNotes = @New_PropertyNotes, New_TotalRemediationCosts = @New_TotalRemediationCosts
					, New_isResidential = @New_isResidential, New_isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled
					, New_hasPeelingChippingPaint = @New_hasPeelingChippingPaint, New_County = @New_County
					, New_isRental = @New_isRental, New_YearBuilt = @New_YearBuilt
					, New_OwnerContactInformation = @New_OwnerContactInformation, PropertyID = @PropertyID

		EXEC [sp_executesql] @spupdatePropertysqlStr 
			, N'@ConstructionTypeID tinyint, @AreaID int, @isinHistoricDistrict bit, @isRemodeled bit, @RemodelDate date
			, @isinCityLimits BIT, @AddressLine1 varchar(100), @AddressLine2 varchar(100), @City varchar(50), @State char(2)
			, @Zipcode varchar(12), @OwnerID int, @isOwnerOccuppied bit, @ReplacedPipesFaucets tinyint, @TotalRemediationCosts money
			, @isResidential bit, @isCurrentlyBeingRemodeled bit, @hasPeelingChippingPaint bit
			, @County varchar(50), @isRental bit, @YearBuilt date, @OwnerContactInformation varchar(1000), @PropertyID int'
			, @ConstructionTypeID = @New_ConstructionTypeID
			, @AreaID = @New_AreaID
			, @isinHistoricDistrict = @New_isinHistoricDistrict
			, @isRemodeled = @New_isRemodeled
			, @RemodelDate = @New_RemodelDate
			, @isinCityLimits = @New_isinCityLimits
			, @AddressLine1 = @New_AddressLine1
			, @AddressLine2 = @New_AddressLine2
			, @City = @New_City
			, @State = @New_State
			, @Zipcode = @New_Zipcode
			, @OwnerID = @New_Ownerid
			, @isOwnerOccuppied = @New_isOwnerOccuppied
			, @ReplacedPipesFaucets = @New_ReplacedPipesFaucets
			, @TotalRemediationCosts = @New_TotalRemediationCosts
			, @isResidential = @New_isResidential
			, @isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled
			, @hasPeelingChippingPaint = @New_hasPeelingChippingPaint
			, @County = @New_County
			, @isRental = @New_isRental
			, @YearBuilt = @New_YearBuilt
			, @OwnerContactInformation = @New_OwnerContactInformation
			, @PropertyID = @PropertyID

		IF (@New_PropertyNotes IS NOT NULL)
		BEGIN
			IF @DEBUG = 1
				SELECT 'EXEC [dbo].[usp_InsertPropertyNotes] @Property_ID = @Property_ID, @Notes = @New_PropertyNotes, @InsertedNotesID = @NotesID OUTPUT ' 
					, @PropertyID, @New_PropertyNotes

				EXEC	[dbo].[usp_InsertPropertyNotes]
						@Property_ID = @PropertyID,
						@Notes = @New_PropertyNotes,
						@InsertedNotesID = @NotesID OUTPUT
		END

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
