USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[RemediationActionPlan]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RemediationActionPlan](
	[RemediationActionPlanID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationActionPlanApprovalDate] [date] NULL,
	[HomeOwnerConsultationDate] [date] NULL,
	[ContractorCompletedInvestigationDate] [date] NULL,
	[RemediationActionPlanFinalReportSubmissionDate] [date] NULL,
	[RemediationActionPlanFile] [varbinary](max) NULL,
	[PropertyID] [int] NULL,
	[EnvironmentalInvestigationID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_RemediationActionPlan] PRIMARY KEY CLUSTERED 
(
	[RemediationActionPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RemediationActionPlan] ADD  CONSTRAINT [DF_RemediationActionPlan_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[RemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_RemediationActionPlan_EnvironmentalInvestigation] FOREIGN KEY([EnvironmentalInvestigationID])
REFERENCES [dbo].[EnvironmentalInvestigation] ([EnvironmentalInvestigationID])
GO
ALTER TABLE [dbo].[RemediationActionPlan] CHECK CONSTRAINT [FK_RemediationActionPlan_EnvironmentalInvestigation]
GO
ALTER TABLE [dbo].[RemediationActionPlan]  WITH NOCHECK ADD  CONSTRAINT [ck_RemediationActionPlan_RemediationActionPlanApprovalDate] CHECK  (([dbo].[udf_DateInThePast]([RemediationActionPlanApprovalDate])=(1)))
GO
ALTER TABLE [dbo].[RemediationActionPlan] CHECK CONSTRAINT [ck_RemediationActionPlan_RemediationActionPlanApprovalDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Meeting date between homeowner and workgroup to review the sampling plan' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationActionPlan', @level2type=N'COLUMN',@level2name=N'HomeOwnerConsultationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sampling plans' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationActionPlan'
GO
