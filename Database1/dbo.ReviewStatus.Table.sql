USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ReviewStatus]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReviewStatus](
	[ReviewStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReviewStatusDescription] [varchar](253) NULL,
	[ReviewStatusName] [varchar](50) NULL,
	[HistoricReviewStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ReviewStatus_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ReviewStatus] PRIMARY KEY CLUSTERED 
(
	[ReviewStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Review status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ReviewStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Review' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ReviewStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'HistoricReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for Review' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus'
GO
