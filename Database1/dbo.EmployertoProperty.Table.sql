USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[EmployertoProperty]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployertoProperty](
	[EmployerID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_EmployertoProperty] PRIMARY KEY CLUSTERED 
(
	[EmployerID] ASC,
	[PropertyID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[EmployertoProperty] ADD  CONSTRAINT [DF_EmployertoProperty_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[EmployertoProperty] ADD  CONSTRAINT [DF_EmployertoProperty_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EmployertoProperty]  WITH CHECK ADD  CONSTRAINT [FK_EmployertoProperty_Employer] FOREIGN KEY([EmployerID])
REFERENCES [dbo].[Employer] ([EmployerID])
GO
ALTER TABLE [dbo].[EmployertoProperty] CHECK CONSTRAINT [FK_EmployertoProperty_Employer]
GO
ALTER TABLE [dbo].[EmployertoProperty]  WITH CHECK ADD  CONSTRAINT [FK_EmployertoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[EmployertoProperty] CHECK CONSTRAINT [FK_EmployertoProperty_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the employer started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the employer stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for employer and property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty'
GO
