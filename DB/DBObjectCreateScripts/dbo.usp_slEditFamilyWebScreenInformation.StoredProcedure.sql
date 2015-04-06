USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlEditFamilyWebScreenInformation]    Script Date: 4/5/2015 8:30:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns Family Lastname, Primary Address,
--				Home phonenumber, work phonenumber,
--				number of smokers, number of pets,
--				if pets are in and out pets,
--				if pets are washed frequently
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditFamilyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Family_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @HomePhoneNumber bigint, @WorkPhoneNumber bigint,
			@spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@Family_ID IS NULL)
	BEGIN
		RAISERROR ('You must supply the Family.', 11, -1);
		RETURN;
	END;
	
	-- Select Home Phone number
	select  @HomePhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 1)

	-- Select Work Phone number
	select  @WorkPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 2)
	
	SELECT @spexecuteSQLStr =
		N'SELECT [F].[FamilyID],[F].[Lastname],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode]
			, HomePhoneNumber = @HomePhoneNumber, WorkPhoneNumber = @WorkPhoneNumber
			,[F].[NumberofSmokers],[F].[Pets],[F].[Petsinandout]
		FROM [Family] AS [F]
		JOIN [Property] AS [P] ON [F].[PrimaryPropertyID] = [P].[PropertyID]
		WHERE 1 = 1'

	IF (@Family_ID IS NULL)
		SET @Recompile = 0;

	IF (@Family_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and FamilyID = @FamilyID ORDER by FamilyID desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @Family_ID, 'HomePhoneNumber' = @HomePhoneNumber, 'WorkPhoneNumber' = @WorkPhoneNumber;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@FamilyID int, @HomePhoneNumber bigint, @WorkPhoneNumber bigint'
			, @FamilyID = @Family_ID
			, @HomePhoneNumber = @HomePhoneNumber
			, @WorkPhoneNumber = @WorkPhoneNumber;
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

