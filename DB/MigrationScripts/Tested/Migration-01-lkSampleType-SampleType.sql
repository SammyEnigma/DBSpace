Select * from SampleType


Select * from TESTAccessImport..lkSampleType


insert into SampleType (SampleTypename,historicSampleType)
Select SampleType,SampleTypeCode From TESTAccessImport..lkSampleType
UNION
select 'Venous','V'
UNION
select 'Capillary','C'

Select * from LCCHPTestImport..SampleType