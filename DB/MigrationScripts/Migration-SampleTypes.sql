USE LCCHPTest
GO



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [SampleTypeCode]
      ,[SampleType]
  FROM [TESTAccessImport].[dbo].[lkSampleType]


  Insert into SampleType (SampleTypeName, SampleTypeDescription)
   Select SampleType,SampleTypeCode from TESTAccessImport..lkSampleType

   insert into SampleType (SampleTypeName,SampleTypeDescription) values ('Venous','V')
   insert into SampleType (SampleTypeName,SampleTypeDescription) values ('Capillary','C')
  
  
   select * from SampleType
   