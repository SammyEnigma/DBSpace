USE [LCCHPDev]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_DoesPropertyExist]    Script Date: 2/6/2016 1:04:39 PM ******/
if (exists (Select name from sys.objects where Name = 'udf_DoesPropertyExist' and Type = 'FN'))
	DROP FUNCTION [dbo].[udf_DoesPropertyExist]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_DoesPropertyExist]    Script Date: 2/6/2016 1:04:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150322
-- Description:	Function to check for duplicate property
-- =============================================
CREATE FUNCTION [dbo].[udf_DoesPropertyExist] 
(
	-- Add the parameters for the function here
	@AddressLine1 varchar(100),
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50),
	@State char(2),
	@ZipCode varchar(12)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PropertyID int

	
	IF (@AddressLine2 IS NULL)
		SELECT @PropertyID = PropertyID from Property where
			-- (dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AddressLine1 = @AddressLine1
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)
	ELSE
		SELECT @PropertyID = PropertyID from Property where
			--(dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AddressLine1 = @AddressLine1
			--AND (dbo.RemoveSpecialChars(AddressLine2) = dbo.RemoveSpecialChars(@AddressLine2))
			AND AddressLine2 = @AddressLine2
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)


	-- Return the result of the function
	RETURN @PropertyID

END


GO


