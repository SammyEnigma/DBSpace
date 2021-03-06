USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumberType]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20141220
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumberType]   -- usp_InsertPhoneNumberType
	-- Add the parameters for the stored procedure here
	@PhoneNumberTypeName VarChar(50) = NULL,
	@PhoneNumberTypeID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PhoneNumberType ( PhoneNumberTypeName )
					 Values ( @PhoneNumberTypeName );
		SELECT @PhoneNumberTypeID_OUTPUT = SCOPE_IDENTITY();
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
