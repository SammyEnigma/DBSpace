Use LCCHPPublic
GO
SET NOCOUNT ON;
GO

CREATE Function [fnRemoveNonNumericCharacters](@strText VARCHAR(1000))
RETURNS VARCHAR(1000)
AS
BEGIN
    WHILE PATINDEX('%[^0-9]%', @strText) > 0
    BEGIN
        SET @strText = STUFF(@strText, PATINDEX('%[^0-9]%', @strText), 1, '')
    END
    RETURN @strText
END
GO

select 'inserting phonenumbers from families'
-- select distinct phone numbers into phone numbers table
insert into PHoneNumber (PhoneNumber)
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.HomePhone)
FROM LCCHPImport..Families AS F
WHERE HomePHone is not null 
UNION
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.WorkPhone)
FROM LCCHPImport..Families AS F
WHERE WorkPHone is not null
order by phone;

select 'inserting phonenumber types'
-- ~ 30 seconds
-- insert phone number types with phone numbers
update PHoneNumber set PhoneNumberTypeID = PNT.PhoneNumberTypeID
FROM LCCHPImport..Families AS F
JOIN PHoneNumberType AS PNT on F.PhoneCode = PNT.HistoricPhoneCode
JOIN PhoneNumber AS PH on
	[dbo].[fnRemoveNonNumericCharacters](F.HomePhone) = PH.PhoneNumber
WHERE F.HomePHone is not null;

select 'updating phonenumber types';
-- ~ 1 second
update PHoneNumber set PhoneNumberTypeID = PNT.PhoneNumberTypeID
FROM LCCHPImport..Families AS F
JOIN PHoneNumberType AS PNT on F.PhoneCode = PNT.HistoricPhoneCode
JOIN PhoneNumber AS PH on 
	[dbo].[fnRemoveNonNumericCharacters](F.WorkPhone) = PH.PhoneNumber
WHERE PH.PhoneNumberTypeID is null and F.WorkPHone is not null;
GO

select 'comparing counts of phonenumbers to count of distinct phonenumbers in the families table';
select count(*) from phonenumber
select count(*) from
(
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.HomePhone)
	FROM LCCHPImport..Families AS F
	WHERE HomePHone is not null 
	UNION
	Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.WorkPhone)
	FROM LCCHPImport..Families AS F
	WHERE WorkPHone is not null
) as ExistingPHone;

DROP Function [fnRemoveNonNumericCharacters]
GO


