USE LCCHPTestImport
GO

Insert into SamplePurpose (HistoricSamplePurposeID,SamplePurposeName)
select SamplePurposeCode,SamplePurpose from TESTAccessImport..lkSamplePurpose


select * from SamplePurpose
Select * from TESTAccessImport..lkSamplePurpose

