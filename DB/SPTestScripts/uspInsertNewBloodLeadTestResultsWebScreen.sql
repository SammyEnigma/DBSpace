USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@Blood_Test_Results_ID int

EXEC	@return_value = [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]
		@Person_ID = 4410,
		@Sample_Date = '20150123',
		@Lab_Date = '20150123',
		@Blood_Lead_Result = 6.8,
		@Flag = NULL,
		@Test_Type = 8,
		@Lab = NULL,
		@Lab_ID = 21,
		@Child_Status_Code = 6,
		@Hemoglobin_Value = 10.5,
		@DEBUG = 1,
		@Blood_Test_Results_ID = @Blood_Test_Results_ID OUTPUT

SELECT	@Blood_Test_Results_ID as N'@Blood_Test_Results_ID'

SELECT	'Return Value' = @return_value

GO

select [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[Age],[TS].[StatusName] from [PersonToStatus] AS [P2S]
JOIN [Person] AS [P] ON [P2S].[PersonID] = [P].[PersonID]
JOIN [TargetStatus] AS [TS] on [P2S].[StatusID] = [TS].[StatusID]

--[dbo].[usp_InsertPersontoStatus] @PersonID = 4410, @StatusID = 6
