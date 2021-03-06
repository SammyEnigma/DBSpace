USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[HomeRemedy]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HomeRemedy](
	[HomeRemedyID] [int] IDENTITY(1,1) NOT NULL,
	[HomeRemedyName] [varchar](50) NOT NULL,
	[HomeRemedyDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_HomeRemedies] PRIMARY KEY CLUSTERED 
(
	[HomeRemedyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[HomeRemedy] ADD  CONSTRAINT [DF_HomeRemedy_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of home remedies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HomeRemedy'
GO
