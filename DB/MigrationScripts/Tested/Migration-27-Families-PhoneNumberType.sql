USE LCCHPPublic
GO
SET NOCOUNT ON;

select 'inserting phonenumber types';
--  Import distinct phone number types 
Insert into PhoneNumberType (HistoricPhoneCode,PhoneNumberTypeName) 
select distinct PhoneCode,
	CASE PhoneCode
		WHEN '0' THEN 'Unknown'
		WHEN 'C' THEN 'Cell Phone'
		WHEN 'H' Then 'Home Phone'
		WHEN 'M' THEN 'Mobile Phone'
		WHEN 'N' THEN 'Uknown'
		WHEN 'O' THEN 'Office'
		WHEN 'U' THEN 'Unknown'
		WHEN 'W' THEN 'Work Phone'
	END
	 from LCCHPImport..Families where PhoneCode is not null

select 'listing phone number types'
select * from PhoneNumberType



