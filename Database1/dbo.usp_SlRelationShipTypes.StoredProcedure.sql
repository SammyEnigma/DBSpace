USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlRelationShipTypes]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150110
-- Description:	User defined stored procedure to
--              select all relationship types and IDs
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlRelationShipTypes]
	-- Add the parameters for the stored procedure her
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT [RT].[RelationshipTypeID], [RT].[RelationshipTypeName]
	from [RelationshipType] AS [RT]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [RT].[RelationshipTypeName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr;
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
