USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlHobby]    Script Date: 6/20/2015 11:25:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150620
-- Description:	returns hobby name, id, description
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlHobby] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select HobbyID,HobbyName,HobbyDescription from Hobby order by HobbyName

END


GO
