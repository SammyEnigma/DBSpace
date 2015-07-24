USE LCCHPTestImport
GO

Insert into ReleaseStatus (HistoricReleaseStatusID,ReleaseStatusName)
select ReleaseCode,ReleaseStatus from TESTAccessImport..lkReleaseStatus

Select ReleaseCode from TESTAccessImport..lkReleaseStatus where ReleaseCode not in (Select HistoricReleaseStatusID from ReleaseStatus)

Select Count(*) from ReleaseStatus
Select Count(*) from TESTAccessImport..lkReleaseStatus

select * from ReleaseStatus
Select * from TESTAccessImport..lkReleaseStatus

