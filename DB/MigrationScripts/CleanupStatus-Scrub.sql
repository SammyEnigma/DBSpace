-- Scrub CleanupStatus


select * from CleanupStatus

Update CleanupStatus set StartDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,StartDate))),
                         CompDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,CompDate)))       

select * from CleanupStatus

                  