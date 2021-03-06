USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ActionStatus]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActionStatus](
	[ActionStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ActionStatusDescription] [varchar](253) NULL,
	[ActionStatusName] [varchar](50) NULL,
	[HistoricActionStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ActionStatus] PRIMARY KEY CLUSTERED 
(
	[ActionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ActionStatus] ADD  CONSTRAINT [DF_ActionStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Action status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ActionStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ActionStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'HistoricActionStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus'
GO
