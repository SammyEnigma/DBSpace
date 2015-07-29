USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into SamplePurpose (HistoricSamplePurposeID,SamplePurposeName)
select SamplePurposeCode,SamplePurpose from LCCHPImport..lkSamplePurpose;

select 'Rows in lkSamplePurpose that are not in SamplePurpose';
Select SamplePurposeCode from LCCHPImport..lkSamplePurpose where SamplePurposeCode not in (Select HistoricSamplePurposeID from SamplePurpose)

select 'comparing row count of SamplePurpose to row count of lkSamplePurpose'
Select Count(*) from SamplePurpose;
Select Count(*) from LCCHPImport..lkSamplePurpose;

select 'comparing rows of SamplePurpose to rows of lkSamplePurpose'
select HistoricSamplePurposeID,SamplePurposeName from SamplePurpose;
Select * from LCCHPImport..lkSamplePurpose;

