USE [LCCHPDEV]


EXEC sp_rename 'Property.Street', 'AddressLine1';
GO

alter table Property alter column AddressLine1 VarChar(100)

