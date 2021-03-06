USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoHomeRemedy]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoHomeRemedy](
	[PersonID] [int] NOT NULL,
	[HomeRemedyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoHomeRemedy] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[HomeRemedyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoHomeRemedy] ADD  CONSTRAINT [DF_PersontoHomeRemedy_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoHomeRemedy]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoHomeRemedy_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoHomeRemedy] CHECK CONSTRAINT [FK_PersontoHomeRemedy_Person]
GO
ALTER TABLE [dbo].[PersontoHomeRemedy]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHomeRemedy_PersontoHomeRemedy] FOREIGN KEY([HomeRemedyID])
REFERENCES [dbo].[HomeRemedy] ([HomeRemedyID])
GO
ALTER TABLE [dbo].[PersontoHomeRemedy] CHECK CONSTRAINT [FK_PersontoHomeRemedy_PersontoHomeRemedy]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for perosn and home remedy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoHomeRemedy'
GO
