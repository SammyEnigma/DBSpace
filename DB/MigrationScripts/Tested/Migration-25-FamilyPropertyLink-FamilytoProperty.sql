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

select count(*) from TestAccessImport..FamilyPropertyLink where FamilyID is not null and PropertyID is not null
Select count(*) from FamilytoProperty
