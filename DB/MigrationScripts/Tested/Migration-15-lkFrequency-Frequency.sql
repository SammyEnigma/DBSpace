USE LCCHPTestImport
GO

Insert into Frequency (HistoricFrequencyID,FrequencyName)
Select FrequencyCode,Frequency from TESTAccessImport..lkFrequency


select * from Frequency
Select * from TESTAccessImport..lkFrequency

