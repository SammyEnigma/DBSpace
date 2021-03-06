USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoFamily]    Script Date: 12/5/2015 5:39:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoFamily records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoFamily]   -- usp_InsertPersontoFamily
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@FamilyID int = NULL
	-- @OUTPUT int OUTPUT
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoFamily( PersonID, FamilyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @FamilyID ) -- , @StartDate, @EndDate);
		-- SELECT @OUTPUT = SCOPE_IDENTITY();
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
