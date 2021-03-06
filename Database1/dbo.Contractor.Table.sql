USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Contractor]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contractor](
	[ContractorID] [int] IDENTITY(1,1) NOT NULL,
	[ContractorName] [varchar](50) NULL,
	[ContractorDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Contractor] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Contractor] ADD  CONSTRAINT [DF_Contractor_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
