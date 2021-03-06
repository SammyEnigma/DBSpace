USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upOccupation]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150327
-- Description:	Stored Procedure to update occupation records
-- =============================================
-- DROP PROCEDURE usp_upOccupation
CREATE PROCEDURE [dbo].[usp_upOccupation] 
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID tinyint = NULL,
	@Occupation_StartDate date = NULL,
	@Occupation_EndDate date = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ErrorMessage NVARCHAR(4000), @Update bit, @spupdateOccupationsqlStr NVARCHAR(4000);

	-- Assume there is nothing to update
	SET @Update = 0;

	-- insert statements for procedure here
	BEGIN TRY
		IF (@PersonID IS NULL OR @OccupationID IS NULL)
		BEGIN
			RAISERROR('Occupation and Person must be specified',11,50000);
			RETURN;
		END

		IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where PersonID = @PersonID AND OccupationID = @OccupationID))
		BEGIN
			SELECT @ErrorMessage = 'Secified person: ' + cast(@PersonID as varchar) + ' is not associated with occupation: ' 
				+ cast(@OccupationID as varchar) +'. Try creating the assocation with usp_InsertPersontoOccupation';
			RAISERROR(@ErrorMessage,8,50000);
			RETURN;
		END
		
		-- BUILD update statement
		SELECT @spupdateOccupationsqlStr = N'update PersontoOccupation Set PersonID = @PersonID'
		
		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', StartDate = @StartDate'
		END

		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', ENDDate = @ENDDate'
		END

		IF (@Update = 1)
		BEGIN
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ' WHERE PersonID = @PersonID and OccupationID = @OccupationID'

			IF (@DEBUG = 1)
				SELECT @spupdateOccupationsqlStr, 'StartDate' = @Occupation_StartDate, 'EndDate' = @Occupation_EndDate,
					'PersonID' = @PersonID, 'OccupationID' = @OccupationID

			EXEC [sp_executesql] @spupdateOccupationsqlStr
					, N'@OccupationID tinyint, @PersonID int, @StartDate date, @EndDate date'
					, @OccupationID = @OccupationID
					, @PersonID = @PersonID
					, @StartDate = @Occupation_StartDate
					, @EndDate = @Occupation_EndDate
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
