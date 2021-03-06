USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByLastName]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByLastName]
		@Last_Name VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @spExecutesqlStr NVARCHAR(4000), @Recompile BIT = 1;

	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT [lastname],''Members'' = count([firstname]) from [person] WHERE 1=1';

		if (@Last_Name is not NULL)
		BEGIN
			SET @Recompile = 1;
			SELECT @spExecutesqlStr = @spExecutesqlStr + ' AND [person].[LastName] = @LastName'
		END
		ELSE
			SET @Recompile = 0

		-- Group by last name for counting purposes
		SELECT @spExecutesqlStr = @spExecutesqlStr + ' group by [lastname]'

		-- force recompile for selective query
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spExecutesqlStr 
			, N'@LastName VARCHAR(50)'
			, @LastName = @Last_Name;

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
