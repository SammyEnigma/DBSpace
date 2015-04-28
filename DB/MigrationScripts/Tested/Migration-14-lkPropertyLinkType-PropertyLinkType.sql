USE LCCHPTestImport
GO

Insert into PropertyLinkType (HistoricPropertyLinkTypeID,PropertyLinkTypeName)
Select FPLinkTypeCode,FPLinkType from TESTAccessImport..lkFPLinkType


insert into PropertyLinkType (PropertyLinkTypeName) values ('Mailing address')

select * from PropertyLinkType
Select * from TESTAccessImport..lkFPLinkType


