USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditFamilyWebScreenInformation]    Script Date: 7/16/2015 12:29:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns Family Lastname, Primary Address,
--				Primary phonenumber, Secondary phonenumber,
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
	DECLARE @PrimaryPhoneNumber bigint, @SecondaryPhoneNumber bigint,
			@spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@Family_ID IS NULL)
	BEGIN
		RAISERROR ('You must supply the Family.', 11, -1);
		RETURN;
	END;
	
	-- Select Primary Phone number
	select  @PrimaryPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 1)

	-- Select Secondary Phone number
	select  @SecondaryPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 2)
	
	SELECT @spexecuteSQLStr =
		N'SELECT [F].[FamilyID],[F].[Lastname],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode],YearBuilt = cast([P].[YearBuilt] as date)
			,MoveinDate = cast(StartDate as date), MoveoutDate = cast(EndDate as date)
			, [OwnerOccupied] = cast([P].[isOwnerOccuppied] as varchar)
			, PrimaryPhoneNumber = @PrimaryPhoneNumber, SecondaryPhoneNumber = @SecondaryPhoneNumber
			,[F].[NumberofSmokers],[F].[Pets],Petsinandout = cast([F].[Petsinandout] as varchar)
			, [P].[OwnerContactInformation]
		FROM [Family] AS [F]
		JOIN [Property] AS [P] ON [F].[PrimaryPropertyID] = [P].[PropertyID]
		JOIN [FamilytoProperty] AS [F2P] ON [F].[FamilyID] = [F2P].[FamilyID] AND [F].[PrimaryPropertyID] = [F2P].[PropertyID]
		WHERE 1 = 1'

	IF (@Family_ID IS NULL)
		SET @Recompile = 0;

	IF (@Family_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and [F].[FamilyID] = @FamilyID ORDER by [F].[FamilyID] desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @Family_ID, 'PrimaryPhoneNumber' = @PrimaryPhoneNumber, 'SecondaryPhoneNumber' = @SecondaryPhoneNumber;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@FamilyID int, @PrimaryPhoneNumber bigint, @SecondaryPhoneNumber bigint'
			, @FamilyID = @Family_ID
			, @PrimaryPhoneNumber = @PrimaryPhoneNumber
			, @SecondaryPhoneNumber = @SecondaryPhoneNumber;
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
