USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertySampleResults]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertySampleResults](
	[PropertySampleResultsID] [int] IDENTITY(1,1) NOT NULL,
	[isBaseline] [bit] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[LabSubmissionDate] [date] NULL,
	[LabID] [int] NULL,
	[SampleTypeID] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertySampletResults] PRIMARY KEY CLUSTERED 
(
	[PropertySampleResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PropertySampleResults] ADD  CONSTRAINT [DF_PropertyTestResults_isBaseline]  DEFAULT ((0)) FOR [isBaseline]
GO
ALTER TABLE [dbo].[PropertySampleResults] ADD  CONSTRAINT [DF_PropertySampleResults_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampleResults_SampleType] FOREIGN KEY([SampleTypeID])
REFERENCES [dbo].[SampleType] ([SampleTypeID])
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [FK_PropertySampleResults_SampleType]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampletResults_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [FK_PropertySampletResults_Property]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH NOCHECK ADD  CONSTRAINT [ck_PropertySampleResults_LabSubmissionDate] CHECK  (([dbo].[udf_DateInThePast]([LabSubmissionDate])=(1)))
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [ck_PropertySampleResults_LabSubmissionDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for property test results' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'PropertySampleResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is this a baseline test result for the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'isBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the property to which the test results apply' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the proeprty test samples were submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the property samples were submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of property test results' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults'
GO
