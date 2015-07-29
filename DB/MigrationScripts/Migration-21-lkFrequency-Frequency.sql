USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into Frequency (HistoricFrequencyID,FrequencyName)
Select FrequencyCode,Frequency from LCCHPImport..lkFrequency

select 'Rows in lkFrequency that are not in Frequency';
Select FrequencyCode from LCCHPImport..lkFrequency where FrequencyCode not in (Select HistoricFrequencyID from Frequency)

select 'comparing row count of Frequency and lkFrequency';
Select Count(*) from Frequency
Select Count(*) from LCCHPImport..lkFrequency

select 'listing Frequency rows and lkFrequency rows'
select HistoricFrequencyID,FrequencyName from Frequency
Select * from LCCHPImport..lkFrequency

