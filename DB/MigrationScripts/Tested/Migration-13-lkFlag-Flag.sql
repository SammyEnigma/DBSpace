USE LCCHPTestImport
GO

Insert into Flag (HistoricFlagID,FlagDescription)
Select FlagCode,Flag from TESTAccessImport..lkFlag

Select FlagCode from TESTAccessImport..lkFlag where FlagCode not in (Select HistoricFlagID from Flag)

Select Count(*) from Flag
Select Count(*) from TESTAccessImport..lkFlag

select * from flag
Select * from TESTAccessImport..lkFlag
	
