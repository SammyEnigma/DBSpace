USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[MediumSampleResults]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MediumSampleResults](
	[MediumSampleResultsID] [int] IDENTITY(1,1) NOT NULL,
	[MediumID] [int] NOT NULL,
	[MediumSampleValue] [numeric](9, 4) NULL,
	[SampleLevelCategoryID] [tinyint] NULL,
	[MediumSampleDate] [date] NOT NULL,
	[LabID] [int] NULL,
	[LabSubmissionDate] [date] NULL,
	[IsAboveTriggerLevel] [bit] NULL,
	[UnitsID] [smallint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_MediumTestResults] PRIMARY KEY CLUSTERED 
(
	[MediumSampleResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[MediumSampleResults] ADD  CONSTRAINT [DF_MediumTestResults_MediumTestDate]  DEFAULT (getdate()) FOR [MediumSampleDate]
GO
ALTER TABLE [dbo].[MediumSampleResults] ADD  CONSTRAINT [DF_MediumSampleResults_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Lab] FOREIGN KEY([LabID])
REFERENCES [dbo].[Lab] ([LabID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Lab]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Medium] FOREIGN KEY([MediumID])
REFERENCES [dbo].[Medium] ([MediumID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Medium]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_SampleLevelCategory] FOREIGN KEY([SampleLevelCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_SampleLevelCategory]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Units] FOREIGN KEY([UnitsID])
REFERENCES [dbo].[Units] ([UnitsID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Units]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH NOCHECK ADD  CONSTRAINT [ck_MediumSampleResults_MediumSampleDate] CHECK  (([dbo].[udf_DateInThePast]([MediumSampleDate])=(1)))
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [ck_MediumSampleResults_MediumSampleDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'tested medium id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'value of the test result for the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumSampleValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'sample level category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the medium was tested' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumSampleDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the sample was submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of test results for various medums' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults'
GO
