USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ContractortoProperty]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoProperty](
	[ContractorID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ContractortoProperty] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[ContractortoProperty] ADD  CONSTRAINT [DF_ContractortoProperty_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ContractortoProperty]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoProperty_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoProperty] CHECK CONSTRAINT [FK_ContractortoProperty_Contractor]
GO
ALTER TABLE [dbo].[ContractortoProperty]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[ContractortoProperty] CHECK CONSTRAINT [FK_ContractortoProperty_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor started occuping the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date contractor ended property occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractor and occupied properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty'
GO
