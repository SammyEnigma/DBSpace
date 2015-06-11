USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountClients]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountClients] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar)
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select  Clients = count(PersonID) from (
			SELECT  PersonID from bloodTestResults WHERE 1=1 AND SampleDate >= @StartDate AND SampleDate < @EndDate
			UNION
			SELECT  PersonID from Questionnaire WHERE 1=1 AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
			) total'
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		
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
