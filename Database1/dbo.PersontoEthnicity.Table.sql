USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoEthnicity]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoEthnicity](
	[PersonID] [int] NOT NULL,
	[EthnicityID] [tinyint] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoEthnicity_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoEthnicity_1] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[EthnicityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoEthnicity]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEthnicity_Ethnicity] FOREIGN KEY([EthnicityID])
REFERENCES [dbo].[Ethnicity] ([EthnicityID])
GO
ALTER TABLE [dbo].[PersontoEthnicity] CHECK CONSTRAINT [FK_PersontoEthnicity_Ethnicity]
GO
ALTER TABLE [dbo].[PersontoEthnicity]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoEthnicity_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoEthnicity] CHECK CONSTRAINT [FK_PersontoEthnicity_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and ethnicity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEthnicity'
GO
