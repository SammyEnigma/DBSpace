USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upBloodTestResults]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130618
-- Description:	Stored Procedure to update 
--              blood test results records
-- =============================================
-- DROP PROCEDURE usp_upBloodTestResults
CREATE PROCEDURE [dbo].[usp_upBloodTestResults]  
	-- Add the parameters for the stored procedure here
	@BloodTestResultsID int = NULL,
	@New_Sample_Date date = NULL,
	@New_Lab_Date date = NULL,
	@New_Blood_Lead_Result numeric(4,1) = NULL,
	-- @New_Flag smallint = NULL,
	@New_Hemoglobin_Value numeric(4,1) = NULL,
	@New_Lab_ID int = NULL,
	@New_Blood_Test_Costs money = NULL,
	@New_Sample_Type_ID tinyint = NULL,
	@New_Taken_After_Property_Remediation_Completed bit = NULL,
	@New_Exclude_Result bit = NULL,
	@New_Client_Status_ID smallint = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdateBloodTestResultssqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if BloodTestResultsID is valid, if not return
		IF NOT EXISTS (SELECT BloodTestResultsID from BloodTestResults where BloodTestResultsID = @BloodTestResultsID)
		BEGIN
			RAISERROR(15000, -1,-1,'usp_upBloodTestResults');
		END
		
		-- BUILD update statement
		if (@New_Blood_Lead_Result is null)
			select @New_Blood_Lead_Result = LeadValue from BloodTestResults where BloodTestResultsID = @BloodTestResultsID
		
		SELECT @spupdateBloodTestResultssqlStr = N'update BloodTestResults set LeadValue = @Blood_Lead_Result'

		IF (@New_Sample_Date IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', SampleDate = @Sample_Date'

		IF (@New_Lab_Date IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', LabSubmissionDate = @Lab_Date'

		IF (@New_Hemoglobin_Value IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', HemoglobinValue = @Hemoglobin_Value'

		IF (@New_Lab_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', LabID = @Lab_ID'

		IF (@New_Blood_Test_Costs IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', BloodTestCosts = @Blood_Test_Costs'

		IF (@New_Sample_Type_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', SampleTypeID = @Sample_Type_ID'

		IF (@New_Taken_After_Property_Remediation_Completed IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', TakenAfterPropertyRemediationCompleted = @Taken_After_Property_Remediation_Completed'

		IF (@New_Exclude_Result IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', ExcludeResult = @Exclude_Result'

		IF (@New_Client_Status_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', ClientStatusID = @Client_Status_ID'

		-- make sure to only update record for specified BloodTestResults
		SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N' WHERE BloodTestResultsID = @BloodTestResultsID'

		IF (@DEBUG = 1)
			SELECT @spupdateBloodTestResultssqlStr, LeadValue = @New_Blood_Lead_Result, SampleDate = @New_Sample_Date, LabSubmissionDate = @New_Lab_Date
					, HemoglobinVlaue = @New_Hemoglobin_Value, LabID = @New_Lab_ID, BloodTestCosts = @New_Blood_Test_Costs, SampleTypeID = @New_Sample_Type_ID
					, TakenAfterPropertyRemediationCompleted = @New_Taken_After_Property_Remediation_Completed, ExcludeResult = @New_Exclude_Result
					, ClientStatusID = @New_Client_Status_ID, BloodTestResultsID = @BloodTestResultsID

		EXEC [sp_executesql] @spupdateBloodTestResultssqlStr
				, N'@Blood_Lead_Result numeric(4,1), @Sample_Date date, @Lab_Date date, @Hemoglobin_Value numeric(4,1), @Lab_ID int, @Blood_Test_Costs money
				, @Sample_Type_ID tinyint, @Taken_After_Property_Remediation_Completed bit, @Exclude_Result bit
				, @Client_Status_ID smallint, @BloodTestResultsID int'
				, @Blood_Lead_Result = @New_Blood_Lead_Result
				, @Sample_Date = @New_Sample_Date
				, @Lab_Date = @New_Lab_Date
				, @Hemoglobin_Value = @New_Hemoglobin_Value
				, @Lab_ID = @New_Lab_ID
				, @Blood_Test_Costs = @New_Blood_Test_Costs
				, @Sample_Type_ID = @New_Sample_Type_ID
				, @Taken_After_Property_Remediation_Completed = @New_Taken_After_Property_Remediation_Completed
				, @Exclude_Result = @New_Exclude_Result
				, @Client_Status_ID = @New_Client_Status_ID
				, @BloodTestResultsID = @BloodTestResultsID

			IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertBloodTestResultsNotes]
								@BloodTestResults_ID = @BloodTestResultsID,
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
