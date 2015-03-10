-- Scrub ConfidentialNotes


select * from ConfidentialNotes

update ConfidentialNotes set ChildNotes = substring(CONVERT(varchar(255), NEWID()),1,200)
                         

select * from ConfidentialNotes


