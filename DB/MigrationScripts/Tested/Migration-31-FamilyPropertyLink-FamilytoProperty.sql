USE LCCHPPublic
GO
SET NOCOUNT ON;

select 'inserting family to property relationships';
Insert into [FamilytoProperty] ([PropertyID],[FamilyID],[StartDate],[EndDate],[PropertyLinkTypeID],[ReviewStatusID],[ModifiedDate])
select [P].[PropertyID],[F].[FamilyID],[FPL].[FPLinkStartDate],[FPL].[FPLinkEndDate],[PLT].[PropertyLinkTypeID],[RS].[ReviewStatusID],[UpdateDate]
from LCCHPImport..[FamilyPropertyLink] AS [FPL]
LEFT OUTER JOIN [Property] AS [P] on [P].[HistoricPropertyID] = [FPL].[PropertyID]
LEFT OUTER JOIN [Family] AS [F] on [F].[HistoricFamilyID] = [FPL].[FamilyID]
LEFT OUTER JOIN [PropertyLinkType] AS [PLT] ON [PLT].[HistoricPropertyLinkTypeID] =	[FPL].[FPLinkTypeCode]
LEFT OUTER JOIN [ReviewStatus] AS [RS] ON replace([FPL].[ReviewStatusCode],'"','') = [RS].[HistoricReviewStatusID]
where [FPL].[FamilyID] is not null and [FPL].[PropertyID] is not null;

select 'comparing familytoproperty links vs familypropertylinks: difference should equal faimlypropertylink records with no property link';
select count(*) from FamilytoProperty
Select count(*) from LCCHPImport..FamilyPropertyLink;

select 'counting familypropertylink records with no property link'
select  count(*) from LCCHPImport..FamilyPropertyLink where FamilyID is null or PropertyID is null

select 'identifying familypropertylink records with no property link'
select  * from LCCHPImport..FamilyPropertyLink where FamilyID is null or PropertyID is null

select 'listing Families with more than 1 property relationship in LCCHPPublic'
select F.HistoricFamilyID,P.HistoricPropertyID,CountRelats = count(*) from FamilytoProperty AS F2P
JOIN Property AS P on P.PropertyID = F2P.PropertyID
JOIN Family AS F on F.FamilyID = F2P.FamilyID
group by F.HistoricFamilyID,P.HistoricPropertyID
having count(*) > 1
order by count(*) desc

select 'listing Families with more than 1 property relationship in LCCHPImport'
select FamilyID,PropertyID,CountRelats = count(*) from LCCHPImport..FamilyPropertyLink 
group by FamilyID,PropertyID
Having count(*) > 1
order by count(*) desc


select 'comparing row count of Familytoproperty and FamilyPropertyLink'
select count(*) from FamilytoProperty
select count(*) from LCCHPImport..FamilyPropertyLink where FamilyID is not null and PropertyID is not null

