USE LCCHPTestImport
GO

Insert into DataSource (HistoricDataSourceID,DataSourceDescription)
Select DataSourceCode,DataSource from TESTAccessImport..lkDataSource


select * from DataSource
Select * from TESTAccessImport..lkDataSource
	
