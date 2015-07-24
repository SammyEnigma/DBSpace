use LCCHPTestImport
GO

  insert into PersontoFamily (PersonID,FamilyID,StartDate,EndDate,PrimaryContactFamily,ReviewStatusID)
	  select P.PersonID, Fam.familyID,CFL.CFLinkStartDate,CFL.CFLinkEndDate,cast(CFL.PrimaryLink as bit),RS.ReviewStatusID
	  from TESTAccessImport..ChildFamilyLink as CFL
	  LEFT OUTER join Person as P on CFL.ChildID = P.HistoricChildID
	  LEFT OUTER join Family as Fam on CFL.FamilyID = Fam.HistoricFamilyID 
	  LEFT OUTER JOIN ReviewStatus AS RS on CFL.ReviewStatusCode = RS.HistoricReviewStatusID
	  where CFL.ChildID is not null and CFL.FamilyID is not null

  select count(*) from PersontoFamily
  select count(*) from TESTAccessImport..ChildFamilyLink
