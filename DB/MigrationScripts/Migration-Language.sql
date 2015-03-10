use LeadTrackingTesting
GO

select LanguageID,LanguageName,PrimLanguageCode from Language

insert into Language (LanguageName,PrimLanguageCode)
select PrimLanguage,PrimLanguageCode from TESTAccessImport..lkPrimLanguage



select LanguageID,LanguageName,PrimLanguageCode from Language