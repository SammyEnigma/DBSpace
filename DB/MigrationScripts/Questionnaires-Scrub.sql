-- Scrub Questionnaires


select * from Questionnaires

update Questionnaires set QuestDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,QuestDate)))
       

select * from Questionnaires

                  