USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersonToTravelCountry]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonToTravelCountry](
	[PersonID] [int] NOT NULL,
	[CountryID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersonToTravelCountry] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[CountryID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersonToTravelCountry] ADD  CONSTRAINT [DF_PersonToTravelCountry_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[PersonToTravelCountry] ADD  CONSTRAINT [DF_PersonToTravelCountry_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersonToTravelCountry]  WITH CHECK ADD  CONSTRAINT [FK_PersonToTravelCountry_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[PersonToTravelCountry] CHECK CONSTRAINT [FK_PersonToTravelCountry_Country]
GO
ALTER TABLE [dbo].[PersonToTravelCountry]  WITH NOCHECK ADD  CONSTRAINT [FK_PersonToTravelCountry_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonToTravelCountry] CHECK CONSTRAINT [FK_PersonToTravelCountry_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person entered the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person left the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and country traveled too' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry'
GO
