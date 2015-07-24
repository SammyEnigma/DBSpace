USE LCCHPTestImport
GO

Insert into Frequency (HistoricFrequencyID,FrequencyName)
Select FrequencyCode,Frequency from TESTAccessImport..lkFrequency

Select FrequencyCode from TESTAccessImport..lkFrequency where FrequencyCode not in (Select HistoricFrequencyID from Frequency)

Select Count(*) from Frequency
Select Count(*) from TESTAccessImport..lkFrequency

select * from Frequency
Select * from TESTAccessImport..lkFrequency

