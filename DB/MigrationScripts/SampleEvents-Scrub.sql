-- Scrub SampleEvent


select * from SampleEvents

update SampleEvents set SampleDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,SampleDate)))
       

select * from SampleEvents

                  