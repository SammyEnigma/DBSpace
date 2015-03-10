Set Statistics IO ON
Set Statistics TIME ON

-- select * from BloodTestResults as BTR order by BloodTestResultsID desc
DECLARE @MinLeadValue numeric(9,4);

SET @MinLeadValue = 28.0;

--Select P.LastName,P.FirstName,P.PersonID,BTR.LeadValue, BTR.SampleDate,BTR.HemoglobinValue,BTR.CreatedDate
--	,BTR.ModifiedDate,BTR.BloodTestResultsID
--	 from Person AS P
--  LEFT OUTER JOIN BloodTestResults AS BTR
--	ON 
--	P.PersonID = BTR.PersonID
--	AND BTR.BloodTestResultsID in
--		(Select BTR.BloodTestResultsID from Person AS P
--			JOIN BloodTestResults AS BTR on BTR.BloodTestResultsID in (
--			select top 1 BloodTestResultsID from BloodTestResults 
--			where LeadValue > @MinLeadValue
--			AND BloodTestResults.PersonID = P.PersonID
--) 
--		)
--		Order BY BTR.SampleDate desc

Select P.LastName,P.FirstName,P.PersonID,BTR.LeadValue, BTR.SampleDate,BTR.HemoglobinValue,BTR.CreatedDate
		,BTR.ModifiedDate,BTR.BloodTestResultsID from Person AS P
JOIN BloodTestResults AS BTR on BTR.BloodTestResultsID = (
			select top 1 BloodTestResultsID from BloodTestResults 
			where LeadValue > @MinLeadValue
			AND BloodTestResults.PersonID = P.PersonID
) 
ORDER BY BTR.SampleDate desc

select BloodTestResultsID,SampleDate,PersonID from BloodTestResults where LeadValue > @MinLeadValue
ORDER BY SampleDate desc