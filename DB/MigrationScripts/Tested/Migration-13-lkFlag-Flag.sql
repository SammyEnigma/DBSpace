USE LCCHPTestImport
GO

Insert into Flag (HistoricFlagID,FlagDescription)
Select FlagCode,Flag from TESTAccessImport..lkFlag


select * from flag
Select * from TESTAccessImport..lkFlag
	
