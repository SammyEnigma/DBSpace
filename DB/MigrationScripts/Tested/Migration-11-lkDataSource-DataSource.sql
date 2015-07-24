USE LCCHPTestImport
GO

Insert into DataSource (HistoricDataSourceID,DataSourceDescription)
Select DataSourceCode,DataSource from TESTAccessImport..lkDataSource

Select DataSourceCode from TESTAccessImport..lkDataSource where DataSourceCode not in (Select HistoricDataSourceID from DataSource)

Select Count(*) from DataSource
Select Count(*) from TESTAccessImport..lkDataSource

select * from DataSource
Select * from TESTAccessImport..lkDataSource
	
