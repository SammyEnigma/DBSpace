/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ConstTypeCode]
      ,[ConstType]
  FROM [TESTAccessImport].[dbo].[lkConstType]


insert into LeadTrackingTesting..ConstructionType (ConstructionTypeName, ConstructionTypeDescription)
  select ConstType,ConstTypeCode from TESTAccessImport..lkConstType

  select * from LeadTrackingTesting..ConstructionType