-- Scrub BloodPbResults

-- UserName
-- ActivityDate

select * from BloodPbResults

update BloodPbResults set Area = substring(CONVERT(varchar(255), NEWID()),1,1), SampleDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,SampleDate)))

SELECT substring(CONVERT(varchar(255), NEWID()),1,1)