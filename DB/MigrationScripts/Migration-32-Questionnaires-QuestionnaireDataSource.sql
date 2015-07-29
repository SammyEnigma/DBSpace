USE LCCHPPublic
GO
SET NOCOUNT ON;

Insert into [dbo].[QuestionnaireDataSource] (QuestionnaireDataSourcename)
select distinct(Source) from LCCHPImport..Questionnaires where Source is not null

select 'Source values in Questionnaires that are not in QuestionnaireDataSource';
Select Source from LCCHPImport..Questionnaires where Source not in (Select QuestionnaireDataSourceName from QuestionnaireDataSource)

select 'comparing counts of sources in questionnaireDataSource vs distinct sources in Questionnaires';
Select Count(*) from QuestionnaireDataSource;
Select Count(distinct Source) from LCCHPImport..Questionnaires;

select 'comparing rows in questionnairedatasource to distinct sources in questionnaires';
select QuestionnaireDataSourceName from QuestionnaireDataSource;
select distinct Source from LCCHPImport..Questionnaires;