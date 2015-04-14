USE LCCHPTestImport
GO

Insert into ConstructionType(HistoricConstructionTypeID,ConstructionTypeName)
Select ConstTypeCode,ConstType from TESTAccessImport..lkConstType


select * from ConstructionType
Select * from TESTAccessImport..lkConstType
	
