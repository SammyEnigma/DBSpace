USE LCCHPTestImport
GO

Insert into Method (HistoricMethodID,MethodName)
Select MethodCode,Method from TESTAccessImport..lkMethod

Select MethodCode from TESTAccessImport..lkMethod where MethodCode not in (Select HistoricMethodid from Method)

Select Count(*) from Method
Select Count(*) from TESTAccessImport..lkMethod

select * from Method
Select * from TESTAccessImport..lkMethod

