Select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant
into BloodLeadSheet
FROM
(select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant from [2015] 

UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant from [2014] 

UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant from [2013] 

UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant from [2012] 

UNION
select PersonID,LastName,BirthDate,SampleDate,LeadValue,TamaracLeadValue,HemoglobinValue,NewClient,HomeVisitSoilSample,RetestHomeorSoil,RetestPb,RetestHb,Moved,[Closed],NameChange,MexicanCandy,TestH20,Resolved,Medicaid,Nursing,Pregnant from [2012Sheet2] 
) AS P