USE LCCHPTestImport
GO

Insert into FamilyToProperty (PropertyID,FamilyID,StartDate,EndDate,PropertyLinkTypeID,ReviewStatusID,ModifiedDate)
select P.PropertyID,F.FamilyID,FPLinkStart,FPLinkEnd,PLT.PropertyLinkTypeID,RS.ReviewStatusID ,Updated 
from TESTAccessImport..FamilyPropertyLink AS FPL
LEFT OUTER JOIN Property AS P on P.HistoricPropertyID = FPL.PropertyID
LEFT OUTER JOIN Family AS F on F.HistoricFamilyID = FPL.FamilyID
LEFT OUTER JOIN PropertyLinkType AS PLT ON PLT.HistoricPropertyLinkTypeID = FPL.[Type]
LEFT OUTER JOIN ReviewStatus AS RS ON replace(FPL.Revision,'"','') = RS.HistoricReviewStatusID
where FPL.FamilyID is not null and FPL.PropertyID is not null


--2468 4930
select * from FamilytoProperty where propertyID is null or familyID is null
Select count(*) from FamilytoProperty


select F.HistoricFamilyID,P.HistoricPropertyID,CountRelats = count(*) from FamilytoProperty AS F2P
JOIN Property AS P on P.PropertyID = F2P.PropertyID
JOIN Family AS F on F.FamilyID = F2P.FamilyID
group by F.HistoricFamilyID,P.HistoricPropertyID
order by count(*) desc

select FamilyID,PropertyID,CountRelats = count(*) from TESTAccessImport..FamilyPropertyLink 
group by FamilyID,PropertyID
order by count(*) desc

select count(*) from FamilytoProperty
select count(*) from TestAccessImport..FamilyPropertyLink where FamilyID is not null and PropertyID is not null

select  * from TestAccessImport..FamilyPropertyLink where FamilyID is null or PropertyID is null
