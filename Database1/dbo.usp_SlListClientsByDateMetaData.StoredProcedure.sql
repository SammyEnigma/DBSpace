USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListClientsByDateMetaData]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select People by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListClientsByDateMetaData]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;
BEGIN TRY
SELECT [P].[PersonID],[P].[HistoricChildId],[FamilyName] = [F].[LastName],[P].[LastName],[P].[MiddleName],[P].[FirstName],[P].[BirthDate]
			,[P].[Gender],[P].[Age]
			,[Prop].[AddressLine1],[Prop].[AddressLine2],[P2F].[StartDate],[P2F].[EndDate]
			,[P].[ModifiedDate],[P].[CreatedDate]
			from [Person] AS [P]
			LEFT OUTER JOIN [PersontoFamily] AS [P2F] ON [P].[PersonID] = [P2F].[PersonID]
			LEFT OUTER JOIN [Family] AS [F] ON [P2F].[FamilyID] = [F].[FamilyID]
			LEFT OUTER JOIN [Property] AS [PROP] ON [F].[PrimaryPropertyID] = [Prop].[PropertyID]
			where 1 = 1;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		RETURN @ReturnError
	END CATCH;
END


GO
