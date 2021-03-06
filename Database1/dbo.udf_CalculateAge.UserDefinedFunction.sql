USE [LCCHPDev]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_CalculateAge]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_CalculateAge]
 (
   @BirthDate datetime = NULL,
   @CurrentDate datetime = NULL
 )
 RETURNS int

 AS

 BEGIN

 IF @BirthDate IS NULL
	RETURN -1;

 IF @CurrentDate IS NULL
	SET @CurrentDate = GetDate();

 IF @BirthDate > @CurrentDate
   RETURN 0

 DECLARE @Age int
 SELECT @Age = DATEDIFF(YY, @BirthDate, @CurrentDate) - 
	CASE WHEN(
		(MONTH(@BirthDate)*100 + DAY(@BirthDate)) >
		(MONTH(@CurrentDate)*100 + DAY(@CurrentDate))
	) THEN 1 ELSE 0 END
 RETURN @Age

 END



GO
