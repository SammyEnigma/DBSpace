USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upClientFlag]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure to update the isClient
--              flag to 1 if the person has completed
--              a bloodtest or a questionnaire.
-- =============================================
CREATE PROCEDURE [dbo].[usp_upClientFlag] 
	-- Add the parameters for the stored procedure here
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		-- Set isClient true if person has a bloodtest or questionnaire
		update Person Set isClient = 1 where isClient = 0 AND PersonID IN
		( Select PersonID from BloodTestResults
			UNION
		  Select PersonID from Questionnaire
		)

		-- Set isClient false if person does not have a bloodtest or a questionnaire
		update Person Set isClient = 0 where isClient = 1 AND PersonID NOT IN
		( Select PersonID from BloodTestResults
			UNION
		  Select PersonID from Questionnaire
		) 
		
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
