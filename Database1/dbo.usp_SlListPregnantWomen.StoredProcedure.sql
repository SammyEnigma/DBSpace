USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListNursingMothers]    Script Date: 4/27/2015 11:37:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150315
-- Description:	stored procedure to list nursing
--				mothers. 
--				If @Count is set to 1, returns the
--				number of nusring mothers
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListNursingMothersbyCreateDateRange]
	-- Add the parameters for the stored procedure here
	  @PersonID int = NULL
	, @Count BIT = 0 -- If 1 return county only, if 0 return full list
	, @DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		SELECT @spexecuteSQLStr =
			N'SELECT [PersonID],[QuestionnaireID],[LastName],[FirstName],[Age],[isNursing],[QuestionnaireDate] 
			from vNursingMothers where 1=1';

		IF (@PersonID IS NOT NULL) 
			SELECT @spexecuteSQLStr = @spexecuteSQLStr
				+ N' AND [PersonID] = @PersonID';

		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' order by [PersonID], [lastname]';

		-- select how many nursing mothers there are
		IF (@Count = 1)
		BEGIN
			SELECT @spexecuteSQLStr = N'SELECT count([PersonID]) from vNursingMothers';
			SET @Recompile = 0;
		END

		IF (@PersonID IS NULL) 
			SET @Recompile = 0;
	
		-- Recompile the stored procedure if the query return list is sufficiently small
		IF @Recompile = 1
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

		-- If debugging, output the query string
		IF @DEBUG = 1
			SELECT @spexecuteSQLStr, @PersonID

		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Person_ID int'
			, @Person_ID = @PersonID;
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

