USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[BloodTestResults]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BloodTestResults](
	[BloodTestResultsID] [int] IDENTITY(1,1) NOT NULL,
	[isBaseline] [bit] NOT NULL CONSTRAINT [DF_BloodTestResults_isBaseline]  DEFAULT ((0)),
	[PersonID] [int] NULL,
	[SampleDate] [date] NOT NULL CONSTRAINT [DF_BloodTestResults_SampleDate]  DEFAULT (getdate()),
	[LabSubmissionDate] [date] NULL,
	[LeadValue] [numeric](4, 1) NULL,
	[LeadValueCategoryID] [tinyint] NULL,
	[HemoglobinValue] [numeric](4, 1) NULL,
	[HemoglobinValueCategoryID] [tinyint] NULL,
	[HematocritValueCategoryID] [tinyint] NULL,
	[LabID] [int] NULL,
	[BloodTestCosts] [money] NULL,
	[SampleTypeID] [tinyint] NULL,
	[TakenAfterPropertyRemediationCompleted] [bit] NULL CONSTRAINT [DF_BloodTestResults_TakenAfterPropertyRemediationCompleted]  DEFAULT ((0)),
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_BloodTestResults_CreatedDate]  DEFAULT (getdate()),
	[HematocritValue]  AS ([hemoglobinValue]*(3)),
	[ExcludeResult] [bit] NULL,
	[HistoricBloodTestResultsID] [int] NULL,
	[HistoricLabResultsID] [varchar](10) NULL,
	[ClientStatusID] [smallint] NULL,
 CONSTRAINT [PK_BloodTestResults] PRIMARY KEY CLUSTERED 
(
	[BloodTestResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_HematocritLevelCategory] FOREIGN KEY([HematocritValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_HematocritLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_HemoglobinLevelCategory] FOREIGN KEY([HemoglobinValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_HemoglobinLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_Lab] FOREIGN KEY([LabID])
REFERENCES [dbo].[Lab] ([LabID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_Lab]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_LeadLevelCategory] FOREIGN KEY([LeadValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_LeadLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH NOCHECK ADD  CONSTRAINT [FK_BloodTestResults_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_Person]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_SampleType] FOREIGN KEY([SampleTypeID])
REFERENCES [dbo].[SampleType] ([SampleTypeID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_SampleType]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH NOCHECK ADD  CONSTRAINT [FK_BloodTestResults_TargetStatus] FOREIGN KEY([ClientStatusID])
REFERENCES [dbo].[TargetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_TargetStatus]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH NOCHECK ADD  CONSTRAINT [ck_BloodTestResults_SampleDate] CHECK  (([dbo].[udf_DateInThePast]([SampleDate])=(1)))
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [ck_BloodTestResults_SampleDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the blood test results object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'BloodTestResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'isBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was taken' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'SampleDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated lead value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LeadValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated hemoglobin value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HemoglobinValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated hematocrit value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HematocritValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the samples were submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the blood tests' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'BloodTestCosts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the type of sample; i.e. venus, capo, soil, water, nitton analyzer . . . ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - No, 1 - yes; was the blood sample taken after property remediation was completed.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'TakenAfterPropertyRemediationCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historic bloodpbresults id from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HistoricBloodTestResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic lab results id from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HistoricLabResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of blood test result values and categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults'
GO
