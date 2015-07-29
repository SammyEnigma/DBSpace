select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid from [2015] 
where isNumeric(LeadValue) = 0
UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid from [2014] 
where isNumeric(LeadValue) = 0
UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid from [2013] 
where isNumeric(LeadValue) = 0
UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid from [2012] 
where isNumeric(LeadValue) = 0
UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid from [2012Sheet2] 
where isNumeric(LeadValue) = 0

-- Clean up < 3.3 lead values to -3.3
update [2015] set LeadValue = '-3.3' where LeadValue = '<3.3'
update [2014] set LeadValue = '-3.3' where LeadValue = '<3.3'
update [2013] set LeadValue = '-3.3' where LeadValue = '<3.3'
update [2012] set LeadValue = '-3.3' where LeadValue = '<3.3'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<3.3'

update [2015] set LeadValue = '-3.3' where LeadValue = '< 3.3'
update [2014] set LeadValue = '-3.3' where LeadValue = '< 3.3'
update [2013] set LeadValue = '-3.3' where LeadValue = '< 3.3'
update [2012] set LeadValue = '-3.3' where LeadValue = '< 3.3'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '< 3.3'

update [2015] set LeadValue = '-3.3' where LeadValue = '<3,3'
update [2014] set LeadValue = '-3.3' where LeadValue = '<3,3'
update [2013] set LeadValue = '-3.3' where LeadValue = '<3,3'
update [2012] set LeadValue = '-3.3' where LeadValue = '<3,3'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<3,3'

update [2015] set LeadValue = '-3.3' where LeadValue = '<3.'
update [2014] set LeadValue = '-3.3' where LeadValue = '<3.'
update [2013] set LeadValue = '-3.3' where LeadValue = '<3.'
update [2012] set LeadValue = '-3.3' where LeadValue = '<3.'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<3.'

update [2015] set LeadValue = '-3.3' where LeadValue = '<3..3'
update [2014] set LeadValue = '-3.3' where LeadValue = '<3..3'
update [2013] set LeadValue = '-3.3' where LeadValue = '<3..3'
update [2012] set LeadValue = '-3.3' where LeadValue = '<3..3'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<3..3'

update [2015] set LeadValue = '-3.3' where LeadValue = '<3.3.'
update [2014] set LeadValue = '-3.3' where LeadValue = '<3.3.'
update [2013] set LeadValue = '-3.3' where LeadValue = '<3.3.'
update [2012] set LeadValue = '-3.3' where LeadValue = '<3.3.'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<3.3.'

update [2015] set LeadValue = '-3.3' where LeadValue = '<33.'
update [2014] set LeadValue = '-3.3' where LeadValue = '<33.'
update [2013] set LeadValue = '-3.3' where LeadValue = '<33.'
update [2012] set LeadValue = '-3.3' where LeadValue = '<33.'
update [2012Sheet2] set LeadValue = '-3.3' where LeadValue = '<33.'


update [2015] set LeadValue = '-1.0' where LeadValue = '<1.0'
update [2014] set LeadValue = '-1.0' where LeadValue = '<1.0'
update [2013] set LeadValue = '-1.0' where LeadValue = '<1.0'
update [2012] set LeadValue = '-1.0' where LeadValue = '<1.0'
update [2012Sheet2] set LeadValue = '-1.0' where LeadValue = '<1.0'
