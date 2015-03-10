/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ChildID]
      ,[FamilyID]
      ,[PrimaryLink]
      ,[CFLinkStartDate]
      ,[CFLinkEndDate]
      ,[ReviewStatusCode]
      ,[UpdateDate]
  FROM [TESTAccessImport].[dbo].[ChildFamilyLink]

  insert into [LeadTrackingTesting-Marco]..PersontoFamily (PersonID,FamilyID)
	  select distinct P.PersonID, Fam.familyID
	  from TESTAccessImport..ChildFamilyLink as CFL
	  left outer join TESTAccessImport..Children as CHILD on CFL.ChildID = Child.ChildId
	  join [LeadTrackingTesting-Marco]..Person as P on P.PersonCode = CFL.ChildID
	  join [LeadTrackingTesting-Marco]..Family as Fam on Fam.HistoricFamilyID = CFL.FamilyID
	  where CFL.ChildID is not null and CFL.FamilyID is not null

  select * from [LeadTrackingTesting-Marco]..PersontoFamily