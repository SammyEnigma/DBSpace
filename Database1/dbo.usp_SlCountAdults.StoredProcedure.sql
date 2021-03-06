USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountAdults]    Script Date: 7/16/2015 12:29:26 AM ******/
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
	@MinAge tinyint = 17,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE  @ErrorLogID int, @ReturnError int;

	BEGIN TRY 

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101'

		IF (@ENDDate IS NULL)
			SET @EndDate = GetDate();

		-- Create temporary table
		CREATE Table #TempPotentialAdults
		( PersonID int 
			, TestID int
			, AgeAtVisit tinyint
			, MostRecentVisit date
			, Birthdate date
			, Visits tinyint
		)

		-- insert values from bloodtest results
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				select PersonID,MostRecentVisit = SampleDate, TestID = BloodTestResultsID 
				from BloodtestResults 
					where SampleDate >= @StartDate AND SampleDate < @EndDate 

		-- insert values from questionnaire	
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				Select PersonID,MostRecentVisit = QuestionnaireDate, TestID = QuestionnaireID 
				from Questionnaire 
					where QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
					and (ISNULL(Questionnaire.NursingMother,0) = 0 OR  ISNULL(Questionnaire.Pregnant,0) = 0 )

		-- populate birthdate only if the difference from most recent visit to birthdate is at least minAge
			update #TempPotentialAdults set BirthDate = Person.Birthdate,
				 AgeAtVisit = [dbo].[udf_CalculateAge]([Person].[BirthDate],MostRecentVisit)
			FROM #TempPotentialAdults
			JOIN Person on Person.PersonID = #TempPotentialAdults.PersonID
			where Datediff(yy,Person.BirthDate,MostRecentVisit) > @MinAge

		Select AdultsTested = count(distinct PersonID) from #TempPotentialAdults
		where AgeAtVisit > @MinAge

		drop table #TempPotentialAdults
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
