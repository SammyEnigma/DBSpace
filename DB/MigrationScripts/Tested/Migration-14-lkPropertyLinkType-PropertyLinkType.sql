USE LCCHPTestImport
GO

Insert into PropertyLinkType (HistoricPropertyLinkTypeID,PropertyLinkTypeName)
Select FPLinkTypeCode,FPLinkType from TESTAccessImport..lkFPLinkType


select * from PropertyLinkType
Select * from TESTAccessImport..lkFPLinkType

