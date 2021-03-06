USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoOccupation]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoOccupation](
	[PersonID] [int] NOT NULL,
	[OccupationID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoOccupation] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[OccupationID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoOccupation] ADD  CONSTRAINT [DF_PersontoOccupation_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[PersontoOccupation] ADD  CONSTRAINT [DF_PersontoOccupation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoOccupation]  WITH CHECK ADD  CONSTRAINT [FK_PersontoOccupation_Occupation] FOREIGN KEY([OccupationID])
REFERENCES [dbo].[Occupation] ([OccupationID])
GO
ALTER TABLE [dbo].[PersontoOccupation] CHECK CONSTRAINT [FK_PersontoOccupation_Occupation]
GO
ALTER TABLE [dbo].[PersontoOccupation]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoOccupation_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoOccupation] CHECK CONSTRAINT [FK_PersontoOccupation_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person ceased the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and occupatoin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation'
GO
