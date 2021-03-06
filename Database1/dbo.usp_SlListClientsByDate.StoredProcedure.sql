USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListClientsByDate]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150731
-- Description:	User defined stored procedure to
--              select People by created or
--				modified date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListClientsByDate]
	-- Add the parameters for the stored procedure here
	@CreateStartDate date = NULL,
	@CreateEndDate date = NULL,
	@ModifiedStartDate date = NULL,
	@ModifiedEndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[HistoricChildId],[P].[LastName],[P].[MiddleName],[P].[FirstName],[P].[BirthDate]
								,[P].[Gender],[P].[Age],[P].[ModifiedDate],[P].[CreatedDate]
								from [Person] AS [P]
								where 1 = 1';
	
	-- Return all People if nothing was passed in
	IF ((@CreateStartDate is NULL) AND (@CreateEndDate is NULL) AND (@ModifiedStartDate is NULL) AND (@ModifiedEndDate is NULL))
		SET @Recompile = 0;

	IF (@CreateStartDate is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @CreatedBeginDate';

	IF (@CreateEndDate is NOT NULL)
	BEGIN
		SET @CreateEndDate = DateAdd(dd,1,@CreateEndDate)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @CreateEndDate';
	END

	IF (@ModifiedStartDate is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] >= @ModifiedBeginDate';

	IF (@ModifiedEndDate is NOT NULL)
	BEGIN
		SET @ModifiedEndDate = DateAdd(dd,1,@ModifiedEndDate)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] < @ModifiedEndDate';
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC';
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'CreateBEGINDate' = @CreateStartDate, 'CreateENDDate' = @CreateEndDate, 
			'ModifiedBeginDate' = @ModifiedStartDate, 'ModifiedEndDate' = @ModifiedEndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@CreateBeginDate datetime, @CreateEndDate datetime,@ModifiedBeginDate datetime, @ModifiedEndDate datetime'
		, @CreateBeginDate = @CreateStartDate
		, @CreateEndDate = @CreateEndDate
		, @ModifiedBeginDate = @ModifiedStartDate
		, @ModifiedEndDate = @ModifiedEndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		RETURN @ReturnError
	END CATCH;
END


GO
