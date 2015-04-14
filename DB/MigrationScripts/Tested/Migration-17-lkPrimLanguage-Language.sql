use LCCHPTestImport
GO

select LanguageID,LanguageName,PrimLanguageCode from Language

insert into Language (LanguageName,HistoricPrimaryLanguageCode)
select PrimLanguage,PrimLanguageCode from TESTAccessImport..lkPrimLanguage

select LanguageID,LanguageName,HistoricPrimaryLanguageCode from [Language]
select PrimLanguage,PrimLanguageCode from TESTAccessImport..lkPrimLanguage