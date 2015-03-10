
exec usp_SlPeopleCountByAge -- 'Bonifacic'
GO

select count(BirthDate) from person


select BirthDate,PersonCOde,* from person as P
 where BirthDate is null or PersonCode in ('10576','10577')
order by P.BirthDate

select * from Person where BirthDate is Null and PersonCode not in ('10576','10577')

Select * from Person where BirthDate is not null and PersonCode not in ('10576','10577')

select * from TESTAccessImport..Questionnaires where ChildId in  ('10576','10577')



