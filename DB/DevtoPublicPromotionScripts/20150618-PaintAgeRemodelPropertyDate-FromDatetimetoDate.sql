select * from questionnaire where RemodelPropertyDate is not null

select * from Questionnaire where PaintDate is not null

alter table questionnaire add TempPaintDate Date, TempRemodelPropertyDate date

update Questionnaire set TempPaintDate = PaintDate, TempRemodelPropertyDate = RemodelPropertyDate

select questionnaireID,PaintDate,TempPaintDate from Questionnaire where TempPaintDate <> PaintDate

select questionnaireID,RemodelPropertyDate,TempRemodelPropertyDate from Questionnaire where TempRemodelPropertyDate <> RemodelPropertyDate

-- Set Paint date to just date
ALTER TABLE [dbo].[Questionnaire] DROP CONSTRAINT [ck_Questionnaire_PaintDate]
GO

alter table questionnaire drop column PaintAge

alter table questionnaire drop column PaintDate
GO
EXEC sp_rename 'questionnaire.TempPaintDate','PaintDate'
GO
alter table questionnaire add PaintAge AS ([dbo].[udf_CalculateAge]([PaintDate],getdate()))

ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [ck_Questionnaire_PaintDate] CHECK  (([dbo].[udf_DateInThePast]([PaintDate])=(1) OR [PaintDate] IS NULL))
GO

ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_PaintDate]
GO


-- Set Remodel Property date to just date
ALTER TABLE [dbo].[Questionnaire] DROP CONSTRAINT [ck_Questionnaire_RemodelPropertyDate]
GO

alter table questionnaire drop column RemodelPropertyAge


alter table questionnaire drop column RemodelPropertyDate
GO
EXEC sp_rename 'questionnaire.TempRemodelPropertyDate','RemodelPropertyDate'
GO
alter table questionnaire add RemodelPropertyAge AS ([dbo].[udf_CalculateAge]([RemodelPropertyDate],getdate()))

ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [ck_Questionnaire_RemodelPropertyDate] CHECK  (([dbo].[udf_DateInThePast]([RemodelPropertyDate])=(1) OR [RemodelPropertyDate] IS NULL))
GO

ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_RemodelPropertyDate]
GO