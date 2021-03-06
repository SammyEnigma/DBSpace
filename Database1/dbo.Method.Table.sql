USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Method]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Method](
	[MethodID] [tinyint] IDENTITY(1,1) NOT NULL,
	[MethodDescription] [varchar](253) NULL,
	[MethodName] [varchar](50) NULL,
	[HistoricMethodID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Method] PRIMARY KEY CLUSTERED 
(
	[MethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Method] ADD  CONSTRAINT [DF_Method_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the method' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'MethodDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the method' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'MethodName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic method ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'HistoricMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of method classifications' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method'
GO
