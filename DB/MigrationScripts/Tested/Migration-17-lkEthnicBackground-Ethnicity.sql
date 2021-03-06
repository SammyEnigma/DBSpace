USE LCCHPPublic
GO
SET NOCOUNT ON;

  insert into Ethnicity (Ethnicity, HistoricEthnicityCode)
  select ethnicBackground,ethnicCode from LCCHPImport..lkEthnicBackground;

select 'Rows in lkEthnicBackground that are not in Ethnicity'
  Select EthnicCode from LCCHPImport..lkEthnicBackground where EthnicCode not in (Select HistoricEthnicityCode from Ethnicity);

  select 'comparing row count of ethnicity and lkEthnicBackground'
Select Count(*) from Ethnicity;
Select Count(*) from LCCHPImport..lkEthnicBackground;

select 'listing Ethnicity rows and lkEthnicbackground rows'
  select HistoricEthnicityCode,Ethnicity from Ethnicity;
  select * from LCCHPImport..lkEthnicBackground;