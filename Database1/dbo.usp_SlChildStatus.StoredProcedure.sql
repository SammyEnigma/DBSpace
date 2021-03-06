USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlChildStatus]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlChildStatus] 
	-- Add the parameters for the stored procedure here
	@TargetType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(3000)

	select @spexecutesqlStr =''


    -- Insert statements for procedure here
	SELECT [TS].[StatusName],[TS].[StatusID] from [TargetStatus] AS [TS]
	where 1 = 1 AND TargetType = 'Person'

END

GO
