-- Procedure to generate random family insertion data

/* 
		@FamilyLastName = N'Agnew',
		@StreetNum = N'1600',
		@StreetName = N'Pennsylvania',
		@StreetSuff = N'Avenue',
		@ApartmentNum = NULL,
		@CityName = N'Washington',
		@StateAbbr = N'DC',
		@ZipCode = N'20500',
		@HomePhone = 2028789452,
		@WorkPhone = 2028788937,
		@Language = 1,
		@NumSmokers = 0,
		@Pets = 2,
		@inandout = 1,
		@OtherNotes = NULL,
		@FamilyID = @FamilyID OUTPUT
*/
DECLARE @FLN VARCHAR(50), @SN VARCHAR(15), @SNa VARCHAR(50), @SS VARCHAR(20)
		, @AN VARCHAR(10), @CN VARCHAR(50), @SA CHAR(2), @ZC VARCHAR(10)
		, @HP bigint, @WP bigint, @L tinyint, @NS tinyint, @P bit
		, @IO bit, @ON VARCHAR(3000), @FID int


--- Generate a random family last name
select @FLN = LastName  from names..Lastname WHERE LastNameID = (select cast(floor((rand() * 10000)) as int) % max(LastNameID) From Names..LastName)

-- Generate random street number
select @SN = cast(floor((rand() * 100000)) as int)


-- Generate random street suffix
select @SS = StreetSuffixName from names..StreetSuffix where StreetSuffixID = ( select cast(floor(rand() * max(streetSuffixID) * 100) as int) % max(StreetSuffixID) From Names..StreetSuffix)

select @FLN, @SN, @SNa, @SS