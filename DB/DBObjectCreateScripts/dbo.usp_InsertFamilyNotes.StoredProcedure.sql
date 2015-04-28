USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilyNotes]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150214
-- Description:	stored procedure to insert family notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertFamilyNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Family information
		INSERT INTO FamilyNotes (FamilyID, Notes) 
				values (@Family_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
