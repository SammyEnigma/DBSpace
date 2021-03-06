USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[BloodTestResultsNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BloodTestResultsNotes](
	[BloodTestResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[BloodTestResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_BloodTestResultsNotes] PRIMARY KEY CLUSTERED 
(
	[BloodTestResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BloodTestResultsNotes] ADD  CONSTRAINT [DF_BloodTestResultsNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[BloodTestResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResultsNotes_BloodTestResults] FOREIGN KEY([BloodTestResultsID])
REFERENCES [dbo].[BloodTestResults] ([BloodTestResultsID])
GO
ALTER TABLE [dbo].[BloodTestResultsNotes] CHECK CONSTRAINT [FK_BloodTestResultsNotes_BloodTestResults]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResultsNotes'
GO
