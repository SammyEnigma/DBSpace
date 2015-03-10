use LCCHPTest
Go

  insert into Area (HistoricAreaID)
  select distinct(area) from TESTAccessImport..BloodPbResults
  UNION
  select distinct(area) from TESTAccessImport..Properties
  
  select * from Area
