USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[FamilytoProperty]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilytoProperty](
	[FamilytoPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[PropertyLinkTypeID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[StartDate] [date] NULL CONSTRAINT [DF_FamilytoProperty_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[isPrimaryResidence] [bit] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FamilytoProperty_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_FamilytoProperty] PRIMARY KEY CLUSTERED 
(
	[FamilytoPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Family]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Property]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_PropertyLinkType] FOREIGN KEY([PropertyLinkTypeID])
REFERENCES [dbo].[PropertyLinkType] ([PropertyLinkTypeID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_PropertyLinkType]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_ReviewStatus]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary family id mainly from legacy system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the Family started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the Family stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for Family and property - indicating when a Family occuppied a property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty'
GO
