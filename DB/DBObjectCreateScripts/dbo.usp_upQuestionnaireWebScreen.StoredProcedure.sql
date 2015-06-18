USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upQuestionnaireWebScreen]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to update 
--              questionnaire data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_upQuestionnaireWebScreen]
	-- Add the parameters for the stored procedure here
		@QuestionnaireID int = NULL,
		@New_QuestionnaireDate date = NULL,
		@New_QuestionnaireDataSourceID int = NULL,
		@New_VisitRemodeledProperty bit = NULL,
		@New_PaintDate date = NULL,
		@New_RemodelPropertyDate date = NULL,
		@New_isExposedtoPeelingPaint bit = NULL,
		@New_isTakingVitamins bit = NULL,
		@New_NursingMother bit = NULL,
		@New_NursingInfant bit = NULL,
		@New_Pregnant bit = NULL,
		@New_isUsingPacifier bit = NULL,
		@New_isUsingBottle bit = NULL,
		@New_BitesNails bit = NULL,
		@New_NonFoodEating bit = NULL,
		@New_NonFoodinMouth bit = Null,
		@New_EatOutside bit = NULL,
		@New_Suckling bit = NULL,
		@New_Mouthing bit = NULL,
		@New_FrequentHandWashing bit = NULL,
		@New_VisitsOldHomes bit = NULL,
		@New_DaycareID int = NULL,
		@New_Notes varchar(3000) = NULL,
		@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int, @updateQuestionnaireReturnValue int;
	
		-- If no family ID was passed in exit
		IF (@QuestionnaireID IS NULL)
		BEGIN
			RAISERROR ('Questionnaire ID must be supplied', 11, -1);
			RETURN;
		END;

		BEGIN TRY  
			-- update questionnaire
			EXEC	@updateQuestionnaireReturnValue = [dbo].[usp_upQuestionnaire]
														@QuestionnaireID = @QuestionnaireID,
														@New_QuestionnaireDate = @New_QuestionnaireDate,
														@New_QuestionnaireDataSourceID = @New_QuestionnaireDataSourceID,
														@New_VisitRemodeledProperty = @New_VisitRemodeledProperty,
														@New_PaintDate = @New_PaintDate,
														@New_RemodelPropertyDate = @New_RemodelPropertyDate,
														@New_isExposedtoPeelingPaint = @New_isExposedtoPeelingPaint,
														@New_isTakingVitamins = @New_isTakingVitamins,
														@New_NursingMother = @New_NursingMother,
														@New_NursingInfant = @New_NursingInfant,
														@New_Pregnant = @New_Pregnant,
														@New_isUsingPacifier = @New_isUsingPacifier,
														@New_isUsingBottle = @New_isUsingBottle,
														@New_BitesNails = @New_BitesNails,
														@New_NonFoodEating = @New_NonFoodEating,
														@New_NonFoodinMouth = @New_NonFoodinMouth,
														@New_EatOutside = @New_EatOutside,
														@New_Suckling = @New_Suckling,
														@New_Mouthing = @New_Mouthing,
														@New_FrequentHandWashing = @New_FrequentHandWashing,
														@New_VisitsOldHomes = @New_VisitsOldHomes,
														@New_DaycareID = @New_DaycareID,
														@New_Notes = @New_Notes,
														@DEBUG = @DEBUG

		END TRY
		BEGIN CATCH -- insert person
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
		END CATCH; -- insert new person
	END
END



GO
