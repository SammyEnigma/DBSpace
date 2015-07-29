use LCCHPPublic
Go
SET NOCOUNT ON;
  insert into Area (HistoricAreaID)
  select area from LCCHPImport..BloodPbResults
  WHERE Area IS NOT NULL
  UNION
  select area from LCCHPImport..Properties
  where area is not null
  
  select 'Comparing row count for area with distinct row count from bloodpbresults and properties'
  select count(HistoricAreaID) from Area
  select count (Area) from (   
	select area from LCCHPImport..BloodPbResults
	  WHERE Area IS NOT NULL
	  UNION
	  select area from LCCHPImport..Properties
	  where area is not null
	  ) Tmp;

select 'comparing rows from area to distinct rows from bloodpbresults and properties';
 select HistoricAreaID from Area order by HistoricAreaID
 select area from (
	 select area from LCCHPImport..BloodPbResults
	  WHERE Area IS NOT NULL
	  UNION
	  select area from LCCHPImport..Properties
	  where area is not null
 ) TMP order by Area;
