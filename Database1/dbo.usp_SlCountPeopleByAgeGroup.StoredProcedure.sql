USE [LCCHPDev]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAgeGroup]    Script Date: 5/14/2015 9:48:51 PM ******/
DROP PROCEDURE [dbo].[usp_SlCountPeopleByAgeGroup]
GO

/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAgeGroup]    Script Date: 5/14/2015 9:48:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150112
-- Description:	returns count of people grouped by 
--              age categories. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAgeGroup]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;


	; with AgeGroups as 
	(  SELECT CASE
		  WHEN Age < 1 THEN '0'
		  WHEN Age >= 1 and Age < 4 THEN '01 - 03'
		  WHEN Age >= 4 AND Age < 7 THEN '04 - 06'
		  WHEN Age >= 7 AND Age < 18 THEN '07 - 17'
		  ELSE '18 and Over' 
	  END  AS Groups
	  -- , MaxAge = max(Person.Age)
	  FROM Person
	  where isClient = 1
	)

	SELECT ROW_NUMBER() OVER(ORDER BY Groups DESC) AS Row, AgeGroups = Coalesce(Groups,'Total'), 
								Clients =  Count(Groups) From AgeGroups group by Groups-- with ROLLUP

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT AgeGroups = Coalesce(Groups,''Total''), 
								Clients =  Count(Groups) From AgeGroups group by Groups with ROLLUP'
END
GO

