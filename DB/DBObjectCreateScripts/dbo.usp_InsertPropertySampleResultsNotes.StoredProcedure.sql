USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertPropertySampleResultsNotes]    Script Date: 4/16/2015 7:07:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150417
-- Description:	stored procedure to insert PropertySampleResults notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPropertySampleResultsNotes] 
	-- Add the parameters for the stored procedure here
	@PropertySampleResults_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PropertySample information
		INSERT INTO PropertySampleResultsNotes (PropertySampleResultsID, Notes) 
				values (@PropertySampleResults_ID, @Notes);
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
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO


