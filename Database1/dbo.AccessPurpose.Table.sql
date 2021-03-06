USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[AccessPurpose]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessPurpose](
	[AccessPurposeID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPurposeName] [varchar](50) NULL,
	[AccessPurposeDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AccessPurpose] PRIMARY KEY CLUSTERED 
(
	[AccessPurposeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AccessPurpose] ADD  CONSTRAINT [DF_AccessPurpose_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly name for the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose', @level2type=N'COLUMN',@level2name=N'AccessPurposeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'a description of the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose', @level2type=N'COLUMN',@level2name=N'AccessPurposeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of purposes for access requests/agreements' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose'
GO
