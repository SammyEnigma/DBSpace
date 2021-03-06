USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[SampleLevelCategory]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SampleLevelCategory](
	[SampleLevelCategoryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SampleLevelCategoryName] [varchar](50) NULL,
	[SampleLevelCategoryDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_SampleLevelCategory] PRIMARY KEY CLUSTERED 
(
	[SampleLevelCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SampleLevelCategory] ADD  CONSTRAINT [DF_SampleLevelCategory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for sample level categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of sample level category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sample level categorizations' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory'
GO
