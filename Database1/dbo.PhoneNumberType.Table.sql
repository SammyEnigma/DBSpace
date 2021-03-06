USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PhoneNumberType]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhoneNumberType](
	[PhoneNumberTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PhoneNumberTypeName] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PhoneNumberType_CreatedDate]  DEFAULT (getdate()),
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
