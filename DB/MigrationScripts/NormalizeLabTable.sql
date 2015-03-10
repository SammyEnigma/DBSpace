select distinct(labname) from Lab
order by LabName

update Lab Set LabName = 'LeadCare II' where LabName in ('Leadare2', 'LeadCae2','LeadCara2','LeadCare','LeadCare2')

update Lab set LabName = 'Tamarac' where LabName in ('Tamar','Tama')

update Lab Set LabName = 'RMFP' where LabName in ('RMFP LEAD','RMFPLeadvill','RMFPLeadville', 'RMFP Leadville')

update Lab set LabName = 'Quest Diagnostic' where LabName in ('QUEST','Labcore','LAB CORP')

GO

select distinct(labname) from Lab
order by LabName