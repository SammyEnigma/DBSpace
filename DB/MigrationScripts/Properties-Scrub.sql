-- Scrub Properties


select * from Properties

---- Create the variables for the random number generation
DECLARE @Random INT;
DECLARE @3Upper INT, @4Upper INT, @3Num INT, @4Num INT;
DECLARE @3Lower INT, @4Lower INT
DECLARE @PHoneNum Char(8)
---- This will create a random number between 1 and 999
SET @3Lower = 100 ---- The lowest random number
SET @4Lower = 1000 
SET @3Upper = 999 ---- The highest random number
SET @4Upper = 9999 ---- The highest random number
SELECT @3Num = ROUND(((@3Upper - @3Lower -1) * RAND() + @3Lower), 0)
SELECT @4Num = ROUND(((@4Upper - @4Lower -1) * RAND() + @4Lower), 0)

---- Create the variables for the random number generation
DECLARE @Upper INT
DECLARE @Lower INT
DECLARE @StreetNum INT
---- This will create a random number between 1 and 999
SET @Lower = 1 ---- The lowest random number
SET @Upper = 9999 ---- The highest random number
SELECT @StreetNum = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
SELECT @StreetNum


update Properties set OwnerFName = 'John',
                    OwnerLName = 'Doe',
					OwnerAddress1 = '123 someplace', OwnerAddress2 = '456 No place',
					OwnerAddress3 = '789 oneplace', OwnerAddress4 = '148 that place',
					OwnerNotes = substring(CONVERT(varchar(255), NEWID()),1,200), OwnerZipCode = '78934',
					OwnerPhone = @PHoneNum, PropertyAddress = '982 wherever', 
					OwnerName = substring(CONVERT(varchar(255), NEWID()),1,20)

select * from Properties


                  