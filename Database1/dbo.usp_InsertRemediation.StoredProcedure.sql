USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediation]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Remediation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediation]   -- usp_InsertRemediation 
	-- Add the parameters for the stored procedure here
	@RemediationApprovalDate date = getdate,
	@RemediationStartDate date = NULL,
	@RemediationEndDate date = NULL,
	@PropertyID int = NULL,
	@RemediationActionPlanID int = NULL,
	@AccessAgreementID int = NULL,
	@FinalRemediationReportFile varbinary(max) = NULL,
	@FinalRemediationReportDate date = Null,
	@RemediationCost money = NULL,
	@OneYearRemediationCompleteDate date = NULL,
	@Notes varchar(3000) = NULL,
	@OneYearRemediatioNComplete bit = NULL,
	@NewRemediationID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @RemediationNotes_return int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Remediation ( RemediationApprovalDate, RemediationStartDate, RemediationEndDate, PropertyID
		                           , RemediationActionPlanID, AccessAgreementID, FinalRemediationReportFile, FinalRemediationReportDate
								   , RemediationCost, OneYearRemediationCompleteDate, OneYearRemediationComplete )
					 Values ( @RemediationApprovalDate, @RemediationStartDate, @RemediationEndDate, @PropertyID
		                      , @RemediationActionPlanID, @AccessAgreementID, @FinalRemediationReportFile, @FinalRemediationReportDate
							  , @RemediationCost, @OneYearRemediationCompleteDate, @OneYearRemediationComplete);
		SELECT @NewRemediationID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertRemediationNotes]
								@Remediation_ID = @NewRemediationID,
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
