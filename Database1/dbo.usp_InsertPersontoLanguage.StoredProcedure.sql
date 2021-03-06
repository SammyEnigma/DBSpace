USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoLanguage]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoLanguage records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoLanguage]   -- usp_InsertPersontoLanguage
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@LanguageID smallint = NULL,
	@isPrimaryLanguage bit = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL,
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		IF EXISTS (SELECT PersonID from PersontoLanguage where PersonID = @PersonID and LanguageID = @LanguageID)
		BEGIN
			-- make sure there are no other primary languages
			IF (@isPrimaryLanguage = 1)
				update PersontoLanguage set isPrimaryLanguage = 0 WHERE PersonID = @PersonID AND LanguageID != @LanguageID AND isPrimaryLanguage = 1
			update PersontoLanguage set isPrimaryLanguage = @isPrimaryLanguage WHERE PersonID = @PersonID AND LanguageID = @LanguageID
		END
		ELSE
			INSERT into PersontoLanguage( PersonID, LanguageID, isPrimaryLanguage ) -- StartDate, EndDate, GroupID)
					 Values ( @PersonID, @LanguageID, @isPrimaryLanguage ) -- @StartDate, @EndDate, @GroupID);
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
