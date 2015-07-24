USE LCCHPTestImport
GO

Insert into Condition (HistoricConditionID,ConditionName)
Select ConditionCode,Condition from TESTAccessImport..lkCondition

Select ConditionCode from TESTAccessImport..lkCondition where ConditionCode not in (Select HistoricConditionID from Condition)

Select Count(*) from Condition
Select Count(*) from TESTAccessImport..lkCondition

select * from Condition
Select * from TESTAccessImport..lkCondition
	
