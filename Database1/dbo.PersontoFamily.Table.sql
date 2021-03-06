USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoFamily]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoFamily](
	[PersonID] [int] NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoFamily_CreatedDate]  DEFAULT (getdate()),
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PrimaryContactFamily] [bit] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoFamily] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[FamilyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoFamily]  WITH CHECK ADD  CONSTRAINT [FK_PersontoFamily_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[PersontoFamily] CHECK CONSTRAINT [FK_PersontoFamily_Family]
GO
ALTER TABLE [dbo].[PersontoFamily]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoFamily_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoFamily] CHECK CONSTRAINT [FK_PersontoFamily_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the corresponding person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the corresponding family' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and family tables' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily'
GO
