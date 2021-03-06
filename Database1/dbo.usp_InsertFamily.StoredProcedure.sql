USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamily]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert new Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50) = NULL,
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@ForeignTravel bit = NULL,
	@New_Travel_Notes varchar(3000) = NULL,
	@Travel_Start_Date date = NULL,
	@Travel_End_Date date = NULL,
	@Pets tinyint = NULL,
	@Petsinandout bit = NULL,
	@PrimaryPropertyID int = NULL,
	@FrequentlyWashPets bit = NULL,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @FamilyNotesReturnValue int, @InsertedFamilyNotesID int
			, @TravelNotesReturnValue int, @InsertedTravelNotesID int;

	BEGIN TRY -- insert Family
		BEGIN TRANSACTION InsertFamilyTransaction
			INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID, Pets, Petsinandout
						, PrimaryPropertyID, FrequentlyWashPets, ForeignTravel) 
						Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Pets, @Petsinandout
						, @PrimaryPropertyID, @FrequentlyWashPets, @ForeignTravel)
			SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values

			IF (@Notes IS NOT NULL)
				EXEC	@FamilyNotesReturnValue = [dbo].[usp_InsertFamilyNotes]
													@Family_ID = @FID,
													@Notes = @Notes,
													@InsertedNotesID = @InsertedFamilyNotesID OUTPUT
	
			IF (@New_Travel_Notes IS NOT NULL)
				EXEC	@TravelNotesReturnValue = [dbo].[usp_InsertTravelNotes]
						@Family_ID = @FID,
						@Travel_Notes = @New_Travel_Notes,
						@Start_Date = @Travel_Start_Date,
						@End_Date = @Travel_End_Date,
						@InsertedNotesID = @InsertedTravelNotesID OUTPUT

		COMMIT TRANSACTION InsertFamilyTransaction
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
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
