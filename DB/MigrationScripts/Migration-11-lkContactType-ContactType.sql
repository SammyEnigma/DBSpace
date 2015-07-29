USE LCCHPPublic
GO
SET NOCOUNT ON;
Insert into ContactType (HistoricContactTypeID,ContactTypeDescription)
Select ContactTypeCode,ContactType from LCCHPImport..lkContactType

Select ContactTypeCode from LCCHPImport..lkContactType where ContactTypeCode not in (Select HistoricContactTypeID from ContactType)

select 'comparing row count of ContactType to row count of lkcontactType'
Select Count(*) from ContactType
Select Count(*) from LCCHPImport..lkContactType

select 'comparing row count of contacttype to row count of lkContactType'
select HistoricContactTypeID,ContactTypeDescription from ContactType
Select * from LCCHPImport..lkContactType
	
