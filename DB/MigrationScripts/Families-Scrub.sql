-- Scrub Families


select * from Families

                  
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

select @PhoneNum = RTRIM(convert(char,@3Num)) + '-' + convert(char,@4Num)



update Families set P1FirstName = 'John',
                    P1LastName = 'Doe',
					P2FirstName = 'Jane',
                    P2LastName = 'Dear',
					OFirstName = 'John',
                    OLastName = 'Henry',
					HomePhone = @PhoneNum, WorkPhone = @PhoneNum,
					MailingAddr1 = '123 someplace', MailingAddr2 = '456 No place',
					MailingCity = 'NorthPole', MailingZip = '12345'

select * from Families



                  