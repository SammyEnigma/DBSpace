USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[QuestionnaireNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuestionnaireNotes](
	[QuestionnaireNotesID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_QuestionnaireNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_QuestionnaireNotes] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[QuestionnaireNotes]  WITH NOCHECK ADD  CONSTRAINT [FK_QuestionnaireNotes_Questionnaire] FOREIGN KEY([QuestionnaireID])
REFERENCES [dbo].[Questionnaire] ([QuestionnaireID])
GO
ALTER TABLE [dbo].[QuestionnaireNotes] CHECK CONSTRAINT [FK_QuestionnaireNotes_Questionnaire]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireNotes'
GO
