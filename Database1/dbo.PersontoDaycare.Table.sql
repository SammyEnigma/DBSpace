USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoDaycare]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersontoDaycare](
	[PersonID] [int] NOT NULL,
	[DaycareID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[DaycareNotes] [varchar](3000) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoDaycare] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[DaycareID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PersontoDaycare] ADD  CONSTRAINT [DF_PersontoDaycare_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[PersontoDaycare] ADD  CONSTRAINT [DF_PersontoDaycare_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoDaycare]  WITH CHECK ADD  CONSTRAINT [FK_PersontoDaycare_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[PersontoDaycare] CHECK CONSTRAINT [FK_PersontoDaycare_Daycare]
GO
ALTER TABLE [dbo].[PersontoDaycare]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoDaycare_PersontoDaycare] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoDaycare] CHECK CONSTRAINT [FK_PersontoDaycare_PersontoDaycare]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started attending the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped attending the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and daycare for people attending daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare'
GO
