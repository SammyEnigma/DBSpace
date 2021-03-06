USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Remediation]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Remediation](
	[RemediationID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationApprovalDate] [date] NULL,
	[RemediationStartDate] [date] NULL,
	[RemediationEndDate] [date] NULL,
	[PropertyID] [int] NULL,
	[AccessAgreementID] [int] NULL,
	[FinalRemediationReportFile] [varbinary](max) NULL,
	[FinalRemediationReportDate] [date] NULL,
	[RemediationCost] [money] NULL,
	[OneYearRemediationCompleteDate] [date] NULL,
	[OneYearRemediationComplete] [bit] NULL,
	[RemediationActionPlanID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Remediation] PRIMARY KEY CLUSTERED 
(
	[RemediationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Remediation] ADD  CONSTRAINT [DF_Remediation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Remediation]  WITH CHECK ADD  CONSTRAINT [FK_Remediation_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [FK_Remediation_Property]
GO
ALTER TABLE [dbo].[Remediation]  WITH CHECK ADD  CONSTRAINT [FK_Remediation_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [FK_Remediation_RemediationActionPlan]
GO
ALTER TABLE [dbo].[Remediation]  WITH NOCHECK ADD  CONSTRAINT [ck_Remediation_RemediationApprovalDate] CHECK  (([dbo].[udf_DateInThePast]([RemediationApprovalDate])=(1)))
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [ck_Remediation_RemediationApprovalDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of remediation data' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Remediation'
GO
