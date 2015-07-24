use LCCHPTestImport
GO

insert into Language (LanguageName,HistoricPrimaryLanguageCode)
select PrimLanguage,PrimLanguageCode from TESTAccessImport..lkPrimLanguage

Select PrimLanguageCode from TESTAccessImport..lkPrimLanguage where PrimLanguageCode not in (Select HistoricPrimaryLanguageCode from [Language])

Select Count(*) from [Language]
Select Count(*) from TESTAccessImport..lkPrimLanguage

select LanguageID,LanguageName,HistoricPrimaryLanguageCode from [Language]
select PrimLanguage,PrimLanguageCode from TESTAccessImport..lkPrimLanguage