USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into ReleaseStatus (HistoricReleaseStatusID,ReleaseStatusName)
select ReleaseCode,ReleaseStatus from LCCHPImport..lkReleaseStatus;

select 'Rows in lkReleaseStatus that are not in ReleaseStatus';
Select ReleaseCode from LCCHPImport..lkReleaseStatus where ReleaseCode not in (Select HistoricReleaseStatusID from ReleaseStatus);

select 'comparing row count of ReleaseStatus to row count of lkReleaseStatus'
Select Count(*) from ReleaseStatus;
Select Count(*) from LCCHPImport..lkReleaseStatus;

select 'comparing rows of ReleaseStatus to rows of lkReleaseStatus'
select HistoricReleaseStatusID,ReleaseStatusName from ReleaseStatus;
Select * from LCCHPImport..lkReleaseStatus;

