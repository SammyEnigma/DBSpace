USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertFamilytoPhoneNumber]
		@FamilyID = 2782,
		@PhoneNumberID = 42,
		@NumberPriority = 2

SELECT	'Return Value' = @return_value

GO
select * from familytoPhoneNumber

select * from Family order by familyID desc
Select * from PhoneNumber order by PhonenumberID desc