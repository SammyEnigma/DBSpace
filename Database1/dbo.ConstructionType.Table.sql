USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ConstructionType]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConstructionType](
	[ConstructionTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeName] [varchar](50) NOT NULL,
	[ConstructionTypeDescription] [varchar](253) NULL,
	[HistoricConstructionTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ConstructionType_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ConstructionType] PRIMARY KEY CLUSTERED 
(
	[ConstructionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the construction type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType', @level2type=N'COLUMN',@level2name=N'ConstructionTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of the construction type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType', @level2type=N'COLUMN',@level2name=N'ConstructionTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of construction types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType'
GO
