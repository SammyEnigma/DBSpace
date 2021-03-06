USE [LCCHPDev]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DateInThePast]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150220
-- Description:	function to ensure date is less than current date
-- =============================================
CREATE FUNCTION [dbo].[udf_DateInThePast] 
(
	-- Add the parameters for the function here
	@CheckDate date
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result bit

	-- Add the T-SQL statements to compute the return value here
	IF (@CheckDate < GetDate())
		SET @Result = 1;
	ELSE 
		SET @Result = 0;

	-- Return the result of the function
	RETURN @Result

END

GO
