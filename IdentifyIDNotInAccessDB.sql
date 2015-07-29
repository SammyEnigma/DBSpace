use master
GO

Declare @ID int;

SET @ID = 10627

select * from [LCCHPImportAccess]..Children where childid = @ID  
select * from [LCCHPImport2015Excel]..BloodLeadSheet where  PersonID = @ID
 
 -- PersonID in (10854,10856,10858,10866,10871,10881,10885,10888,10894,10895,10925,10926,11002,11059,11070,11072

 -- update BloodLeadSheet set LastName = 'Barela, Khloe' where PersonID = 10715