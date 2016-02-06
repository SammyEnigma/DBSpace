USE [LCCHPDev]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_SlFamilyPhoneNumber]    Script Date: 4/5/2015 7:53:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	select specific phone number of 
--				specified type for specific family
-- =============================================
CREATE FUNCTION [dbo].[udf_SlFamilyPhoneNumber] 
(
	-- Add the parameters for the function here
	@Family_ID int,
	@PhoneNumberTypeID tinyint
)
RETURNS bigint
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PhoneNumber bigint--, @PhoneNumberTypeID tinyint; --, @Family_ID int, @PhoneNumberTypeID tinyint;
	--SET @PhoneNumberTypeID = 1
	-- Add the T-SQL statements to compute the return value here
--	SELECT @PhoneNumber = @Family_ID

	Select @PhoneNumber = [P].[PHoneNumber] from [PhoneNumber] AS [P]
	JOIN [FamilytoPhoneNumber] AS [P2N] ON [P].[PhoneNumberID] = [P2N].[PhoneNumberID]
	JOIN [Family] AS [F] ON [P2N].[FamilyID] = [F].[FamilyID]
	WHERE [F].[FamilyID] = @Family_ID and [P].[PhoneNumberTypeID] = @PhoneNumberTypeID

	-- Select @PhoneNumber
	-- Return the result of the function
	RETURN @PhoneNumber

END

GO

