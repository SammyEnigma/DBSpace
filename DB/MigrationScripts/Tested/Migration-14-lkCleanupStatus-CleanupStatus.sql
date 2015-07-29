USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into CleanupStatus (HistoricCleanupStatusID,CleanupStatusName)
Select CleanupStatusCode,CleanupStatus from [LCCHPImport]..lkCleanupStatus

select 'identifying rows in lkcleanupstatus that are not in Cleanupstatus'
select CleanupStatusCode from [LCCHPImport]..lkCleanupStatus 
where CleanupStatusCode not in (Select HistoricCleanupStatusID from CLeanupStatus)

select 'comparing row count of CleanupStatus to row count of lkCleanupStatus'
Select Count(*) from CleanupStatus
Select Count(*) from [LCCHPImport]..lkCleanupStatus

select 'comparing rows of CleanupStatus to rows of lkCleanupStatus'
Select HistoricCleanupStatusID,CleanupStatusName from CleanupStatus
Select * from [LCCHPImport]..lkCleanupStatus
