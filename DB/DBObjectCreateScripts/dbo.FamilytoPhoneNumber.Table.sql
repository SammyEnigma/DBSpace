USE [LCCHPDev]
GO

/****** Object:  Table [dbo].[FamilytoPhoneNumber]    Script Date: 4/4/2015 5:46:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FamilytoPhoneNumber](
	[FamilyID] [int] NOT NULL,
	[PhoneNumberID] [int] NOT NULL,
	[NumberPriority] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_FamilytoPhoneNumber] PRIMARY KEY CLUSTERED 
(
	[FamilyID] ASC,
	[PhoneNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO

ALTER TABLE [dbo].[FamilytoPhoneNumber] ADD  CONSTRAINT [DF_FamilytoPhoneNumber_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[FamilytoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_FamilytoPhoneNumber_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO

ALTER TABLE [dbo].[FamilytoPhoneNumber] CHECK CONSTRAINT [FK_FamilytoPhoneNumber_Family]
GO

ALTER TABLE [dbo].[FamilytoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_FamilytoPhoneNumber_PhoneNumber] FOREIGN KEY([PhoneNumberID])
REFERENCES [dbo].[PhoneNumber] ([PhoneNumberID])
GO

ALTER TABLE [dbo].[FamilytoPhoneNumber] CHECK CONSTRAINT [FK_FamilytoPhoneNumber_PhoneNumber]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'order which this number should be used to contact the Family (1 being first, 2 being 2nd . . . )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoPhoneNumber', @level2type=N'COLUMN',@level2name=N'NumberPriority'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for Family and phonenumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoPhoneNumber'
GO


