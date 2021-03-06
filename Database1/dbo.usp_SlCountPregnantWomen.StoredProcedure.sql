USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPregnantWomen]    Script Date: 7/16/2015 12:29:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150610
-- Description:	User defined stored procedure to
--              count Pregnant Women
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPregnantWomen]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	IF (@StartDate IS NULL)
		SET @StartDate = '18000101'

	IF (@ENDDate IS NULL)
		SET @EndDate = GetDate();

	select @spexecutesqlStr ='Select [PregnantWomen] = COUNT(PersonID) from (
								Select BTR.PersonID,Q.Pregnant from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by Pregnant desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.Pregnant = 1

								UNION 
								SELECT PersonID,Pregnant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND Pregnant = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.Pregnant = 1'
	
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		-- DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END


GO
