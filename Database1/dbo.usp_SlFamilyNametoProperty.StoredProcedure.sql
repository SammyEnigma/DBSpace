USE [LCCHPDev]
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyNametoProperty]    Script Date: 12/5/2015 5:39:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF( EXISTS( SELECT Name from sys.objects where Name = 'usp_SlFamilyNametoProperty' and TYPE = 'P'))
	DROP PROCEDURE usp_SlFamilyNametoProperty
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141123
-- Description:	User defined stored procedure to
--              select family and property address
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyNametoProperty]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT  [FamilyProperty] =  [F].[LastName] + '' - '' + isnull([Prop].[AddressLine1],'''') + isnull([Prop].[AddressLine2],'''') + '' - ('' + isnull(cast(FamilyID as varchar),''-'') + '')'' 
	,FamilyID, [FamilyName] = [F].[LastName],[Prop].[AddressLine1],[Prop].[AddressLine2],[Prop].[ZipCode]
	from [family] AS [F]
	LEFT OUTER JOIN [Property] as [Prop] on [F].[PrimaryPropertyID] = [Prop].[PropertyID]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	IF (@FamilyID IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [F].[FamilyID] = @Family_ID'
	ELSE
	    SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@Family_ID int'
		, @Family_ID = @FamilyID;
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
