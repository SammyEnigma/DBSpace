USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Questionnaire]    Script Date: 4/26/2015 8:29:37 PM ******/
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
	[isTakingVitamins] [bit] NULL,
	[isNursing] [bit] NULL,
	[isUsingPacifier] [bit] NULL,
	[isUsingBottle] [bit] NULL,
	[BitesNails] [bit] NULL,
	[NonFoodEating] [bit] NULL,
	[NonFoodinMouth] [bit] NULL,
	[EatOutside] [bit] NULL,
	[Suckling] [bit] NULL,
	[FrequentHandWashing] [bit] NULL,
	[Daycare] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[RemodelPropertyDate] [datetime] NULL,
	[RemodeledPropertyAge]  AS ([dbo].[udf_CalculateAge]([RemodelPropertyDate],getdate())),
	[PaintDate] [datetime] NULL,
	[PaintAge]  AS ([dbo].[udf_CalculateAge]([PaintDate],getdate())),
	[ReviewStatusID] [tinyint] NULL,
	[Mouthing] [bit] NULL,
 CONSTRAINT [PK_Questionnaire] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_isTakingVitamins]  DEFAULT ((0)) FOR [isTakingVitamins]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_isNursing]  DEFAULT ((0)) FOR [isNursing]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_isUsingPacifier]  DEFAULT ((0)) FOR [isUsingPacifier]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_isUsingBottle]  DEFAULT ((0)) FOR [isUsingBottle]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_Bitesnails]  DEFAULT ((0)) FOR [BitesNails]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_NonFoodEating]  DEFAULT ((0)) FOR [NonFoodEating]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_NonFoodinMouth]  DEFAULT ((0)) FOR [NonFoodinMouth]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_EatOutside]  DEFAULT ((0)) FOR [EatOutside]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_Suckling]  DEFAULT ((0)) FOR [Suckling]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_FrequentHandWashing]  DEFAULT ((0)) FOR [FrequentHandWashing]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_Daycare]  DEFAULT ((1)) FOR [Daycare]
GO
ALTER TABLE [dbo].[Questionnaire] ADD  CONSTRAINT [DF_Questionnaire_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [FK_Questionnaire_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_Person]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH CHECK ADD  CONSTRAINT [FK_Questionnaire_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_ReviewStatus]
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the questionnaire object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the patient the questionnaire is referring to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the person completing the questionnaire' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  has the patient visited remodeled properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'VisitRemodeledProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'has the patient been exposed to peeling paint' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isExposedtoPeelingPaint'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  Is the patient taking vitamins regularly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isTakingVitamins'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is the patient nursing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isNursing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is the patient using a pacifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingPacifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is the patient using a bottle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingBottle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient bite nails' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'BitesNails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient consume non food products' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodEating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient put non food items in mouth?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodinMouth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient eat outside?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'EatOutside'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient suck his/her thumb or suckle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Suckling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the patient frequently wash hands througout the day' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'FrequentHandWashing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes; does the patient attend daycare on a regular basis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Daycare'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the client mouth things frequently' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Mouthing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of questionnaire questions and answers, typically only completed by flagged patients' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire'
GO
