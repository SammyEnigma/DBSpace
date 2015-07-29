USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into Method (HistoricMethodID,MethodName)
Select MethodCode,Method from LCCHPImport..lkMethod;

select 'Rows in lkMethod that are not in Method';
Select MethodCode from LCCHPImport..lkMethod where MethodCode not in (Select HistoricMethodid from Method);

select 'comparing row count of Method to row count of lkMethod'
Select Count(*) from Method;
Select Count(*) from LCCHPImport..lkMethod;

select 'comparing rows of Method to rows of lkMethod'
select HistoricMethodID,MethodName from Method;
Select * from LCCHPImport..lkMethod;

