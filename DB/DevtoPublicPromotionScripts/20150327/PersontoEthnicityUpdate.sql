select * from PersontoEthnicity


select * into TempPersontoEthnicity from PersontoEthnicity

truncate table PersontoEthnicity

alter table PersonToEthnicity add PersontoEthnicityID int Identity(1,1) NOT NULL

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the person to ethnicity' , 
@level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEthnicity', @level2type=N'COLUMN',@level2name=N'PersontoEthnicityID'
GO

insert into PersontoEthnicity (PersonID,EthnicityID) ( Select PersonID,EthnicityID from TempPersontoEthnicity)

Select * from PersontoEthnicity