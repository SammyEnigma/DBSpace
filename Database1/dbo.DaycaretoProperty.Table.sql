USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[DaycaretoProperty]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DaycaretoProperty](
	[DaycareID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_DaycaretoProperty] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC,
	[PropertyID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[DaycaretoProperty] ADD  CONSTRAINT [DF_DaycaretoProperty_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[DaycaretoProperty] ADD  CONSTRAINT [DF_DaycaretoProperty_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[DaycaretoProperty]  WITH CHECK ADD  CONSTRAINT [FK_DaycaretoProperty_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[DaycaretoProperty] CHECK CONSTRAINT [FK_DaycaretoProperty_Daycare]
GO
ALTER TABLE [dbo].[DaycaretoProperty]  WITH CHECK ADD  CONSTRAINT [FK_DaycaretoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[DaycaretoProperty] CHECK CONSTRAINT [FK_DaycaretoProperty_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the daycare started occupying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the daycare stopped occupying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for daycare and property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty'
GO
