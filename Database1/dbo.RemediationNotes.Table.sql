USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[RemediationNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RemediationNotes](
	[RemediationNotesID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_RemediationNotes] PRIMARY KEY CLUSTERED 
(
	[RemediationNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RemediationNotes] ADD  CONSTRAINT [DF_RemediationNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[RemediationNotes]  WITH CHECK ADD  CONSTRAINT [FK_RemediationNotes_Remediation] FOREIGN KEY([RemediationID])
REFERENCES [dbo].[Remediation] ([RemediationID])
GO
ALTER TABLE [dbo].[RemediationNotes] CHECK CONSTRAINT [FK_RemediationNotes_Remediation]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for remediation notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationNotes'
GO
