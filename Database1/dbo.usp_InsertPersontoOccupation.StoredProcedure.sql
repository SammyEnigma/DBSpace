USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoOccupation]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoOccupation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoOccupation]   -- usp_InsertPersontoOccupation
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID smallint = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @return_value int, @ErrorLogID int;

	-- at the very least assume the start date is today
	IF (@StartDate is NULL) SELECT @StartDate = GETDATE();

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoOccupation( PersonID, OccupationID, StartDate, EndDate)
					 Values ( @PersonID, @OccupationID, @StartDate, @EndDate);
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
