USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlTargetSampleType]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150102
-- Description:	retrieve sample types for people (lead levels)
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlTargetSampleType] 
	-- Add the parameters for the stored procedure here
	@Sample_Target varchar(50) = NULL, 
	@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr nvarchar(4000), @RECOMPILE bit =1;
    -- Insert statements for procedure here

	SELECT @spexecutesqlStr = 'SELECT [SampleTypeID],[SampleTypeName] from [SampleType] where 1=1'
	
	if (@Sample_Target IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [SampleType].[SampleTarget] = @SampleTarget'

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' OPTION(RECOMPILE)';

	EXEC [sp_executesql] @spexecutesqlStr
		, N'@SampleTarget varchar(50)', @SampleTarget = @Sample_Target
END
GO
