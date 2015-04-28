USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PhoneNumberType]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhoneNumberType](
	[PhoneNumberTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PhoneNumberTypeName] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[HistoricPhoneCode] [char](1) NULL,
 CONSTRAINT [PK_PhoneNumberType] PRIMARY KEY CLUSTERED 
(
	[PhoneNumberTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PhoneNumberType] ADD  CONSTRAINT [DF_PhoneNumberType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
