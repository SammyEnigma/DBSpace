USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertHistoricFamily]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert Family names from existing database
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHistoricFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50),
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@Pets bit = 0,
	@inandout bit = NULL,
	@HistoricFID  smallint = NULL,
	@PrimaryPropertyID int,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DBNAME NVARCHAR(128), @ErrorLogID int;
	SET @DBNAME = DB_NAME();

	BEGIN TRY -- insert Family
		INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID,  Notes, Pets, inandout
		            , HistoricFamilyID, PrimaryPropertyID) 
		            Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Notes, @Pets, @inandout
					, @HistoricFID, @PrimaryPropertyID)
		SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values
	END TRY -- insert Family
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
