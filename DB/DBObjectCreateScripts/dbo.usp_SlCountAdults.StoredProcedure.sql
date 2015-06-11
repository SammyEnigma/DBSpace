USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountAdults]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150610
-- Description:	User defined stored procedure to
--              count adults visiting during 
--				reporting period
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountAdults]
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

	select @spexecutesqlStr ='Select Adults = count([Adults].[PersonID])
								FROM (
										Select PersonID,MostRecentVisit = SampleDate from BloodtestResults 
											where SampleDate >= @StartDate AND SampleDate < @EndDate 
										UNION
										Select PersonID,MostRecentVisit = QuestionnaireDate from Questionnaire 
											where QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
									) Adults
									JOIN Person AS P on [P].[PersonID] = [Adults].[PersonID] 
									-- group by [Adults].[PersonID]
									having [dbo].[udf_CalculateAge](max([P].[BirthDate]),max(MostRecentVisit)) > 17
									'
	
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
