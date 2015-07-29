USE LCCHPPublic
GO
SET NOCOUNT ON;
Insert into Condition (HistoricConditionID,ConditionName)
Select ConditionCode,Condition from LCCHPImport..lkCondition

select 'listing conditions in lkcondition that are not in Condition';
Select ConditionCode from LCCHPImport..lkCondition where ConditionCode not in (Select HistoricConditionID from Condition)

select 'comparing row count of condition to row count of lkcondition'
Select Count(*) from Condition
Select Count(*) from LCCHPImport..lkCondition

select 'comparing rows of condition to rows of lkcondition'
select HistoricConditionID,ConditionName from Condition
Select * from LCCHPImport..lkCondition
	
