USE [names]
GO

/****** Object:  Table [dbo].[SeedTable]    Script Date: 12/26/2014 1:36:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SeedTable](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LastNames] [varchar](50) NULL,
	[FirstNames] [varchar](50) NULL,
	[streetnames] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](10) NULL
) 

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SeedTable] ADD  CONSTRAINT [DF__SeedTable2__city__6EC0713C]  DEFAULT ('Leadville') FOR [city]
GO

ALTER TABLE [dbo].[SeedTable] ADD  CONSTRAINT [DF__SeedTable__state__6FB49575]  DEFAULT ('co') FOR [state]
GO

