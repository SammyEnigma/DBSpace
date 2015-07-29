--- migrate people
/*  
	PersonID -> HIstoricPersonID
	LastName -> broken up to first and last
	BirthDate -> BirthDate
	RetestPb or RetestHome -> RetestDate
	Pregnant -> Pregnant
	Nursing -> NursingInfant
	Moved -> Moved
	Closed -> isClosed
	resolved -> isResolved
*/


Select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved INTO Person
FROM
(select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved from [2015] 

UNION
select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved from [2014] 

UNION
select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved from [2013] 

UNION
select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved from [2012] 

UNION
select PersonID,LastName,BirthDate,Moved,[Closed],NameChange,Resolved from [2012Sheet2] 
) AS P
