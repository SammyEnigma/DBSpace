USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicateProperties]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicateProperties]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P1PropertyID] = [P1].[PropertyID]
				, [P2PropertyID] = [P2].[PropertyID]
				, [P1StreetNumber] = [P1].[StreetNumber]
				, [P2StreetNumber] = [P2].[StreetNumber]
				, [P1Street] = [P1].[Street]
				, [P2Street] = [P2].[Street]
				, [P1StreetSuffix] = [P1].[StreetSuffix]
				, [P2StreetSuffix] = [P2].[StreetSuffix]
				, [P1City] = [P1].[City]
				, [P2City] = [P2].[City]
				, [P1State] = [P1].[State]
				, [P2State] = [P2].[State]
				, [P1ZipCode] = [P1].[Zipcode]
				, [P2ZipCode] = [P2].[Zipcode]
				, [P1County] = [P1].[County]
				, [P2County] = [P2].[County]
				, [P1CreatedDate] = [P1].[CreatedDate]
				, [P2CreatedDate] = [P2].[CreatedDate]
				, [P1ModifiedDate] = [P1].[ModifiedDate]
				, [P2ModifiedDate] = [P2].[ModifiedDate]
			from [Property] AS [P1]
			JOIN [Property] AS [P2] on 
				[P1].[Street] = [P2].[Street]
				AND [P1].[StreetNumber] = [P2].[StreetNumber]
				AND [P1].[City] = [P2].[City]
				AND [P1].[County] = [P2].[County]
				AND [P1].[Zipcode] = [P2].[Zipcode]
				AND [P1].[State] = [P2].[State]
				AND [P1].[PropertyID] != [P2].[PropertyID]
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
