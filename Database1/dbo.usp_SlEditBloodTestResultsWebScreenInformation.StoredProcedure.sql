USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditBloodTestResultsWebScreenInformation]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to select 
--              bloodtestresults edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditBloodTestResultsWebScreenInformation]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@PersonID IS NULL)
	BEGIN
		RAISERROR ('You must supply a person.', 11, -1);
		RETURN;
	END;
	
	SELECT @spexecuteSQLStr =
		N'select [BTR].[BloodTestResultsID]
		,[BTR].[SampleDate]
		,[BTR].[LabSubmissiondate]
		,[L].[LabName]
		,[BTR].[LeadValue]
		,[FollowupDate] = [P].[RetestDate]
		,[ST].[SampleTypeName]
		,[TS].[StatusName]
		,[BTR].[HemoglobinValue]
		from [BloodTestResults] AS [BTR]
		LEFT OUTER JOIN [Person] AS [P] on [BTR].[PersonID] = [P].[PersonID]
		LEFT OUTER JOIN [Lab] AS [L] on [BTR].[LabID] = [L].[LabID]
		LEFT OUTER JOIN [SampleType] AS [ST] on [BTR].[SampleTypeID] = [ST].[SampleTypeID]
		LEFT OUTER JOIN [TargetStatus] AS [TS] on [BTR].[ClientStatusID] = [TS].[StatusID]
		where [BTR].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [BTR].[SampleDate] desc';
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
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
