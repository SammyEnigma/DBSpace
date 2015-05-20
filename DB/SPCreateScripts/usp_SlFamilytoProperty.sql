-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
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
Alter PROCEDURE usp_SlFamilyNametoProperty
	-- Add the parameters for the stored procedure here
	@FamilyName varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@FamilyName IS NULL)
	BEGIN
		RAISERROR ('You must supply a family name.', 11, -1);
		RETURN;
	END;
    -- Insert statements for procedure here
	select FamilyName = F.LastName,Prop.StreetNumber,Prop.Street,Prop.StreetSuffix
	from family F
	join Property as Prop on F.PrimaryPropertyID = Prop.PropertyID
	where F.Lastname = @FamilyName
END
GO
