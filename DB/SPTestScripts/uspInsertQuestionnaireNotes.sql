USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@InsertedNotesID int

EXEC	@return_value = [dbo].[usp_InsertQuestionnaireNotes]
		@Questionnaire_ID = 6101,
		@Notes =  N'the family was very nervous about answering questions',
		@InsertedNotesID = @InsertedNotesID OUTPUT

SELECT	@InsertedNotesID as N'@InsertedNotesID'

SELECT	'Return Value' = @return_value

GO

select * from questionnaireNotes order by QuestionnaireNotesID desc