USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountHomeVisitSoilSample]    Script Date: 7/16/2015 12:29:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150611
-- Description:	User defined stored procedure to
--              count clients that have a status
--				of home visit and/or soil sample
--              during the reporting period
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountHomeVisitSoilSample]
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

	select @spexecutesqlStr ='select [HomeVisitSoilSamples] = count(PersonID) from (
						SELECT PersonID
						from BloodTestResults where SampleDate >= @StartDate and SampleDate < @EndDate
								AND ClientStatusID in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
														where TargetType = ''Person''
														AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')
													  )
						UNION
						-- people with questionnaire but no blood test during reporting period
						Select Q.PersonID
						from Questionnaire AS Q
								LEFT OUTER JOIN  [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
																select top 1 [BloodTestResultsID] from [BloodTestResults] 
																where [BloodTestResults].[PersonID] = [Q].[PersonID]
																-- AND SampleDate >= @StartDate AND SampleDate < @EndDate
																AND BTR.ClientStatusID
																	in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
																			where TargetType = ''Person''
																			AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
																		)
																order by SampleDate desc
																)
								where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate 
								AND BTR.ClientStatusID
									in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
											where TargetType = ''Person''
											AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
										)
						) HomeVisitSoilSamples'
	
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
