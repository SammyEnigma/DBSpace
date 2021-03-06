USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertytoHouseholdSourcesofLead]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoHouseholdSourcesofLead](
	[PropertyID] [int] NOT NULL,
	[HouseholdSourcesofLeadID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoHouseholdSourcesofLead] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[HouseholdSourcesofLeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] ADD  CONSTRAINT [DF_PropertytoHouseholdSourcesofLead_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead]  WITH CHECK ADD  CONSTRAINT [FK_HouseholdSourcesofLead_PropertytoHouseholdSourcesofLead] FOREIGN KEY([HouseholdSourcesofLeadID])
REFERENCES [dbo].[HouseholdSourcesofLead] ([HouseholdSourcesofLeadID])
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] CHECK CONSTRAINT [FK_HouseholdSourcesofLead_PropertytoHouseholdSourcesofLead]
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead]  WITH CHECK ADD  CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] CHECK CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and household sources of lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoHouseholdSourcesofLead'
GO
