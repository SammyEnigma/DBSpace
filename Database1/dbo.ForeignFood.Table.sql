USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ForeignFood]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ForeignFood](
	[ForeignFoodID] [int] IDENTITY(1,1) NOT NULL,
	[ForeignFoodName] [varchar](50) NULL,
	[ForeignFoodDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ForeignFood] PRIMARY KEY CLUSTERED 
(
	[ForeignFoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ForeignFood] ADD  CONSTRAINT [DF_ForeignFood_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of various foreign foods' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ForeignFood'
GO
