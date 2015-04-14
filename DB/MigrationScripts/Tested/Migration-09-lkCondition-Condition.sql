USE LCCHPTestImport
GO

Insert into Condition (HistoricConditionID,ConditionName)
Select ConditionCode,Condition from TESTAccessImport..lkCondition


select * from Condition
Select * from TESTAccessImport..lkCondition
	
