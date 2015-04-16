select top 15 * from family order by familyid desc
select top 6 * from person order by personid desc
select top 6 * from property order by propertyid desc
select * from medium
select top 6 * from Questionnaire
select * from occupation
select * from Daycare
select * from SampleType
select * from ConstructionType
select * from Country
select * from units
select * from MediumSampleResults
Select * from SampleLevelCategory
select * from AccessAgreement

-- Select all triggers
select * from sysobjects where type = 'TR'

sp_who2

