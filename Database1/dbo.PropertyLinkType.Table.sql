USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertyLinkType]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyLinkType](
	[PropertyLinkTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PropertyLinkTypeDescription] [varchar](253) NULL,
	[PropertyLinkTypeName] [varchar](50) NULL,
	[HistoricPropertyLinkTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertyLinkType_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PropertyLinkType] PRIMARY KEY CLUSTERED 
(
	[PropertyLinkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the property link type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'PropertyLinkTypeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the property link type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'PropertyLinkTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic flg ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'HistoricPropertyLinkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of property link types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType'
GO
