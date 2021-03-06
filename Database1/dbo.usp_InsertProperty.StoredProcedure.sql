USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertProperty]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertProperty]   -- usp_InsertProperty 
	-- Add the parameters for the stored procedure here
	@ConstructionTypeID tinyint = NULL,
	@AreaID int = NULL,
	@isinHistoricDistrict bit = NULL, 
	@isRemodeled bit = NULL,
	@RemodelDate date = NULL,
	@isinCityLimits bit = NULL,
	@AddressLine1 varchar(100) = NULL,
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50) = NULL,
	@State char(2) = NULL,
	@Zipcode varchar(12) = NULL,
	@YearBuilt date = NULL,
	@Ownerid int = NULL,
	@isOwnerOccuppied bit = NULL,
	@ReplacedPipesFaucets tinyint = 0,
	@TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@isResidential bit = NULL,
	@isCurrentlyBeingRemodeled bit = NULL,
	@hasPeelingChippingPaint bit = NULL,
	@County varchar(50) = NULL,
	@isRental bit = NULL,
	@OverRideDuplicate bit = 1,
	@OwnerContactInformation varchar(1000) = NULL,
	@PropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Check if the property already exists, if it does, return the propertyID
		SELECT @PropertyID = [dbo].udf_DoesPropertyExist (
						@AddressLine1,
						@AddressLine2,
						@City,
						@State,
						@ZipCode
						)

		if (@PropertyID iS NOT NULL)
		BEGIN
			if (@OverrideDuplicate = 0)
			BEGIN
				DECLARE @ErrorString VARCHAR(3000);
				SET @ErrorString = 'Property Address ' + @AddressLine1 + ', ' + @City + ', ' + @State + ', ' + @ZipCode
								   + ' '  + ' appears to be a duplicate of: ' + cast(@PropertyID as varchar(30));
				RAISERROR('@PropertyID exists: @AddressLine1, @City, @State, @ZipCode', 11, -1);
				RETURN;
			END

			-- RETURN THE PropertyID of the matching property
			PRINT 'returning existing propertyID: ' + cast(@PropertyID as varchar);
			RETURN;
		END


		 INSERT into property (ConstructionTypeID, AreaID, isinHistoricDistrict, isRemodeled, RemodelDate, 
							  isinCityLimits, AddressLine1, AddressLine2, City, [State], Zipcode,
							  YearBuilt, OwnerID, isOwnerOccuppied, ReplacedPipesFaucets, TotalRemediationCosts,
							  isResidential, isCurrentlyBeingRemodeled, hasPeelingChippingPaint, County, isRental
							  , OwnerContactInformation) 
					 Values ( @ConstructionTypeID, @AreaID, @isinHistoricDistrict, @isRemodeled, @RemodelDate, 
							  @isinCityLimits, @AddressLine1, @AddressLine2, @City, @State, @Zipcode,
							  @YearBuilt, @OwnerID, @isOwnerOccuppied, @ReplacedPipesFaucets, @TotalRemediationCosts,
							  @isResidential, @isCurrentlyBeingRemodeled, @hasPeelingChippingPaint, @County, @isRental
							  , @OwnerContactInformation);
		SET @PropertyID = SCOPE_IDENTITY();

		IF (@New_PropertyNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPropertyNotes]
								@Property_ID = @PropertyID,
								@Notes = @New_PropertyNotes,
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
