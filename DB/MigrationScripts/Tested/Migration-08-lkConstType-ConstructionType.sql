USE LCCHPTestImport
GO

Insert into ConstructionType(HistoricConstructionTypeID,ConstructionTypeName)
Select ConstTypeCode,ConstType from TESTAccessImport..lkConstType

Select ConstTypeCode from TESTAccessImport..lkConstType where ConstTypeCode not in (Select HistoricConstructionTypeID from ConstructionType)

Select Count(*) from ConstructionType
Select Count(*) from TESTAccessImport..lkConstType

select * from ConstructionType
Select * from TESTAccessImport..lkConstType
	
