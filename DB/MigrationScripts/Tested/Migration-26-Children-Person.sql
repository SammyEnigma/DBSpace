  use LCCHPPublic
  GO 
  SET NOCOUNT ON;

  -- ~ :30 seconds
  --- alter table person add ReleaseStatusID tinyint

  select 'inserting from children to person';
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
  from  LCCHPImport..Children AS C
  LEFT OUTER JOIN Ethnicity AS E ON C.EthnicCode = E.HistoricEthnicityCode
  LEFT OUTER JOIN ReleaseStatus AS R on C.ReleaseCode = R.HistoricReleaseStatusID
  LEFT OUTER JOIN ReviewStatus AS RevS on C.ReviewStatusCode = RevS.HistoricReviewStatusID
  WHERE C.CHILDID < 10576
  and C.ChildID not in (select HistoricChildID from Person)
  order by C.ChildID;

  select 'inserting release notes to personnotes';
  --- RELEASE NOTES
	  insert into PersonNotes (Notes,PersonID)
	  Select ReleaseNotes,P.PersonID from LCCHPImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.ReleaseNotes is Not NULL;

select 'inserting travel notes to personnotes';
-- TRAVEL NOTES
	  insert into PersonNotes (Notes,PersonID)
	  Select TravelNotes,P.PersonID from LCCHPImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.TravelNotes is Not NULL
	  -- Make sure all release notes are copied into PersonNotes table
	  -- Select any childids from testaccess import table without matching notes in PersonNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.TravelNotes from LCCHPImport..Children AS C where C.TravelNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonNotes AS PRN ON PRN.PersonID = P.PersonID
							);

select 'inserting child notes to personnotes'
-- CHILD NOTES
	  insert into PersonNotes (Notes,PersonID)
	  Select C.ChildNotes,P.PersonID from LCCHPImport..Children AS C
	  JOIN Person AS P on C.ChildID = P.HistoricChildID
	  where C.ChildNotes is Not NULL
	  -- Make sure all release notes are copied into PersonNotes table
	  -- Select any childids from testaccess import table without matching notes in PersonNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.TravelNotes from LCCHPImport..Children AS C where C.TravelNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonNotes AS PRN ON PRN.PersonID = P.PersonID
							);

select 'updating modified date'
-- Import modified/update date
		update P set ModifiedDate = cast(TAIC.UpdateDate as datetime2)
		-- Select PersonID,ChildID,P.HistoricChildID,cast(UpdateDate as date)
		FROM Person AS P
		JOIN LCCHPImport..Children AS TAIC ON P.HistoricChildID = TAIC.ChildID;

		
-- VALIDATION
 select 'comparing person row count to children row count';
  -- need to manually add client 10576 from Cornelia's email on  2/12/2015
  -- need to get the updated date into person table from LCCHPImport db
  select count(*) from person;
  select count(*) from LCCHPImport..Children where ChildID < 10576;

select 'looking for missing historic childIDs (expect 10576 and 10577)';
select ChildID from LCCHPImport..Children where ChildID not in (select HistoricChildID from Person)
  
select 'looking for release notes that were not added to personnotes';
	   -- Make sure all release notes are copied into PersonNotes table
	  -- Select any childids from testaccess import table without matching notes in PersonNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.ReleaseNotes from LCCHPImport..Children AS C 
	  where C.ReleaseNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonNotes AS PRN ON PRN.PersonID = P.PersonID
							);

select 'looking for travel notes that were not added to personnotes';
	   -- Make sure all travel notes are copied into PersonNotes table
	  -- Select any childids from testaccess import table without matching notes in PersonNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.ReleaseNotes from LCCHPImport..Children AS C 
	  where C.TravelNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonNotes AS PRN ON PRN.PersonID = P.PersonID
							);

select 'looking for child notes that were not added to personnotes';
	   -- Make sure all release notes are copied into PersonNotes table
	  -- Select any childids from testaccess import table without matching notes in PersonNotes table
	  -- these records need to be imported
	  select C.LastName,C.FirstName,C.ChildID,c.ReleaseNotes from LCCHPImport..Children AS C 
	  where C.ChildNotes is not null
	  AND C.CHildID NOT IN (select p.HIstoricChildID from Person AS P
								JOIN PersonNotes AS PRN ON PRN.PersonID = P.PersonID
							);

select 'comparing row count of Person to row count of Children -- should be 2 less in Person than Children -- Child ID 10576 and 10577'
select count(personID) from person
select count(ChildID) from LCCHPImport..Children

select 'ChildIDs in Children but not person - need to import 10577 manually from email from Cornelia'
select ChildID,LastName,FirstName from LCCHPImport..Children where ChildID not in (Select historicChildID from Person)