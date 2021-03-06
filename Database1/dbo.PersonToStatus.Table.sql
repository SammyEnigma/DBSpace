USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersonToStatus]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonToStatus](
	[PersonID] [int] NOT NULL,
	[StatusID] [smallint] NOT NULL,
	[StatusDate] [date] NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersonToStatus] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[StatusID] ASC,
	[StatusDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersonToStatus] ADD  CONSTRAINT [DF_PersonToStatus_StatusDate]  DEFAULT (CONVERT([date],getdate())) FOR [StatusDate]
GO
ALTER TABLE [dbo].[PersonToStatus] ADD  CONSTRAINT [DF_PersonToStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersonToStatus]  WITH CHECK ADD  CONSTRAINT [FK_PersonToStatus_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonToStatus] CHECK CONSTRAINT [FK_PersonToStatus_Person]
GO
ALTER TABLE [dbo].[PersonToStatus]  WITH CHECK ADD  CONSTRAINT [FK_PersonToStatus_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[TargetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[PersonToStatus] CHECK CONSTRAINT [FK_PersonToStatus_Status]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the status was effective' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToStatus', @level2type=N'COLUMN',@level2name=N'StatusDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToStatus'
GO
