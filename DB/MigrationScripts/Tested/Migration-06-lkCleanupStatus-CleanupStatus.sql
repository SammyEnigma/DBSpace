USE LCCHPTestImport
GO

Insert into CleanupStatus (HistoricCleanupStatusID,CleanupStatusName)
Select CleanupStatusCode,CleanupStatus from TESTAccessImport..lkCleanupStatus



Select Count(*) from CleanupStatus
Select Count(*) from TESTAccessImport..lkCleanupStatus

select CleanupStatusCode from TESTAccessImport..lkCleanupStatus where CleanupStatusCode not in (Select HistoricCleanupStatusID from CLeanupStatus)

Select * from CleanupStatus
Select * from TESTAccessImport..lkCleanupStatus
