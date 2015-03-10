select * from Status

Select * from source

select * from sampleType

Select ActionStatusCode,ActionStatus,T = 'ActionStatus' from TESTAccessImport..lkActionStatus
UNION
Select ChildStatusCode,ChildStatus,T = 'ChildStatus' from TESTAccessImport..lkChildStatus
UNION
Select CleanupStatusCode,CleanupStatus,T = 'CleanupStatus' from TESTAccessImport..lkCleanupStatus
UNION
Select ReviewStatusCode,ReviewStatus,T = 'ReviewStatus' from TESTAccessImport..lkDataReview
UNION
-- Select * from TESTAccessImport..Families
select ReleaseCode,ReleaseStatus,T = 'ReleaseStatus' from TESTAccessImport..lkReleaseStatus

select * from Status

alter table Status add TargetType varchar(50) NOT NULL

