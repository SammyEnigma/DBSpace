USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into DataSource (HistoricDataSourceID,DataSourceDescription)
Select DataSourceCode,DataSource from LCCHPImport..lkDataSource

select 'Rows in lkdatasource that are not in datasource'
Select DataSourceCode from LCCHPImport..lkDataSource where DataSourceCode not in (Select HistoricDataSourceID from DataSource)

select 'comparing row count of datasource and lkdatasource'
Select Count(*) from DataSource
Select Count(*) from LCCHPImport..lkDataSource

select 'listing datasource rows and lkdatasource rows'
select HistoricDataSourceID,DataSourceDescription from DataSource
Select * from LCCHPImport..lkDataSource
	
