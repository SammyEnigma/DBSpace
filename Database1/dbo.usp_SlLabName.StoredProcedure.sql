USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlLabName]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150304
-- Description:	Lists lab names
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlLabName] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select LabName from Lab where LabName in ('LeadCare II','Tamarac','Quest Diagnostic','Other')

END

GO
