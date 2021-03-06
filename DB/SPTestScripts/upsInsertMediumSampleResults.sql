USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewMediumSampleResultsID int

EXEC	@return_value = [dbo].[usp_InsertMediumSampleResults]
		@MediumID = 5,
		@MediumSampleValue = 15.1,
		@UnitsID = 7,
		@SampleLevelCategoryID = 1,
		@MediumSampleDate = '20141110',
		@LabID = 12,
		@LabSubmissionDate = '20141112',
		@Notes = NULL,
		@IsAboveTriggerLevel = NULL,
		@NewMediumSampleResultsID = @NewMediumSampleResultsID OUTPUT

SELECT	@NewMediumSampleResultsID as N'@NewMediumSampleResultsID'

SELECT	'Return Value' = @return_value

GO
Select M.MediumName, MSR.MediumSampleValue, U.Units,
		M.TriggerLevel, TriggerLevelUnits = TLU.Units
		, SLC.SampleLevelCategoryName,MSR.MediumSampleDate, MSR.LabSubmissionDate,MSR.IsAboveTriggerLevel
	, L.LabName
from MediumSampleresults as MSR
LEFT OUTER JOIN SampleLevelCategory as SLC on MSR.SampleLevelCategoryID = SLC.SampleLevelCategoryID
JOIN Lab as L on MSR.LabID = L.LabID
JOIN Medium AS M on MSR.MediumID = M.MediumID
LEFT OUTER JOIN Units AS U on MSR.UnitsID = U.UnitsID
LEFT OUTER JOIN Units AS TLU on M.TriggerLevelUnitsID = TLU.UnitsID

