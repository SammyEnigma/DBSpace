USE LCCHPPublic
GO
SET NOCOUNT ON;
insert into PersonStatus (PersonStatusName,HistoricPersonStatusID)
Select ChildStatus,ChildStatusCode from LCCHPImport..lkChildStatus

select 'comparing personstatus row count to lkchildstatus row count'
select count(*) from PersonStatus
select count(*) from LCCHPImport..lkChildStatus

select 'comparing personstatus contents to lkchildstatus contents'
Select HistoricPersonStatusID,PersonStatusName from PersonStatus
Select * from LCCHPImport..lkChildStatus
