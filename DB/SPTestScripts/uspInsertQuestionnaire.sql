USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@QuestionnaireID int

EXEC	@return_value = [dbo].[usp_InsertQuestionnaire]
		@PersonID = 2670,
		@QuestionnaireDate = '20140822',
		@Source = NULL,
		@VisitRemodeledProperty = 1,
		@RemodelPropertyDate = '20000112',
		@isExposedtoPeelingPaint = 0,
		@isTakingVitamins = 1,
		@isNursing = 1,
		@isUsingPacifier = 1,
		@isUsingBottle = 1,
		@BitesNails = 0,
		@NonFoodEating = 1,
		@NonFoodinMouth = 1,
		@EatOutside = 1,
		@Suckling = 1,
		@FrequentHandWashing = 0,
		@Daycare = 0,
		@New_Notes = NULL,
		@QuestionnaireID = @QuestionnaireID OUTPUT

SELECT	@QuestionnaireID as N'@QuestionnaireID'

SELECT	'Return Value' = @return_value

GO

select * from Questionnaire order by QuestionnaireID desc