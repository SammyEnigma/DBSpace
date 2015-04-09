USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlPersonNotes]    Script Date: 4/8/2015 11:08:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150408
-- Description:	stored procedure to select 
--              person edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditClientInfoWebScreenInformation]
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
		N'select [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[MiddleName]
		,[P].[Birthdate],[P].[Gender]
		,[L].[LanguageName]
		,[E].[Ethnicity]
		,[P].[Moved]
		,[MovedOutofCounty] = [P].[OutofSite]
		from [Person] AS [P]
		LEFT OUTER JOIN [PersontoLanguage] AS [PL] on [P].[PersonID] = [PL].[PersonID]
		LEFT OUTER JOIN [Language] AS [L] ON [PL].[LanguageID] = [L].[LanguageID]
		LEFT OUTER JOIN [PersontoEthnicity] AS [PE] ON [PE].[PersonID] = [P].[PersonID]
		LEFT OUTER JOIN [Ethnicity] AS [E] ON [PE].[EthnicityID] = [E].[EthnicityID]
		where [P].[PersonID] = @PersonID';

	
	IF EXISTS ( SELECT PersonID from PersontoLanguage where PersonID = @PersonID ) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [PL].[isPrimaryLanguage] = 1';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [L].[CreatedDate] desc';
	
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


