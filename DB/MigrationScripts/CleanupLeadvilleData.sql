-- General Cleanup of Leadville data
select * into PersontoPropertyOriginal from PersontoProperty

-- Remove Record from Person to Propery: PersonID = 346 and PropertyID = 3736 and FamilyID = 323
-- FamilyIDs do not exist
delete from PersontoProperty where PersonID = 346 and PropertyID = 3736 and FamilyID = 323
delete from PersontoProperty where PersonID = 365 and PropertyID = 4522 and FamilyID = 727

alter Table PersontoProperty add PersontoPropertyID int IDENTITY(1,1)


select * into PersontoPropertyOriginal from PersontoProperty

select * from PersontoPropertyOriginal where (PersonID = 346 and PropertyID = 3736 and FamilyID = 323) or (PersonID = 365 and PropertyID = 4522 and FamilyID = 727)

insert into PersontoProperty (PersonID,PropertyID,StartDate,EndDate,isPrimaryResidence,FamilyID) 
	select PersonID,PropertyID,StartDate,EndDate,isPrimaryResidence,FamilyID from PersontoPropertyOriginal 
	where (PersonID = 346 and PropertyID = 3736 and FamilyID = 323) or (PersonID = 365 and PropertyID = 4522 and FamilyID = 727)

select * from persontoProperty order by PersontoPropertyID desc