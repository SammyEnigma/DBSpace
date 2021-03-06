USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Occupation]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Occupation](
	[OccupationID] [int] IDENTITY(1,1) NOT NULL,
	[OccupationName] [varchar](50) NOT NULL,
	[OccupationDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[LeadExposure] [bit] NULL,
 CONSTRAINT [PK_Occupation] PRIMARY KEY CLUSTERED 
(
	[OccupationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Occupation] ADD  CONSTRAINT [DF_Occupation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of occupation objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation'
GO
