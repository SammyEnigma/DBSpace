USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoForeignFood]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoForeignFood](
	[PersonID] [int] NOT NULL,
	[ForeignFoodID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoForeignFood] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[ForeignFoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoForeignFood] ADD  CONSTRAINT [DF_PersontoForeignFood_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoForeignFood]  WITH CHECK ADD  CONSTRAINT [FK_PersontoForeignFood_ForeignFood] FOREIGN KEY([ForeignFoodID])
REFERENCES [dbo].[ForeignFood] ([ForeignFoodID])
GO
ALTER TABLE [dbo].[PersontoForeignFood] CHECK CONSTRAINT [FK_PersontoForeignFood_ForeignFood]
GO
ALTER TABLE [dbo].[PersontoForeignFood]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoForeignFood_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoForeignFood] CHECK CONSTRAINT [FK_PersontoForeignFood_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and foreign food (many to many)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoForeignFood'
GO
