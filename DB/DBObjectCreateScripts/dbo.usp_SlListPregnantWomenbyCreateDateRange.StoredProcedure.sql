USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlListPregnantWomenbyCreateDateRange]    Script Date: 4/28/2015 12:03:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select PregnantWomen by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListPregnantWomenbyCreateDateRange]
	-- Add the parameters for the stored procedure here
	@Begin_Date date = NULL,
	@End_Date date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	--SELECT [P].[PersonID], 'FamilyName' = [F].[LastName]
	--	, [P].[LastName], [P].[FirstName], [P].[CreatedDate]
	--	FROM [Person] AS [P]
	--	JOIN PersontoFamily AS P2F ON [P].[PersonID] = [P2F].[PersonID]
	--	JOIN [family] AS [F] ON [P2F].[FamilyID] = [F].[FamilyID]
	--	where 1 = 2 AND [P].[CreatedDate] >= @Begin_Date AND [P].[CreatedDate] <= @End_Date order by [P].[LastName],[P].[PersonID] OPTION(RECOMPILE)

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[CreatedDate]
								from [Person] AS [P]
								where isPregnant = 1'
	
	-- Return all PregnantWomen if nothing was passed in
	IF ((@Begin_Date is NULL) AND (@End_Date is NULL))
		SET @Recompile = 0

	IF (@Begin_Date is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate'

	IF (@End_Date is NOT NULL)
	BEGIN
		SET @End_Date = DateAdd(dd,1,@End_Date)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate'
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @Begin_Date, 'ENDDate' = @End_Date, 'DEBUG' = @Debug

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @Begin_Date
		, @EndDate = @End_Date;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO

