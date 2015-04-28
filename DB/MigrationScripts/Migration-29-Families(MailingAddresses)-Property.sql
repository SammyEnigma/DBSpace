  Insert into Property (AddressLine1,City,State,Zipcode)
  select distinct MailingAddr1,MailingCity,MailingState,mailingZip
  FROM TESTAccessImport..Families as FAM
where FAM.MailingAddr1 is not null
and MailingAddr1 not in (Select AddressLine1 from LCCHPTestImport..property)



--- NEED TO check if mailingAddr2 is an apartment number or something
  Insert into Property (AddressLine1,City,State,Zipcode)
  select distinct MailingAddr2,MailingCity,MailingState,mailingZip			
  FROM TESTAccessImport..Families as FAM
where FAM.MailingAddr2 is not null
and MailingAddr2 not in (Select AddressLine1 from LCCHPTestImport..property)



-- identify mailing addresses added and update the family property link and link type
update F2P Set PropertyLinkTypeID = (select PropertyLinkTypeID from PropertyLinkType where PropertyLinkTypeName = 'Mailing Address')


SELECT F2p.FamilytoPropertyId,F2P.PropertyID,F2p.FamilyID,F2P.PropertyLinkTypeID,*
from TESTAccessImport..Families AS F
LEFT OUTER JOIN Property AS P on F.MailingAddr1 = P.AddressLine1
LEFT OUTER JOIN FamilytoProperty AS F2P on F.FamilyID = F2P.FamilyID and P.PropertyID = F2P.PropertyID
-- LEFT OUTER JOIN PropertyLinkType AS PLT on 
where F.MailingAddr1 is not null 

