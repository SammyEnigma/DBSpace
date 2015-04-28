  use LCCHPTestImport
  GO 

  --- alter table person add ReleaseStatusID tinyint

  insert into person (LastName, FirstName, BirthDate, Gender, Moved
					, HistoricChildID
					-- , EthnicityID
					, ReleaseStatusID
					, OutofSite
					, ForeignTravel
					, ReviewStatusID)
					--, ModifiedDate) 
  select C.LastName,C.FirstName,cast(C.BirthDate as Date),C.Sex,C.Moved,C.ChildID --,E.EthnicityID
	, R.ReleaseStatusID-- ,C.ChildNotes,C.TravelNotes,C.ReleaseNotes
	, C.OutofSite, C.ForeignTravel, RevS.ReviewStatusID
	--, C.UpdateDate
  from  TESTAccessImport..Children AS C
  LEFT OUTER JOIN Ethnicity AS E ON C.EthnicCode = E.HistoricEthnicityCode
  LEFT OUTER JOIN ReleaseStatus AS R on C.ReleaseCode = R.HistoricReleaseStatusID
  LEFT OUTER JOIN ReviewStatus AS RevS on C.ReviewStatusCode = RevS.HistoricReviewStatusID
  WHERE C.CHILDID < 10576
  and C.ChildID not in (select HistoricChildID from Person)
  order by C.ChildID

  -- need to manually add client 10576 from Cornelia's email on  2/12/2015
  -- need to get the updated date into person table from testaccessimport db
  select * from person
  select * from TESTAccessImport..Children order by CHildID where ChildID < 10576
  order by BirthDate
  

  Select * from TestAccessImport..Children where ChildNotes is not null

  
  --- RELEASE NOTES
	  insert into PersonReleaseNotes (Notes,PersonID)
	  Select ReleaseNotes,P.PersonID from TESTAccessImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.ReleaseNotes is Not NULL

	   -- Make sure all release notes are copied into personreleasenotes table
	  -- Select any childids from testaccess import table without matching notes in personReleaseNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.ReleaseNotes from TESTAccessImport..Children AS C where C.ReleaseNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonReleaseNotes AS PRN ON PRN.PersonID = P.PersonID
							)

	-- Select any child notes in personreleasenotes that don't exist in the testaccesimport database
	-- these are additional notes and should be removed
	select p.HIstoricChildID from Person AS P JOIN PersonReleaseNotes AS PRN ON PRN.PersonID = P.PersonID
		Where P.HistoricChildID not in (Select ChildID from TESTAccessImport..Children where ReleaseNotes is not null)



-- TRAVEL NOTES
	  insert into PersonTravelNotes (Notes,PersonID)
	  Select TravelNotes,P.PersonID from TESTAccessImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.TravelNotes is Not NULL
	  -- Make sure all release notes are copied into personTravelNotes table
	  -- Select any childids from testaccess import table without matching notes in personTravelNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.TravelNotes from TESTAccessImport..Children AS C where C.TravelNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonTravelNotes AS PRN ON PRN.PersonID = P.PersonID
							)
	-- Select any child notes in personTravelNotes that don't exist in the testaccesimport database
	-- these are additional notes and should be removed
	select p.HIstoricChildID,PRN.* from Person AS P JOIN PersonTravelNotes AS PRN ON PRN.PersonID = P.PersonID
		Where P.HistoricChildID not in (Select ChildID from TESTAccessImport..Children where TravelNotes is not null)


-- CHILD NOTES
	  insert into PersonNotes (Notes,PersonID)
	  Select C.ChildNotes,P.PersonID from TESTAccessImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.ChildNotes is Not NULL
	  -- Make sure all release notes are copied into personTravelNotes table
	  -- Select any childids from testaccess import table without matching notes in personTravelNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.TravelNotes from TESTAccessImport..Children AS C where C.TravelNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonTravelNotes AS PRN ON PRN.PersonID = P.PersonID
							)
	-- Select any child notes in personTravelNotes that don't exist in the testaccesimport database
	-- these are additional notes and should be removed
	select p.HIstoricChildID,PRN.* from Person AS P JOIN PersonTravelNotes AS PRN ON PRN.PersonID = P.PersonID
		Where P.HistoricChildID not in (Select ChildID from TESTAccessImport..Children where TravelNotes is not null)


	select updateDate,ChildID from TESTAccessImport..Children order by UpdateDate
		

-- Import modified/update date
		update P set ModifiedDate = cast(TAIC.UpdateDate as date)
		-- Select PersonID,ChildID,P.HistoricChildID,cast(UpdateDate as date)
		FROM Person AS P
		JOIN TestAccessImport..Children AS TAIC ON P.HistoricChildID = TAIC.ChildID

		
		