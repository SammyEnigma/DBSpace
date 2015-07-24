USE LCCHPTestImport
GO

insert into PersonStatus (PersonStatusName,HistoricPersonStatusID)
Select ChildStatus,ChildStatusCode from TESTAccessImport..lkChildStatus

Select * from PersonStatus