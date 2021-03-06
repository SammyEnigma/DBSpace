USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoProperty]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoProperty](
	[PersonID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[isPrimaryResidence] [bit] NULL,
	[FamilyID] [int] NULL,
	[PersontoPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoProperty] PRIMARY KEY CLUSTERED 
(
	[PersontoPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoProperty] ADD  CONSTRAINT [DF_PersontoProperty_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[PersontoProperty] ADD  CONSTRAINT [DF_PersontoProperty_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoProperty_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoProperty] CHECK CONSTRAINT [FK_PersontoProperty_Person]
GO
ALTER TABLE [dbo].[PersontoProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersontoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PersontoProperty] CHECK CONSTRAINT [FK_PersontoProperty_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary family id mainly from legacy system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and property - indicating when a person occuppied a property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty'
GO
