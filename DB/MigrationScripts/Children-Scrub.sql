-- Scrub Children

select * from Children

update Children set Lastname = substring(CONVERT(varchar(255), NEWID()),1,10),
                    FirstName = substring(CONVERT(varchar(255), NEWID()),1,10),
					BirthDate = DATEADD(DD,3,DATEADD(YY,-4,DATEADD(mm,4,BirthDate))),
					ChildNotes = substring(CONVERT(varchar(255), NEWID()),1,200)

select * from Children