USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Hobby]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hobby](
	[HobbyID] [smallint] IDENTITY(1,1) NOT NULL,
	[HobbyDescription] [varchar](253) NULL,
	[HobbyName] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Hobby_CreatedDate]  DEFAULT (getdate()),
	[LeadExposure] [bit] NULL,
 CONSTRAINT [PK_Hobby] PRIMARY KEY CLUSTERED 
(
	[HobbyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of hobby objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby', @level2type=N'COLUMN',@level2name=N'HobbyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the hobby' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby', @level2type=N'COLUMN',@level2name=N'HobbyDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of hobbies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby'
GO
