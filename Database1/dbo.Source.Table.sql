USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Source]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Source](
	[SourceID] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [varchar](50) NOT NULL,
	[SourceDescription] [varchar](253) NULL,
 CONSTRAINT [PK_Source] PRIMARY KEY CLUSTERED 
(
	[SourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
