USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResults2]    Script Date: 6/19/2015 9:54:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
ALTER PROCEDURE [dbo].[usp_SLAllBloodTestResults2] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(4,1) = NULL,
	@Max_Lead_Value numeric(4,1) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 


    -- Insert statements for procedure here
	SET FMTONLY OFF
	SELECT @spexecutesqlStr = N'SELECT ''ClientID'' = [P].[personid], ''LastName'' = [P].[LastName], ''BirthDate'' = [P].[BirthDate]
								, [BTR].[SampleDate], ''Pb_ug_Per_dl'' = [BTR].[LeadValue], ''Hb g/dl'' = [BTR].[HemoglobinValue], ''Retest Date'' = [P].[RetestDate]
								, ''Close'' = [P].[isClosed], ''Moved'' = [P].[Moved], ''Movedate'' = [P].[MovedDate]
							from [Person] [P]
							join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
							WHERE 1 = 1'

	IF @Person_ID IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID'
		SET @OrderBy = ' ORDER BY [BTR].[LeadValue],[BTR].[SampleDate] desc'
	END

	IF @Min_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] >= @MinLeadValue'
	END

	IF @Max_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] < @MaxLeadValue'
	END

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr;
		SET @OrderBy = N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END


	SELECT @spexecutesqlStr = @spexecutesqlStr + @OrderBy

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value IS NULL) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PersonID' = @Person_ID, 'MinLeadValue' = @Min_Lead_Value, 'MaxLeadValue' = @Max_Lead_Value, 'Recompile' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value, @MaxLeadValue = @Max_Lead_Value;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END