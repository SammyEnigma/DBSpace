USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ForeignFoodtoCountry]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForeignFoodtoCountry](
	[ForeignFoodID] [int] NOT NULL,
	[CountryID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ForeignFoodtoCountry] PRIMARY KEY CLUSTERED 
(
	[ForeignFoodID] ASC,
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[ForeignFoodtoCountry] ADD  CONSTRAINT [DF_ForeignFoodtoCountry_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry]  WITH CHECK ADD  CONSTRAINT [FK_ForeignFoodtoCountry_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry] CHECK CONSTRAINT [FK_ForeignFoodtoCountry_Country]
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry]  WITH CHECK ADD  CONSTRAINT [FK_ForeignFoodtoCountry_ForeignFood] FOREIGN KEY([ForeignFoodID])
REFERENCES [dbo].[ForeignFood] ([ForeignFoodID])
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry] CHECK CONSTRAINT [FK_ForeignFoodtoCountry_ForeignFood]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'foreign food and country linking table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ForeignFoodtoCountry'
GO
