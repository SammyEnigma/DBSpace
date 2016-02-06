USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlListFamilyMembers]    Script Date: 7/16/2015 12:56:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150715
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlClientFollowUp]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [P].[PersonID],[P].[LastName],[P].[Firstname],[P].[RetestDate]  from [person] as [p]
		 where 1=1';

	IF (@StartDate IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[RetestDate] >= @StartDate';

	IF (@EndDate IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[RetestDate] < @EndDate';
	SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' order by [P].[RetestDate] ASC'

	IF (DateDiff(yy,@EndDate,@StartDate) > 4) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@StartDate date, @EndDate date'
			, @StartDate = @StartDate
			, @EndDate = @EndDate;
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


