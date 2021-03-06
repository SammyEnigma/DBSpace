USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoPerson]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoPerson](
	[Person1ID] [int] NOT NULL,
	[Person2ID] [int] NOT NULL,
	[RelationshipTypeID] [int] NOT NULL,
	[isGuardian] [bit] NULL,
	[isPrimaryContact] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoPerson] PRIMARY KEY CLUSTERED 
(
	[Person1ID] ASC,
	[Person2ID] ASC,
	[RelationshipTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoPerson] ADD  CONSTRAINT [DF_PersontoPerson_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoPerson] ADD  CONSTRAINT [DF_PersontoPerson_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoPerson_Person1ID] FOREIGN KEY([Person1ID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_Person1ID]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoPerson_Person2ID] FOREIGN KEY([Person2ID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_Person2ID]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPerson_RelationshipType] FOREIGN KEY([RelationshipTypeID])
REFERENCES [dbo].[RelationshipType] ([RelationshipTypeID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_RelationshipType]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'relationshipType is how P1 relates to P2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'RelationshipTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'isGuardian is 1 if P1 is P2''s guardian' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'isGuardian'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'isPrimaryContact is 1 if P1 is P2''s primaryContact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'isPrimaryContact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of relationships between people' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson'
GO
