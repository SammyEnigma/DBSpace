USE LCCHPPublic
GO
SET NOCOUNT ON;
insert into TargetStatus(StatusName,TargetType)
Select ChildStatus,'Person' from LCCHPImport..lkChildStatus

select 'comparing personstatus row count to lkchildstatus row count'
select count(*) from PersonStatus
select count(*) from LCCHPImport..lkChildStatus

select 'comparing personstatus contents to lkchildstatus contents'
Select StatusName,* from TargetStatus

Recheck, Closed, Moved, Resolved, Home Visit, Complete
update 
select * from TargetStatus
Select * from LCCHPImport..lkChildStatus



