USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Family]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Family](
	[FamilyID] [int] IDENTITY(1,1) NOT NULL,
	[Lastname] [varchar](50) NOT NULL,
	[NumberofSmokers] [tinyint] NULL,
	[PrimaryLanguageID] [tinyint] NULL CONSTRAINT [DF_Family_PrimaryLanguageID]  DEFAULT ((1)),
	[Pets] [tinyint] NULL,
	[Petsinandout] [bit] NULL,
	[HistoricFamilyID] [smallint] NULL,
	[PrimaryPropertyID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Family_CreatedDate]  DEFAULT (getdate()),
	[FrequentlyWashPets] [bit] NULL,
	[ForeignTravel] [bit] NULL,
	[ReviewStatusID] [tinyint] NULL,
 CONSTRAINT [PK_Family] PRIMARY KEY CLUSTERED 
(
	[FamilyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the family object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'family name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'Lastname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'number of smokers in the family' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'NumberofSmokers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the families primary language; default = 1 (English)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'PrimaryLanguageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the family travel to foreign countries' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'ForeignTravel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Review status id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'ReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of families' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family'
GO
