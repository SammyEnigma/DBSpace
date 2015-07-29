use LCCHPPublic
GO
SET NOCOUNT ON;

insert into SampleType (SampleTypename,historicSampleType)
Select SampleType,SampleTypeCode From LCCHPImport..lkSampleType
UNION
select 'Venous','V'
UNION
select 'Capillary','C';

-- sample types from access and lcchp group
select 'comparing row count from sampletype to row count from lksampletype (Sampletype should have 2 additional rows: venous and capillary'
Select count(*) from SampleType;
Select count(*) from LCCHPImport..lkSampleType;

select 'comparing rows from sampletype to rows from lksampletype';
Select SampleTypeID,SampleTypeName from SampleType order by SampleTypeName;
Select * from LCCHPImport..lkSampleType order by SampleType;


