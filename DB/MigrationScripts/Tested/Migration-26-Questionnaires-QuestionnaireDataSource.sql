USE LCCHPTestImport
GO

Insert into QuestionnaireDataSource (QuestionnaireDataSourcename)
select distinct(Source) from TESTAccessImport..Questionnaires

Select Source from TESTAccessImport..Questionnaires where Source not in (Select QuestionnaireDataSourceName from QuestionnaireDataSource)

Select Count(*) from QuestionnaireDataSource
Select Count(distinct Source) from TESTAccessImport..Questionnaires

select * from QuestionnaireDataSource
select distinct Source from TESTAccessImport..Questionnaires