USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Area]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Area](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[AreaDescription] [varchar](253) NULL,
	[HistoricAreaID] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Area_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area', @level2type=N'COLUMN',@level2name=N'AreaID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly description/name of the area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area', @level2type=N'COLUMN',@level2name=N'AreaDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of areas and basic information' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area'
GO
