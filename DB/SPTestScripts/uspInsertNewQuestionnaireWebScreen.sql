USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@Questionnaire_return_value int

EXEC	@return_value = [dbo].[usp_InsertNewQuestionnaireWebScreen]
		@Person_ID = 4442,
		@QuestionnaireDate = '20120512',
		@PaintPeeling = 1,
		@PaintDate = '2010',
		@VisitRemodel = 0,
		@RemodelDate = NULL,
		@Vitamins = 1,
		@HandWash = 0,
		@Bottle = 0,
		@NursingMother = 0,
		@NursingInfant = 0,
		@Pregnant = 0,
		@Pacifier = 0,
		@BitesNails = 0,
		@EatsOutdoors = 0,
		@NonFoodInMouth = 0,
		@EatsNonFood = 0,
		@SucksThumb = 1,
		@Mouthing = 1,
		@DaycareID = NULL,
		@VisitsOldHomes = 1,
		@DayCareNotes = NULL,
		@Source = NULL,
		@QuestionnaireNotes = NULL,
		@DEBUG = 1,
		@Questionnaire_return_value = @Questionnaire_return_value OUTPUT

SELECT	@Questionnaire_return_value as N'@Questionnaire_return_value'

SELECT	'Return Value' = @return_value

GO

select NursingMother,NursingInfant,Pregnant,* from Questionnaire where PersonID = 4442

select NursingMother, NursingInfant,Pregnant,* from person where personID = 4442