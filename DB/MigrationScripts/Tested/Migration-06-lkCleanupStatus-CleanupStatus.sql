USE LCCHPTestImport
GO

Insert into CleanupStatus (HistoricCleanupStatusID,CleanupStatusName)
Select CleanupStatusCode,CleanupStatus from TESTAccessImport..lkCleanupStatus


Select * from CleanupStatus
Select * from TESTAccessImport..lkCleanupStatus
