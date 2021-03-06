USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_delPersonfromFamily]    Script Date: 12/5/2015 5:39:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20151205
-- Description:	Stored Procedure to remove an existing
--				PersontoFamily association
-- =============================================

CREATE PROCEDURE [dbo].[usp_delPersonfromFamily]   -- usp_delPersonfromFamily
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@FamilyID int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;

    -- Insert statements for procedure here
	BEGIN TRY		
		IF (@PersonID is null)
			RAISERROR ('PersonID needs to be specified.', -- Message text.
               16, -- Severity.
               1 -- State.
               );
		ELSE IF (@FamilyID is null)
			RAISERROR ('FamilyID need to be specified.', -- Message text.
               16, -- Severity.
               1 -- State.
               );			
		ELSE
			select 'Deleting records with: ', @PersonID, @FamilyID --	 
			Delete From PersontoFamily where PersonID = @PersonID and FamilyID = @FamilyID
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
