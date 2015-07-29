USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into ActionStatus (HistoricActionStatusID,ActionStatusName)
Select ActionStatusCode,ActionStatus from LCCHPImport..lkActionStatus

select 'comparing row count of ActionStatus to row count of lkActionStatus'
select count(*) from ActionStatus
select count(*) from LCCHPImport..lkActionStatus

select 'comparing rows of ActionStatus to rows of lkActionStatus'
Select HistoricActionStatusID,ActionStatusName from ActionStatus
Select * from LCCHPImport..lkActionStatus