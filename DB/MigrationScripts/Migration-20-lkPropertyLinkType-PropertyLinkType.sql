USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into PropertyLinkType (HistoricPropertyLinkTypeID,PropertyLinkTypeName)
Select FPLinkTypeCode,FPLinkType from LCCHPImport..lkFPLinkType;

insert into PropertyLinkType (PropertyLinkTypeName) values ('Mailing address');

select 'Rows in lkFPLinkType that are not in PropertyLinkType';
Select FPLinkTypeCode from LCCHPImport..lkFPLinkType where FPLinkTypeCode not in (Select HistoricPropertyLinkTypeID from PropertyLinkType)

select 'First count should be 1 greater than second count'
select 'comparing row count of PropertyLinkType and lkFPLinkTYpe';
Select Count(*) from PropertyLinkType;
Select Count(*) from LCCHPImport..lkFPLinkType;

select 'listing propertylinktype rows and lkFPLinkTyp rows'
select HistoricPropertyLinkTypeID,PropertyLinkTypeName from PropertyLinkType
Select * from LCCHPImport..lkFPLinkType
