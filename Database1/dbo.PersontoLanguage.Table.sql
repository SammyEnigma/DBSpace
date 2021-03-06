USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoLanguage]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoLanguage](
	[PersonID] [int] NOT NULL,
	[LanguageID] [tinyint] NOT NULL,
	[isPrimaryLanguage] [bit] NOT NULL CONSTRAINT [DF_PersontoLanguage_isPrimaryLanguage]  DEFAULT ((1)),
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoLanguage_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoLanguage] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoLanguage]  WITH CHECK ADD  CONSTRAINT [FK_PersontoLanguage_Language] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Language] ([LanguageID])
GO
ALTER TABLE [dbo].[PersontoLanguage] CHECK CONSTRAINT [FK_PersontoLanguage_Language]
GO
ALTER TABLE [dbo].[PersontoLanguage]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoLanguage_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoLanguage] CHECK CONSTRAINT [FK_PersontoLanguage_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes; is this language the person''s primary language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoLanguage', @level2type=N'COLUMN',@level2name=N'isPrimaryLanguage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoLanguage'
GO
