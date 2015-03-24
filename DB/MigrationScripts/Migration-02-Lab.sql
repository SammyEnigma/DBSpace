/****** Script for SelectTopNRows command from SSMS  ******/
   use LCCHPTestImport
   GO

 select distinct(UPPER(LabName)) from TESTAccessImport..BloodPbResults order by UPPER(LabName)


 insert into Lab (LabName)
	Select distinct NewLabName = case  LabName
									WHEN 'Tama' THEN 'Tamarac'
									WHEN 'TAMAR' THEN 'Tamarac'
									WHEN 'RMFP LEAD' THEN 'RMFP'
									WHEN 'RMFP LEADVILLE' THEN 'RMFP'
									WHEN 'RMFPLEADVILL' THEN 'RMFP'
									WHEN 'RMFPLEADVILLE' THEN 'RMFP'
									WHEN 'QUEST' THEN 'Quest Diagnostic'
									WHEN 'Leadare2' THEN 'LeadCare II'
									WHEN 'LeadCae2' THEN 'LeadCare II'
									WHEN 'LeadCara2' THEN 'LeadCare II'
									WHEN 'LEADCARE' THEN 'LeadCare II'
									WHEN 'LeadCare2' THEN 'LeadCare II'
									ELSE LabName
								END
							from TESTAccessImport..BloodPbResults
select * from Lab

-- remove tamarac dependencies
update BloodTestResults set labID = 1 where LabID in (Select LabID From Lab where LabName = 'Tamarac')
update BloodTestResults set labID = 21 where LabID in (Select LabID From Lab where LabName = 'LeadCare II')
update BloodTestResults set labID = 1253 where LabID in (Select LabID From Lab where LabName = 'Quest Diagnostic')
update BloodTestResults set labID = 1946 where LabID in (Select LabID From Lab where LabName = 'Lead Tech')
update BloodTestResults set labID = 1947 where LabID in (Select LabID From Lab where LabName = 'Mayo Lab')
update BloodTestResults set labID = 2242 where LabID in (Select LabID From Lab where LabName = 'DONE AT CLINIC')
update BloodTestResults set labID = 5076 where LabID in (Select LabID From Lab where LabName = 'EVMC')
update BloodTestResults set labID = 5302 where LabID in (Select LabID From Lab where LabName = 'RMFP')
update MediumSampleResults set labID = 1 where LabID in (Select LabID From Lab where LabName = 'Tamarac')
update MediumSampleResults set labID = 21 where LabID in (Select LabID From Lab where LabName = 'LeadCare II')
update MediumSampleResults set labID = 1253 where LabID in (Select LabID From Lab where LabName = 'Quest Diagnostic')
update MediumSampleResults set labID = 1946 where LabID in (Select LabID From Lab where LabName = 'Lead Tech')
update MediumSampleResults set labID = 1947 where LabID in (Select LabID From Lab where LabName = 'Mayo Lab')
update MediumSampleResults set labID = 2242 where LabID in (Select LabID From Lab where LabName = 'DONE AT CLINIC')
update MediumSampleResults set labID = 5076 where LabID in (Select LabID From Lab where LabName = 'EVMC')
update MediumSampleResults set labID = 5302 where LabID in (Select LabID From Lab where LabName = 'RMFP')
update LabNotes set LabID = 1253 where LabID in (Select LabID from Lab where LabName = 'Quest Diagnostic')

-- delete rows
delete from Lab where LabName = 'Tamarac' and LabID <> 1
delete from Lab where Labname = 'LeadCare II' and LabID <> 21
delete from Lab where LabName = 'Quest Diagnostic' and LabID <> 1253
delete from Lab where Labname = 'Lead Tech' and LabID <> 1946
delete from Lab where Labname = 'Mayo Lab' and LabID <> 1947
delete from Lab where Labname = 'DONE AT CLINIC' and LabID <> 2442
delete from Lab where Labname = 'EVMC' and LabID <> 5076
delete from Lab where Labname = 'RMFP' and LabID <> 5302


Select Lab.LabName,LN.* from LabNotes AS LN
JOIN Lab on LN.LabID = Lab.LabID
where LN.LabID in (Select LabID From Lab where LabName = 'Quest Diagnostic')

Select Lab.LabName,MSR.* from MediumSampleResults AS MSR
JOIN Lab on MSR.LabID = Lab.LabID
where MSR.LabID in (Select LabID From Lab where LabName = 'Tamarac')


Select Lab.LabName,BTR.LabID from BloodTestResults AS BTR
JOIN Lab on BTR.LabID = Lab.LabID
where BTR.LabID in (Select LabID From Lab where LabName = 'Tamarac')

select * from Lab order by LabID

