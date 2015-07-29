use LCCHPPublic
GO

select 'inserting persontofamily relationships'
  insert into PersontoFamily (PersonID,FamilyID,StartDate,EndDate,PrimaryContactFamily,ReviewStatusID)
	  select P.PersonID, Fam.familyID,CFL.CFLinkStartDate,CFL.CFLinkEndDate,cast(CFL.PrimaryLink as bit),RS.ReviewStatusID
	  from LCCHPImport..ChildFamilyLink as CFL
	  LEFT OUTER join Person as P on CFL.ChildID = P.HistoricChildID
	  LEFT OUTER join Family as Fam on CFL.FamilyID = Fam.HistoricFamilyID 
	  LEFT OUTER JOIN ReviewStatus AS RS on CFL.ReviewStatusCode = RS.HistoricReviewStatusID

select * from LCCHPImport..Families where FamilyID not in (Select historicfamilyID from Family)
select * from LCCHPImport..ChildFamilyLink where FamilyID not in (Select FamilyID from LCCHPImport..Families)



select 'comparing persontofamily row count to childfamilylink row count';
  select count(*) from PersontoFamily
  select count(*) from LCCHPImport..ChildFamilyLink
