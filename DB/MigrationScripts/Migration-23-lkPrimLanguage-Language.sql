use LCCHPPublic
GO
SET NOCOUNT ON;

insert into Language (LanguageName,HistoricPrimaryLanguageCode)
select PrimLanguage,PrimLanguageCode from LCCHPImport..lkPrimLanguage;

select 'Rows in lkPrimLanguage that are not in Language';
Select PrimLanguageCode from LCCHPImport..lkPrimLanguage where PrimLanguageCode not in (Select HistoricPrimaryLanguageCode from [Language])

select 'comparing row counts for language and lkprimlanguage';
Select Count(*) from [Language];
Select Count(*) from LCCHPImport..lkPrimLanguage;

select 'comparing row entries for language and lkprimlanguage';
select LanguageID,LanguageName,HistoricPrimaryLanguageCode from [Language];
select PrimLanguage,PrimLanguageCode from LCCHPImport..lkPrimLanguage;