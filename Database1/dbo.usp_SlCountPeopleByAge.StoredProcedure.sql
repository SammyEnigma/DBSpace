USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAge]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141222
-- Description:	returns count of people grouped by 
--              age. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAge]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='select Age, ''Personcount'' = count(PersonID)
		from [person]
		where isClient = 1'
	
	-- Return all families and associated properties if nothing was passed in
	--IF (@Last_Name IS NOT NULL)
	--	SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [LastName] = @LastName'
	--ELSE
	--    SET @Recompile = 0

	-- group people by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' group by [dbo].udf_CalculateAge(BirthDate,GetDate())'

	-- order by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' order by Age'

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';
	
	EXEC [sp_executesql] @spexecutesqlStr
 --   , N'@LastName varchar(50)'
	--, @LastName = @Last_Name;
END
GO
