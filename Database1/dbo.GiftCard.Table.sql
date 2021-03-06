USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[GiftCard]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCard](
	[GiftCardID] [int] IDENTITY(1,1) NOT NULL,
	[GiftCardValue] [money] NOT NULL,
	[IssueDate] [date] NOT NULL,
	[PersonID] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_GiftCertificate] PRIMARY KEY CLUSTERED 
(
	[GiftCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[GiftCard] ADD  CONSTRAINT [DF_GiftCertificate_GiftCertificateValue]  DEFAULT ((25)) FOR [GiftCardValue]
GO
ALTER TABLE [dbo].[GiftCard] ADD  CONSTRAINT [DF_GiftCard_IssueDate]  DEFAULT (getdate()) FOR [IssueDate]
GO
ALTER TABLE [dbo].[GiftCard] ADD  CONSTRAINT [DF_GiftCard_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[GiftCard]  WITH NOCHECK ADD  CONSTRAINT [FK_GiftCard_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[GiftCard] CHECK CONSTRAINT [FK_GiftCard_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the gift certificate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard', @level2type=N'COLUMN',@level2name=N'GiftCardID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'value of the gift certificate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard', @level2type=N'COLUMN',@level2name=N'GiftCardValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of gift certificate objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard'
GO
