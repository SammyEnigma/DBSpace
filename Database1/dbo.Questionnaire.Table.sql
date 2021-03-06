USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Questionnaire]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaire](
	[QuestionnaireID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[QuestionnaireDate] [date] NULL,
	[QuestionnaireDataSourceID] [int] NULL,
	[VisitRemodeledProperty] [bit] NULL,
	[isExposedtoPeelingPaint] [bit] NULL,
	[isTakingVitamins] [bit] NULL CONSTRAINT [DF_Questionnaire_isTakingVitamins]  DEFAULT ((0)),
	[NursingMother] [bit] NULL CONSTRAINT [DF_Questionnaire_isNursing]  DEFAULT ((0)),
	[isUsingPacifier] [bit] NULL CONSTRAINT [DF_Questionnaire_isUsingPacifier]  DEFAULT ((0)),
	[isUsingBottle] [bit] NULL CONSTRAINT [DF_Questionnaire_isUsingBottle]  DEFAULT ((0)),
	[BitesNails] [bit] NULL CONSTRAINT [DF_Questionnaire_Bitesnails]  DEFAULT ((0)),
	[NonFoodEating] [bit] NULL CONSTRAINT [DF_Questionnaire_NonFoodEating]  DEFAULT ((0)),
	[NonFoodinMouth] [bit] NULL CONSTRAINT [DF_Questionnaire_NonFoodinMouth]  DEFAULT ((0)),
	[EatOutside] [bit] NULL CONSTRAINT [DF_Questionnaire_EatOutside]  DEFAULT ((0)),
	[Suckling] [bit] NULL CONSTRAINT [DF_Questionnaire_Suckling]  DEFAULT ((0)),
	[FrequentHandWashing] [bit] NULL CONSTRAINT [DF_Questionnaire_FrequentHandWashing]  DEFAULT ((0)),
	[DaycareID] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Questionnaire_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[Mouthing] [bit] NULL,
	[VisitsOldHomes] [bit] NULL,
	[NursingInfant] [bit] NULL,
	[Pregnant] [bit] NULL,
	[PaintDate] [date] NULL,
	[RemodelPropertyDate] [date] NULL,
	[PaintAge]  AS ([dbo].[udf_CalculateAge]([PaintDate],getdate())),
	[RemodelPropertyAge]  AS ([dbo].[udf_CalculateAge]([RemodelPropertyDate],getdate())),
 CONSTRAINT [PK_Questionnaire] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_Daycare]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_Person]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_ReviewStatus]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_PaintDate] CHECK  (([dbo].[udf_DateInThePast]([PaintDate])=(1) OR [PaintDate] IS NULL))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_PaintDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_QuestionnaireDate] CHECK  (([dbo].[udf_DateInThePast]([QuestionnaireDate])=(1)))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_QuestionnaireDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_RemodelPropertyDate] CHECK  (([dbo].[udf_DateInThePast]([RemodelPropertyDate])=(1) OR [RemodelPropertyDate] IS NULL))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_RemodelPropertyDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the questionnaire object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the patient the questionnaire is referring to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the questionnaire was completed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the person completing the questionnaire' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient frequently visited remodeled properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'VisitRemodeledProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  has the patient been exposed to peeling paint' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isExposedtoPeelingPaint'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  Is the patient taking vitamins regularly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isTakingVitamins'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient a mother nursing a child' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NursingMother'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient using a pacifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingPacifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient using a bottle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingBottle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient bite nails' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'BitesNails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient consume non food products' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodEating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient put non food items in mouth?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodinMouth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient eat outside?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'EatOutside'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient suck his/her thumb or suckle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Suckling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient frequently wash hands througout the day' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'FrequentHandWashing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the daycare the patient attends' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'DaycareID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was last modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Review Status ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'ReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the client mouth things frequently' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Mouthing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient visit older homes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'VisitsOldHomes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient a nursing infant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NursingInfant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient pregnant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Pregnant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of questionnaire questions and answers, typically only completed by flagged patients' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire'
GO
