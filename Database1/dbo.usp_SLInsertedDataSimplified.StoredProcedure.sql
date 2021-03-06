USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedDataSimplified]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedDataSimplified] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int
			, @DEBUG BIT = 0;

    -- Insert statements for procedure here
	BEGIN TRY
	SELECT [P].[PersonID] 
		, 'P2FPersonID' = [P2F].[PersonID]
		, 'FamilyLastName' = [F].[Lastname]
		, [F].[FamilyID]
		, 'P2FFamilyID' = [P2F].[FamilyID]
		, [P].[LastName]
		, [P].[MiddleName]
		, [P].[FirstName]
		, [P].[BirthDate]
		, [P].[Gender]
		--, 'StreetAddress' = cast([Prop].[StreetNumber] as varchar)
		--	+ ' '+ cast([Prop].[Street] as varchar) + ' ' 
		--	+ cast([Prop].[StreetSuffix] as varchar)
		--, [Prop].[ApartmentNumber]
		--, [Prop].[City]
		--, [Prop].[State]
		--, [Prop].[Zipcode]
		--, 'PrimaryPhoneNumber' = [Ph].[PhoneNumber]
		--, [L].[LanguageName]
		, [F].[NumberofSmokers]
		, [F].[Pets]
		, [F].[Petsinandout]
		, [FN].[Notes]

	FROM [Person] AS [P]
	FULL OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
	FULL OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
	FULL OUTER JOIN [FamilyNotes] AS [FN] on [F].[FamilyID] = [FN].[FamilyID]
--	FULL OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
--	FULL OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
	-- where [P2F].FamilyID is NULL
	--  People to families: 3470

	
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
