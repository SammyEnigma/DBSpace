USE LCCHPTestImport
GO

Insert into ContactType (HistoricContactTypeID,ContactTypeDescription)
Select ContactTypeCode,ContactType from TESTAccessImport..lkContactType


select * from ContactType
Select * from TESTAccessImport..lkContactType
	
