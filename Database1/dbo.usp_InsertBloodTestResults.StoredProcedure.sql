USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertBloodTestResults]    Script Date: 6/11/2015 5:18:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new BloodTestResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertBloodTestResults]   -- usp_InsertBloodTestResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PersonID int = NULL,
	@SampleDate date = NULL,
	@LabSubmissionDate date = NULL,
	@LeadValue numeric(4,1) = NULL,
	@LeadValueCategoryID tinyint = NULL,
	@HemoglobinValue numeric(4,1) = NULL,
	@HemoglobinValueCategoryID tinyint = NULL, -- lookup in the database
	@HematocritValueCategoryID tinyint = NULL, -- lookup in the database
	@LabID int = NULL,
	@ClientStatusID smallint = NULL,
	@BloodTestCosts money = NULL,
	@sampleTypeID tinyint = NULL,
	@New_Notes varchar(3000) = NULL,
	@TakenAfterPropertyRemediationCompleted bit = NULL,
	@BloodTestResultID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ExistsPersonID int -- does the person have a record in BloodTestResults table
			, @ErrorLogID int, @NotesID int;
	-- Handle Null sampleDate?
	-- Handle Null LabSubmissionDate?

	-- check if the person exists
	IF NOT EXISTS (select PersonID from Person where PersonID = @PersonID)
	BEGIN
		RAISERROR ('Person does not exist. Cannot create a BloodtestResult record', 11, -1);
		RETURN;
	END

	-- check if the person has a record in BloodTestResults Table
	select @ExistsPersonID = PersonID from BloodTestResults

    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPersonID is not NULL )
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
			IF (@ExistsPersonID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPersonID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into BloodTestResults ( isBaseline, PersonID, SampleDate, LabSubmissionDate, LeadValue, LeadValueCategoryID,
		                                HemoglobinValue, HemoglobinValueCategoryID, HematocritValueCategoryID, LabID, ClientStatusID,
										BloodTestCosts, SampleTypeID, TakenAfterPropertyRemediationCompleted)
					 Values ( @isBaseline, @PersonID, @SampleDate, @LabSubmissionDate, @LeadValue, @LeadValueCategoryID,
		                      @HemoglobinValue, @HemoglobinValueCategoryID, @HematocritValueCategoryID, @LabID, @ClientStatusID,
							  @BloodTestCosts, @SampleTypeID, @TakenAfterPropertyRemediationCompleted);
		SELECT @BloodTestResultID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertBloodTestResultsNotes]
							@BloodtestResults_ID = @BloodTestResultID,
							@Notes = @New_Notes,
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
