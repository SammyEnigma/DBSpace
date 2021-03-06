USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicatePeople]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate people
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicatePeople]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT P1PersonID = P1.PersonID
				, P2PersonID = P2.PersonID	
				, P1LastName = P1.LastName
				, P2LastName = P2.LastName 
				, P1FirstName = P1.FirstName
				, P2FirstName = P2.FirstName 
				, P1BirthDate = P1.BirthDate
				, P2BirthDate = P2.BirthDate
				, P1Gender = P1.Gender
				, P2Gender = P2.Gender
				, P1CreatedDate = P1.CreatedDate
				, P2CreatedDate = P2.CreatedDate
				, P1ModifiedDate = P1.ModifiedDate
				, P2ModifiedDate = P2.ModifiedDate
			from person AS P1
			JOIN person AS P2 on 
				P1.LastName = P2.LastName
				AND P1.FirstName = P2.FirstName
				AND P1.Age = P2.Age
				AND P1.PersonID != P2.PersonID 
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
