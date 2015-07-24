use LCCHPTestImport
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

-- select distinct phone numbers into phone numbers table
insert into PHoneNumber (PhoneNumber)
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.HomePhone)
FROM testAccessImport..Families AS F
WHERE HomePHone is not null 
UNION
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.WorkPhone)
FROM testAccessImport..Families AS F
WHERE WorkPHone is not null
order by phone

-- ~ 30 seconds
-- insert phone number types with phone numbers
update PHoneNumber set PhoneNumberTypeID = PNT.PhoneNumberTypeID
FROM testAccessImport..Families AS F
JOIN PHoneNumberType AS PNT on F.PhoneCode = PNT.HistoricPhoneCode
JOIN PhoneNumber AS PH on
	[dbo].[fnRemoveNonNumericCharacters](F.HomePhone) = PH.PhoneNumber
WHERE F.HomePHone is not null  

-- ~ 1 second
update PHoneNumber set PhoneNumberTypeID = PNT.PhoneNumberTypeID
FROM testAccessImport..Families AS F
JOIN PHoneNumberType AS PNT on F.PhoneCode = PNT.HistoricPhoneCode
JOIN PhoneNumber AS PH on 
	[dbo].[fnRemoveNonNumericCharacters](F.WorkPhone) = PH.PhoneNumber
WHERE PH.PhoneNumberTypeID is null and F.WorkPHone is not null
GO

select count(*) from phonenumber
select count(*) from
(
Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.HomePhone)
	FROM testAccessImport..Families AS F
	WHERE HomePHone is not null 
	UNION
	Select distinct PHONE = [dbo].[fnRemoveNonNumericCharacters](F.WorkPhone)
	FROM testAccessImport..Families AS F
	WHERE WorkPHone is not null
) as ExistingPHone

DROP Function [fnRemoveNonNumericCharacters]
GO


