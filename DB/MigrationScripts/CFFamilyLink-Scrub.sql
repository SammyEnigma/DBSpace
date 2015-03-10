-- Scrub ChildFamilyLink

-- UserName
-- ActivityDate

select * from ChildFamilyLink

update ChildFamilyLink set CFLinkStartDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,CFLinkStartDate))), CFLinkEndDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,CFLinkEndDate)))

select * from ChildFamilyLink where CFLinkStartDate is not null or CFLinkEndDate is not null


