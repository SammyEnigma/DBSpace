USE LCCHPPublic
GO
SET NOCOUNT ON;
Insert into ConstructionType(HistoricConstructionTypeID,ConstructionTypeName)
Select ConstTypeCode,ConstType from LCCHPImport..lkConstType

select 'comparing row count of ConstructionType to row count of lkConstructionType'
Select Count(*) from ConstructionType
Select Count(*) from LCCHPImport..lkConstType

select 'comparing rows of ConstructionType to rows of lkConstructionType'
select * from ConstructionType
Select * from LCCHPImport..lkConstType
	
