USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoPhoneNumber]    Script Date: 6/19/2015 9:47:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20150404
-- Description:	Stored Procedure to insert new 
--				FamilytoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoPhoneNumber]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistingNumberPriority tinyint, @FamilytoPhoneNumberExists bit = 0
		, @FamilyPhonePriorityExists int = 0, @SwapPriority tinyint;
    -- Insert statements for procedure here
	BEGIN TRY
				-- see if family already has that number
		SELECT @FamilytoPhoneNumberExists = 1, @SwapPriority = NumberPriority from FamilytoPhoneNumber where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID
		-- see if the family already has a number with same priority get the PHoneNumberID
		SELECT @FamilyPhonePriorityExists = PhoneNumberID from FamilytoPhoneNumber where FamilyID = @FamilyID and NumberPriority = @NumberPriority

		-- If the family is already associated with the phone number
		IF (@FamilytoPhoneNumberExists = 1)
		BEGIN
			-- if the priority is the same do nothing
			IF (@SwapPriority = @NumberPriority)
				RETURN;
			ELSE IF (@FamilyPhonePriorityExists = 0)  -- there are no numbers for that family with that priority, set the New number priority for the specified number
				update FamilytoPhoneNumber set NumberPriority = @NumberPriority where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID

			ELSE -- there is another number for that family with the desired priority, swap priorities
			BEGIN
				-- Set the New number priority for the specified number
				update FamilytoPhoneNumber set NumberPriority = @NumberPriority where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID 

				-- Set number priority for number that had the existing @NumberPriority to the previous priority from the passed in phone number 
				update FamilytoPhoneNumber set NumberPriority = @SwapPriority where FamilyID = @FamilyID and PhoneNumberID = @FamilyPhonePriorityExists 			
			END
		END
		ELSE -- the family is not associated with that phone number
		BEGIN
			-- there are no numbers for that family with that priority
			IF (@FamilyPhonePriorityExists = 0)
			BEGIN
				INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
				 Values ( @FamilyID, @PhoneNumberID, @NumberPriority )
			END
			ELSE
			BEGIN
				-- Insert the New number and priority
				INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
				 Values ( @FamilyID, @PhoneNumberID, @NumberPriority ) 

				-- determine next priority
				select @SwapPriority = max(NumberPriority)+1 from FamilytoPhoneNumber where FamilyID = @FamilyID
				-- Set number priority for number that had the existing @NumberPriority to the lowest priority
				update FamilytoPhoneNumber set NumberPriority = @SwapPriority where FamilyID = @FamilyID and PhoneNumberID = @FamilyPhonePriorityExists 
			END
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
		THROW
		-- RETURN ERROR_NUMBER()
	END CATCH;
END



GO

