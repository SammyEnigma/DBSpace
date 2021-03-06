USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeople]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 2/13/2014
-- Description:	procedure returns the number of entries in the persons table, being the number of participants
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeople] 
	-- Add the parameters for the stored procedure here
	@Max_Age int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @MaxAge int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT People = count([PersonId]) from [person] WHERE 1=1'

		IF (@Max_Age IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [Age] <= @MaxAge';
		
		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate >= @StartDate';
	
		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate < @EndDate';

		IF @Recompile = 1
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@MaxAge VARCHAR(50),@StartDate date, @EndDate date'
		, @MaxAge = @Max_Age
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
