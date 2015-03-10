-- Scrub activityLog

-- UserName
-- ActivityDate

select * from activityLog

update activityLog set UserName = 'SecretUser', ActivityDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,ActivityDate)))
