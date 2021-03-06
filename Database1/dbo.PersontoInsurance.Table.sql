USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoInsurance]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersontoInsurance](
	[PersonID] [int] NOT NULL,
	[InsuranceID] [smallint] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[GroupID] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoInsurance] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[InsuranceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PersontoInsurance] ADD  CONSTRAINT [DF_PersontoInsurance_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoInsurance]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoInsurance_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoInsurance] CHECK CONSTRAINT [FK_PersontoInsurance_Person]
GO
ALTER TABLE [dbo].[PersontoInsurance]  WITH CHECK ADD  CONSTRAINT [FK_PersontoInsurance_PersontoInsurance] FOREIGN KEY([InsuranceID])
REFERENCES [dbo].[InsuranceProvider] ([InsuranceProviderID])
GO
ALTER TABLE [dbo].[PersontoInsurance] CHECK CONSTRAINT [FK_PersontoInsurance_PersontoInsurance]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person started the insurance policy with the provider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person stopped the insurance policy with the provider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'insurance company and policy group id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'GroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and insurance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance'
GO
