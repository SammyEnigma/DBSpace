USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditQuestionnaireWebScreenInformation]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to select 
--              questionnaire edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditQuestionnaireWebScreenInformation]
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
		N'select [Q].[QuestionnaireID]
		, [Q].[QuestionnaireDate]
		, [Q].[isExposedtoPeelingPaint]
		, [Q].[PaintDate]
		, [Q].[VisitRemodeledProperty]
		, [Q].[VisitsOldHOmes]
		, [Q].[RemodelPropertyDate]
		, [Q].[isTakingVitamins]
		, [Q].[FrequentHandWashing]
		, [Q].[isUsingBottle]
		, [Q].[NursingMother]
		, [Q].[Pregnant]
		, [Q].[NursingInfant]
		, [Q].[isUsingPacifier]
		, [Q].[BitesNails]
		, [Q].[EatOutside]
		, [Q].[NonFoodinMouth]
		, [Q].[NonFoodEating]
		, [Q].[Suckling]
		, [Q].[Mouthing]
		, [Q].[DaycareID]
		from [Questionnaire] AS [Q]
		where [Q].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [Q].[QuestionnaireDate] desc';
	
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
