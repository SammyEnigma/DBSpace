use LCCHPTestImport
Go

  insert into Area (HistoricAreaID)
  select distinct(area) from TESTAccessImport..BloodPbResults
  WHERE Area IS NOT NULL
  UNION
  select distinct(area) from TESTAccessImport..Properties
  WHERE area not in (select distinct(area) from TESTAccessImport..BloodPbResults) AND AREA is not null
  
  select * from Area

  
