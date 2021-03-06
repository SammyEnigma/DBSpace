USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLab]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Lab records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLab]   -- usp_InsertLab 
	-- Add the parameters for the stored procedure here
	@LabName varchar(50) = NULL,
	@LabDescription varchar(250) = NULL,
	@New_Lab_Notes varchar(3000) = NULL,
	@NewLabID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Lab ( LabName, LabDescription )
					 Values ( @LabName, @LabDescription );
		SELECT @NewLabID = SCOPE_IDENTITY();

		IF (@New_Lab_Notes IS NOT NULL)
		EXEC	[dbo].[usp_InsertLabNotes]
							@Lab_ID = @NewLabID,
							@Notes = @New_Lab_Notes,
							@InsertedNotesID = @NotesID OUTPUT
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
