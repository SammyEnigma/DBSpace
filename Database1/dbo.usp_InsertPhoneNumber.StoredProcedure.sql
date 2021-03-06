USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumber]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumber]   -- usp_InsertPhoneNumber 
	-- Add the parameters for the stored procedure here
	@CountryCode tinyint = 1,
	@PhoneNumber bigint = NULL,
	@PhoneNumberTypeID tinyint = NULL,
	@DEBUG bit = NULL,
	@PhoneNumberID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if the phone number already exists
		SELECT @PhoneNumberID_OUTPUT = PhoneNumberID from PHoneNumber where PhoneNumber = @PhoneNumber

		-- If the phone number doesn't exist, insert it and get the new id
		IF (@PhoneNumberID_OUTPUT IS NULL)
		BEGIN
			IF (@DEBUG = 1)
				SELECT 'INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );', @CountryCode, @PhoneNumber, @PhoneNumberTypeID

			INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );
			SELECT @PhoneNumberID_OUTPUT = SCOPE_IDENTITY();
		END
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
