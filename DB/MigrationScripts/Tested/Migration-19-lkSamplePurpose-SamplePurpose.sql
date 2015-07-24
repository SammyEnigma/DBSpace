USE LCCHPTestImport
GO

Insert into SamplePurpose (HistoricSamplePurposeID,SamplePurposeName)
select SamplePurposeCode,SamplePurpose from TESTAccessImport..lkSamplePurpose

Select SamplePurposeCode from TESTAccessImport..lkSamplePurpose where SamplePurposeCode not in (Select HistoricSamplePurposeID from SamplePurpose)

Select Count(*) from SamplePurpose
Select Count(*) from TESTAccessImport..lkSamplePurpose

select * from SamplePurpose
Select * from TESTAccessImport..lkSamplePurpose

