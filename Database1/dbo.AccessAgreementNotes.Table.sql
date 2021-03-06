USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[AccessAgreementNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessAgreementNotes](
	[AccessAgreementNotesID] [int] IDENTITY(1,1) NOT NULL,
	[AccessAgreementID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NULL,
 CONSTRAINT [PK_AccessAgreementNotes] PRIMARY KEY CLUSTERED 
(
	[AccessAgreementNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AccessAgreementNotes] ADD  CONSTRAINT [DF_AccessAgreementNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AccessAgreementNotes]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreementNotes_AccessAgreement] FOREIGN KEY([AccessAgreementID])
REFERENCES [dbo].[AccessAgreement] ([AccessAgreementID])
GO
ALTER TABLE [dbo].[AccessAgreementNotes] CHECK CONSTRAINT [FK_AccessAgreementNotes_AccessAgreement]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreementNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreementNotes'
GO
