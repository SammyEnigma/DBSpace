USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyNametoProperty]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141123
-- Description:	User defined stored procedure to
--              select family and property address
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyNametoProperty]
	-- Add the parameters for the stored procedure here
	@Family_Name varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT ''FamilyName'' = [F].[LastName],[Prop].[StreetNumber],[Prop].[Street],[Prop].[StreetSuffix],[Prop].[ZipCode]
	from [family] AS [F]
	join [Property] as [Prop] on [F].[PrimaryPropertyID] = [Prop].[PropertyID]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	IF (@Family_Name IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [F].[LastName] = @FamilyName'
	ELSE
	    SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@FamilyName varchar(50)'
		, @FamilyName = @Family_Name;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
