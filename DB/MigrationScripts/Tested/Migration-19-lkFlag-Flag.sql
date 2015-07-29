USE LCCHPPublic
GO
SET NOCOUNT ON;


Insert into Flag (HistoricFlagID,FlagDescription)
Select FlagCode,Flag from LCCHPImport..lkFlag

select 'Rows in lkFlag that are not in Flag'
Select FlagCode from LCCHPImport..lkFlag where FlagCode not in (Select HistoricFlagID from Flag)

select 'comparing row count of Flag and lkFlag'
Select Count(*) from Flag
Select Count(*) from LCCHPImport..lkFlag

select 'listing Flag rows and lkFlag rows'
select * from flag
Select * from LCCHPImport..lkFlag
	
