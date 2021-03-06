USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLanguage]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new Languages
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLanguage]   -- usp_InsertLanguage "Italian"
	-- Add the parameters for the stored procedure here
	@LanguageName varchar(50),
	@LANGUAGEID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DBNAME NVARCHAR(128), @ErrorLogID int;
	SET @DBNAME = DB_NAME();

	BEGIN TRY
	     if Exists (select LanguageName from language where LanguageName = @LanguageName) 
		 BEGIN
		 RAISERROR
			(N'The language: %s already exists.',
			11, -- Severity.
			1, -- State.
			@LanguageName);
		 END
	
		INSERT into Language (LanguageName) Values (upper(@LanguageName))
		SET @LANGUAGEID = SCOPE_IDENTITY();
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
