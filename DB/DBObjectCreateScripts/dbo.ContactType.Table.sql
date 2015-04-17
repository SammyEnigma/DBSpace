USE [LCCHPDev]
GO

/****** Object:  Table [dbo].[ContactType]    Script Date: 4/16/2015 6:17:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContactType](
	[ContactTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ContactTypeDescription] [varchar](253) NULL,
	[ContactTypeName] [varchar](50) NULL,
	[HistoricContactTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ContactType] ADD  CONSTRAINT [DF_ContactType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Action status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ContactTypeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ContactTypeName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'HistoricContactTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of contact types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType'
GO


