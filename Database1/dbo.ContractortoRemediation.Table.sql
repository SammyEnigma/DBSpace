USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ContractortoRemediation]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoRemediation](
	[ContractorID] [int] NOT NULL,
	[RemediationID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[isSubContractor] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ContractortoRemediation] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[RemediationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[ContractortoRemediation] ADD  CONSTRAINT [DF_ContractortoRemediation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ContractortoRemediation]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediation_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediation] CHECK CONSTRAINT [FK_ContractortoRemediation_Contractor]
GO
ALTER TABLE [dbo].[ContractortoRemediation]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediation_Remediation] FOREIGN KEY([RemediationID])
REFERENCES [dbo].[Remediation] ([RemediationID])
GO
ALTER TABLE [dbo].[ContractortoRemediation] CHECK CONSTRAINT [FK_ContractortoRemediation_Remediation]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor started working on the remidiation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor stopped working on the remediation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - no, 1 - yes.  is this contractor a sub contractor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'isSubContractor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractors and remediations' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation'
GO
