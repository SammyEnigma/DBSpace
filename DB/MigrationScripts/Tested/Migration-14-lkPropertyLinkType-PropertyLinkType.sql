USE LCCHPTestImport
GO

Insert into PropertyLinkType (HistoricPropertyLinkTypeID,PropertyLinkTypeName)
Select FPLinkTypeCode,FPLinkType from TESTAccessImport..lkFPLinkType

insert into PropertyLinkType (PropertyLinkTypeName) values ('Mailing address')

Select FPLinkTypeCode from TESTAccessImport..lkFPLinkType where FPLinkTypeCode not in (Select HistoricPropertyLinkTypeID from PropertyLinkType)

--First count should be 1 greater than second count
Select Count(*) from PropertyLinkType
Select Count(*) from TESTAccessImport..lkFPLinkType

select * from PropertyLinkType
Select * from TESTAccessImport..lkFPLinkType
