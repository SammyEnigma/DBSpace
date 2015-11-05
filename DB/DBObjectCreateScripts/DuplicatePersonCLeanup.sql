/*
DECLARE @PersonID1 int, @PersonID2 int, @PersonID3 int, @PersonID4 int;
SET @PersonID1 = 3023;
SET @PersonID2 = 4732;
SET @PersonID3 = 4732;
SET @PersonID4 = 4732;

select * from person where personID in (@PersonID1,@PersonID2,@PersonID3, @PersonID4);
select * from persontoFamily where PersonID in (@PersonID1, @PersonID2, @PersonID3, @PersonID4)
select * from BloodTestResults where PersonID in (@PersonID1, @PersonID2, @PersonID3, @PersonID4)
select * from Questionnaire where PersonID in (@PersonID1, @PersonID2, @PersonID3, @PersonID4)


update Questionnaire set personID = @PersonID1 where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
update BloodTestResults set personID = @PersonID1 where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
update PersonHobbyNotes set PersonID = @PersonID1  where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
update PersonNotes set PersonID = @PersonID1  where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
update PersontoEthnicity set PersonID = @PersonID1  where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
update PersontoFamily set PersonID = @PersonID1  where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
--update PersontoLanguage set PersonID = @PersonID1  where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4
delete from persontoLanguage where personID in (@PersonID2,@PersonID3,@PersonID4)
Delete from Person where PersonID = @PersonID2 or PersonID = @PersonID3 or PersonID = @PersonID4


select * from persontoFamily where PersonID in (@PersonID1, @PersonID2, @PersonID3)
select * from BloodTestResults where PersonID in (@PersonID1, @PersonID2, @PersonID3)
select * from Questionnaire where PersonID in (@PersonID1, @PersonID2, @PersonID3)


select * from PersontoLanguage where personID = 4716 or PersonID = 4715
Delete from PersontoLanguage where PersonID = 4716
*/