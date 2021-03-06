USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertytoMedium]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoMedium](
	[PropertyID] [int] NOT NULL,
	[MediumID] [int] NOT NULL,
	[MediumTested] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoMedium] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[MediumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PropertytoMedium] ADD  CONSTRAINT [DF_PropertytoMedium_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertytoMedium]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoMedium_Medium] FOREIGN KEY([MediumID])
REFERENCES [dbo].[Medium] ([MediumID])
GO
ALTER TABLE [dbo].[PropertytoMedium] CHECK CONSTRAINT [FK_PropertytoMedium_Medium]
GO
ALTER TABLE [dbo].[PropertytoMedium]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoMedium_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoMedium] CHECK CONSTRAINT [FK_PropertytoMedium_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - yes; 1 - no.  Has the medium been tested.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoMedium', @level2type=N'COLUMN',@level2name=N'MediumTested'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and media' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoMedium'
GO
