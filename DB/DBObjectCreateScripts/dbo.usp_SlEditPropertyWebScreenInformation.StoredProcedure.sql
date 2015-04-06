USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlEditPropertyWebScreenInformation]    Script Date: 4/5/2015 8:30:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns AddressLine1, Addressline2
--				City, State, and Zipcode
--				of a specific property
--				if no property ID is passed in, 
--				informatin is returned for all properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditPropertyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Property_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P].[PropertyID],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode]
			FROM [Property] AS [P]
			WHERE 1 = 1'

	IF (@Property_ID IS NULL)
		SET @Recompile = 0;

	IF (@Property_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and PropertyID = @PropertyID ORDER by PropertyID desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PropertyID' = @Property_ID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PropertyID int'
			, @PropertyID = @Property_ID;
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

