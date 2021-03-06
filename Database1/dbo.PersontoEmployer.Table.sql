USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoEmployer]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoEmployer](
	[PersonID] [int] NOT NULL,
	[EmployerID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoEmployer] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[EmployerID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoEmployer] ADD  CONSTRAINT [DF_PersontoEmployer_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[PersontoEmployer] ADD  CONSTRAINT [DF_PersontoEmployer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoEmployer]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEmployer_Employer] FOREIGN KEY([EmployerID])
REFERENCES [dbo].[Employer] ([EmployerID])
GO
ALTER TABLE [dbo].[PersontoEmployer] CHECK CONSTRAINT [FK_PersontoEmployer_Employer]
GO
ALTER TABLE [dbo].[PersontoEmployer]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoEmployer_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoEmployer] CHECK CONSTRAINT [FK_PersontoEmployer_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started working for the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped working for the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer'
GO
