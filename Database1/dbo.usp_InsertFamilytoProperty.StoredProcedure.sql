USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoProperty]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 201504817
-- Description:	Stored Procedure to insert new FamilytoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoProperty]   -- usp_InsertFamilytoProperty
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PropertyID int = NULL,
	@PropertyLinkTypeID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@DEBUG bit = NULL,
	@NewFamilytoPropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @FamilytoPropertyID int, @update_return_value int;
    -- Insert statements for procedure here
	BEGIN TRY
		select @FamilytoPropertyID = FamilytoPropertyID from FamilytoProperty where FamilyId = @FamilyID and PropertyID = @PropertyID

		IF @FamilytoPropertyID IS NOT NULL
		BEGIN
			EXEC @update_return_value = usp_upFamilytoProperty
				@FamilytoPropertyID = @FamilytoPropertyID,
				@PropertyLinkTypeID = @PropertyLinkTypeID,
				@StartDate = @StartDate,
				@EndDate = @EndDate,
				@isPrimaryResidence = @isPrimaryResidence,
				@DEBUG = @DEBUG
		END
		ELSE
			 INSERT into FamilytoProperty( FamilyID, PropertyID, PropertyLinkTypeID, StartDate, EndDate, isPrimaryResidence)
						 Values ( @FamilyID, @PropertyID, @PropertyLinkTypeID, @StartDate, @EndDate, @isPrimaryResidence )
		--SELECT @NewFamilytoPropertyID = SCOPE_IDENTITY();
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
