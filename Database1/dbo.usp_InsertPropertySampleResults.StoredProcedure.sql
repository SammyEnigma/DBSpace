USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertySampleResults]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertySampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertySampleResults]   -- usp_InsertPropertySampleResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PropertyID int = NULL,
	@LabSubmissionDate date = getdate,
	@LabID int = NULL,
	@SampleTypeID tinyint = NULL,
	@Notes varchar(3000) = NULL,
	@NewPropertySampleResultsID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistsPropertyID int, @NotesID int, @Notes_Results int;

	-- check if the property has a record in BloodTestResults Table
	select @ExistsPropertyID = PropertyID from PropertySampleResults


    -- Insert statements for procedure here
	BEGIN TRY
	-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPropertyID is not NULL )
			BEGIN
				SET @isBaseline = 0;
			END
			ELSE -- the person has no entry in BloodTestResults, this is a baseline entry
			BEGIN
				SET @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 0 ) -- this should not be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into PropertySampleResults ( isBaseline, PropertyID, LabSubmissionDate, LabID,
		                                   SampleTypeID )
					 Values ( @isBaseline, @PropertyID, @LabSubmissionDate, @LabID,
		                                   @SampleTypeID );
		SELECT @NewPropertySampleResultsID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	@Notes_results = [usp_InsertPropertySampleResultsNotes]
								@PropertySampleResults_ID = @NewPropertySampleResultsID,
								@Notes = @Notes,
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
