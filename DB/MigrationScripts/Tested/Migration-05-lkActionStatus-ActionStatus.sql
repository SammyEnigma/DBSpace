USE LCCHPTestImport
GO

Insert into ActionStatus (HistoricActionStatusID,ActionStatusName)
Select ActionStatusCode,ActionStatus from TESTAccessImport..lkActionStatus


Select * from ActionStatus
Select * from TESTAccessImport..lkActionStatus