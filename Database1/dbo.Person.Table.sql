USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[BirthDate] [date] NULL,
	[Gender] [char](1) NULL,
	[StatusID] [smallint] NULL,
	[ForeignTravel] [bit] NULL,
	[OutofSite] [bit] NULL,
	[EatsForeignFood] [bit] NULL,
	[HistoricChildID] [smallint] NULL,
	[RetestDate] [date] NULL,
	[Moved] [bit] NULL,
	[MovedDate] [date] NULL,
	[isClosed] [bit] NULL,
	[isResolved] [bit] NULL,
	[GuardianID] [int] NULL,
	[personCode] [smallint] NULL,
	[isSmoker] [bit] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Person_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[Age]  AS ([dbo].[udf_CalculateAge]([BirthDate],getdate())),
	[isClient] [bit] NULL CONSTRAINT [DF_Person_isClient]  DEFAULT ((1)),
	[NursingMother] [bit] NULL,
	[Pregnant] [bit] NULL,
	[ReleaseStatusID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[EmailAddress] [varchar](320) NULL,
	[NursingInfant] [bit] NULL,
	[ClientStatusID] [smallint] NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Person]  WITH NOCHECK ADD  CONSTRAINT [FK_Person_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_ReviewStatus]
GO
ALTER TABLE [dbo].[Person]  WITH NOCHECK ADD  CONSTRAINT [FK_Person_TargetStatus] FOREIGN KEY([ClientStatusID])
REFERENCES [dbo].[TargetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_TargetStatus]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_BirthDate] CHECK  (([dbo].[udf_DateInThePast]([BirthDate])=(1)))
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_BirthDate]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_MovedDate] CHECK  (([dbo].[udf_DateInThePast]([MovedDate])=(1) OR [MovedDate] IS NULL))
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_MovedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for each person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s first name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'FirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s middle name or initial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MiddleName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s last name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'LastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s date of birth' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'BirthDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s gender (i.e. male or femal)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person travel to foreign countries' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'ForeignTravel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; is the person living out of the lead study area.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'OutofSite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person eat foreign candy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'EatsForeignFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ChildID from the access db system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'HistoricChildID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date for the next scheduled test' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'RetestDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; has the person moved outside the lead study area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Moved'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person moved outside of the study area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MovedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; is the person''s lead study closed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isClosed'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; has the lead issue been resolved' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isResolved'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'personID of the person''s guardian' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'GuardianID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person smoke' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isSmoker'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was last modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Calculated age of the person in years' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Age'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a participant in the lead study program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isClient'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a nursing mother' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'NursingMother'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person pregnant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Pregnant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s email address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'EmailAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a nursing infant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'NursingInfant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of people and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person'
GO
