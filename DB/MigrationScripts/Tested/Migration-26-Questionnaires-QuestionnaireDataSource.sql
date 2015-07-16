USE LCCHPTestImport
GO

Insert into QuestionnaireDataSource (QuestionnaireDataSourcename)
select distinct(Source) from TESTAccessImport..Questionnaires

select * from QuestionnaireDataSource