--select * from Families where Addres
select * from lcchppublic..person
select * from TestaccessImport..Families
select * from TestaccessImport..lkPrimLanguage

-- select person/parent information from family tables to add to person
select P1FirstName,P1LastName,PrimLanguageCode
--, ReviewStatusCode
 from TESTAccessImport..Families
 where P1FirstName is not NULL

-- select parent 2 information to add to person
select P2FirstName,P2LastName,PrimLanguageCode
--, ReviewStatusCode
 from TESTAccessImport..Families
 where P2FirstName is not NULL


 -- select other name information to add to person
 select OFirstName,OLastName
 from TESTAccessImport..Families
 where OFirstName is not NULL

 -- P1 with same name as another person in the db
 select FamilyID,P1FirstName,P1LastName,PrimLanguageCode, P1SameName
--, ReviewStatusCode
 from TESTAccessImport..Families
 where P1FirstName is not NULL
and P1SameName <> 0
order by P1FirstName,P1LastName


 -- Add mailing address 1 to property including addressline 2 for apt #s
 select MailingAddr1,AddressLine2 = Case
								WHEN Len(MailingAddr2) < 10 THEN MailingAddr2
								END
 From TestAccessImport..Families
 where MailingAddr1 is not null
 

 -- Add mailing address 2 to properties
 select MailingAddr2
 -- ,Len(MailingAddr2)
 From TESTAccessImport..Families
 where MailingAddr2 is not null
 and Len (MailingAddr2) > 10
 

-- owner address Needs to be cleaned up to be added to properties
select PropertyID
		, OwnerAddress1
		, OwnerAddress2
		, OwnerAddress3
		, OwnerAddress4
		, OwnerState
		, OwnerZipCode
from TESTAccessImport..Properties
where OwnerAddress1 is not null or OwnerAddress2 is not null or OwnerAddress3 is not null
-- or OwnerAddress4 is not null

-- owner name to add to person table
select ownerFName,OwnerLName,ownerName 
from TESTAccessImport..Properties
where ownerName is not null


