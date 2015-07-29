select * from LCCHPImport..Questionnaires where childid = 8362
order by QuestDate

 update LCCHPImport..Questionnaires set QuestDate = '2002-08-07 00:00:00' where QuestDate = '0702-08-01 00:00:00'
select * from LCCHPImport..BloodPbResults where ChildId = 8362
order by SampleDate