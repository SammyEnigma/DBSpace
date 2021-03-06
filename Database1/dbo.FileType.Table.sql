USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[FileType]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FileType](
	[FileTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[FileTypeName] [varchar](50) NOT NULL,
	[FileTypeDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_FileTypes] PRIMARY KEY CLUSTERED 
(
	[FileTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[FileType] ADD  CONSTRAINT [DF_FileType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
