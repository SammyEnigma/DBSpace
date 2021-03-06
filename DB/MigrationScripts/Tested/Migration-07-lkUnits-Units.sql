USE LCCHPPublic
GO
SET NOCOUNT ON;
/****** Script for SelectTopNRows command from SSMS  ******/
  select 'inserting units from lkunits'
  insert into Units (Units, HistoricUnitsCode)
    select Units,UnitsCode from [LCCHPImport]..lkUnits;

	select 'inserting additional units'
	insert into Units (Units) VALUES('mg/kg');
	insert into Units (Units) VALUES('ug/L');

	select 'listing units in Units - 2 more than lkunits: mg/kg and ug/L'
	Select * from Units order by Units;

	select 'listing rows in lkUnits'
SELECT TOP 1000 [UnitsCode]
      ,[Units]
  FROM [LCCHPImport].[dbo].[lkUnits]
  order by Units;