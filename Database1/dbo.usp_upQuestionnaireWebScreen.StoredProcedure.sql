USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upQuestionnaireWebScreen]    Script Date: 6/21/2015 12:54:24 AM ******/
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
		@QuestionnaireDate date = NULL,
		@QuestionnaireDataSourceID int = NULL,
		@VisitRemodeledProperty bit = NULL,
		@PaintDate date = NULL,
		@RemodelPropertyDate date = NULL,
		@isExposedtoPeelingPaint bit = NULL,
		@isTakingVitamins bit = NULL,
		@NursingMother bit = NULL,
		@NursingInfant bit = NULL,
		@Pregnant bit = NULL,
		@isUsingPacifier bit = NULL,
		@isUsingBottle bit = NULL,
		@BitesNails bit = NULL,
		@NonFoodEating bit = NULL,
		@NonFoodinMouth bit = Null,
		@EatOutside bit = NULL,
		@Suckling bit = NULL,
		@Mouthing bit = NULL,
		@FrequentHandWashing bit = NULL,
		@VisitsOldHomes bit = NULL,
		@DaycareID int = NULL,
		@Notes varchar(3000) = NULL,
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
														@New_QuestionnaireDate = @QuestionnaireDate,
														@New_QuestionnaireDataSourceID = @QuestionnaireDataSourceID,
														@New_VisitRemodeledProperty = @VisitRemodeledProperty,
														@New_PaintDate = @PaintDate,
														@New_RemodelPropertyDate = @RemodelPropertyDate,
														@New_isExposedtoPeelingPaint = @isExposedtoPeelingPaint,
														@New_isTakingVitamins = @isTakingVitamins,
														@New_NursingMother = @NursingMother,
														@New_NursingInfant = @NursingInfant,
														@New_Pregnant = @Pregnant,
														@New_isUsingPacifier = @isUsingPacifier,
														@New_isUsingBottle = @isUsingBottle,
														@New_BitesNails = @BitesNails,
														@New_NonFoodEating = @NonFoodEating,
														@New_NonFoodinMouth = @NonFoodinMouth,
														@New_EatOutside = @EatOutside,
														@New_Suckling = @Suckling,
														@New_Mouthing = @Mouthing,
														@New_FrequentHandWashing = @FrequentHandWashing,
														@New_VisitsOldHomes = @VisitsOldHomes,
														@New_DaycareID = @DaycareID,
														@New_Notes = @Notes,
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
