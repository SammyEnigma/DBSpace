USE LCCHPTestImport
GO

Insert into Method (HistoricMethodID,MethodName)
Select MethodCode,Method from TESTAccessImport..lkMethod


select * from Method
Select * from TESTAccessImport..lkObject

