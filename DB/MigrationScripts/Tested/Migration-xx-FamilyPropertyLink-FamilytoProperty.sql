USE LCCHPTestImport
GO

Insert into FamilyToProperty (PropertyID,FamilyID,StartDate,EndDate,PropertyLinkTypeID,ReviewStatusID,ModifiedDate)
select PropertyID,FamilyID,FPLinkStart,FPLinkEnd,[Type],replace(Revision,'"',''),Updated from TESTAccessImport..FamilyPropertyLink


select * from FamilytoProperty
Select * from TESTAccessImport..FamilyPropertyLink

select * from TESTAccessImport..PropertiesImport


