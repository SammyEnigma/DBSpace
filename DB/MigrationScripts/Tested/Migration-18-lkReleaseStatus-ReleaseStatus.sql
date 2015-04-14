USE LCCHPTestImport
GO

Insert into ReleaseStatus (HistoricReleaseStatusID,ReleaseStatusName)
select ReleaseCode,ReleaseStatus from TESTAccessImport..lkReleaseStatus


select * from ReleaseStatus
Select * from TESTAccessImport..lkReleaseStatus

