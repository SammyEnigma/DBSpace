USE LCCHPTestImport
GO

Insert into ContactType (HistoricContactTypeID,ContactTypeDescription)
Select ContactTypeCode,ContactType from TESTAccessImport..lkContactType

Select ContactTypeCode from TESTAccessImport..lkContactType where ContactTypeCode not in (Select HistoricContactTypeID from ContactType)

Select Count(*) from ContactType
Select Count(*) from TESTAccessImport..lkContactType

select * from ContactType
Select * from TESTAccessImport..lkContactType
	
