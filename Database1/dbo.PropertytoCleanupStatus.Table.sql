USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertytoCleanupStatus]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoCleanupStatus](
	[PropertyID] [int] NOT NULL,
	[CleanupStatusID] [tinyint] NOT NULL,
	[CleanupStatusDate] [date] NOT NULL,
	[CostofCleanup] [money] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoCleanupStatus] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[CleanupStatusID] ASC,
	[CleanupStatusDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] ADD  CONSTRAINT [DF_PropertytoCleanupStatus_CleanupStatusDate]  DEFAULT (getdate()) FOR [CleanupStatusDate]
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] ADD  CONSTRAINT [DF_PropertytoCleanupStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoCleanupStatus_CleanupStatus] FOREIGN KEY([CleanupStatusID])
REFERENCES [dbo].[CleanupStatus] ([CleanupStatusID])
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] CHECK CONSTRAINT [FK_PropertytoCleanupStatus_CleanupStatus]
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoCleanupStatus_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] CHECK CONSTRAINT [FK_PropertytoCleanupStatus_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date of the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the cleanup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus', @level2type=N'COLUMN',@level2name=N'CostofCleanup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus'
GO
