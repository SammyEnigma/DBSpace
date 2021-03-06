USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoPhoneNumber]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoPhoneNumber](
	[PersonID] [int] NOT NULL,
	[PhoneNumberID] [int] NOT NULL,
	[NumberPriority] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoPhoneNumber] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PhoneNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoPhoneNumber] ADD  CONSTRAINT [DF_PersontoPhoneNumber_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoPhoneNumber]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoPhoneNumber_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPhoneNumber] CHECK CONSTRAINT [FK_PersontoPhoneNumber_Person]
GO
ALTER TABLE [dbo].[PersontoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPhoneNumber_PhoneNumber] FOREIGN KEY([PhoneNumberID])
REFERENCES [dbo].[PhoneNumber] ([PhoneNumberID])
GO
ALTER TABLE [dbo].[PersontoPhoneNumber] CHECK CONSTRAINT [FK_PersontoPhoneNumber_PhoneNumber]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'order which this number should be used to contact the person (1 being first, 2 being 2nd . . . )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPhoneNumber', @level2type=N'COLUMN',@level2name=N'NumberPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and phonenumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPhoneNumber'
GO
