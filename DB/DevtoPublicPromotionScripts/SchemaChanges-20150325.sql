alter Table [Person] add [isClient] bit NULL;

ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF_Person_isClient]  DEFAULT (1) FOR [isClient];
GO

update [Person] set [isClient] = 1;

alter Table [Person] add [isNursing] bit NULL;
alter Table [Person] add [isPregnant] bit NULL;
