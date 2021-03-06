USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[InsuranceProvider]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InsuranceProvider](
	[InsuranceProviderID] [smallint] IDENTITY(1,1) NOT NULL,
	[InsuranceProviderName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_InsuranceProvider] PRIMARY KEY CLUSTERED 
(
	[InsuranceProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[InsuranceProvider] ADD  CONSTRAINT [DF_InsuranceProvider_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for insurance company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider', @level2type=N'COLUMN',@level2name=N'InsuranceProviderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the insurance company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider', @level2type=N'COLUMN',@level2name=N'InsuranceProviderName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of insurance companies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider'
GO
