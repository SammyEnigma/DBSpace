USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEthnicity]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Ethnicity records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEthnicity]   -- usp_InsertEthnicity 
	-- Add the parameters for the stored procedure here
	@Ethnicity varchar(50) = NULL,
	@NewEthnicityID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Ethnicity ( Ethnicity )
					 Values ( @Ethnicity );
		SELECT @NewEthnicityID = SCOPE_IDENTITY();
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
