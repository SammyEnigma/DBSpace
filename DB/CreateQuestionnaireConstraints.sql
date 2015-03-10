USE [LCCHPDev]
GO

ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [ck_Questionnaire_PaintDate] CHECK  (([dbo].[udf_DateInThePast]([PaintDate])=(1) OR [PaintDate] IS NULL))
GO

ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_PaintDate]
GO

ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [ck_Questionnaire_QuestionnaireDate] CHECK  (([dbo].[udf_DateInThePast]([QuestionnaireDate])=(1)))
GO

ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_QuestionnaireDate]
GO

ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [ck_Questionnaire_RemodelPropertyDate] CHECK  (([dbo].[udf_DateInThePast]([RemodelPropertyDate])=(1) OR [RemodelPropertyDate] IS NULL))
GO

ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_RemodelPropertyDate]
GO


