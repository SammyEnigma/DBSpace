USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewSampleLevelCategoryID int

EXEC	@return_value = [dbo].[usp_InsertSampleLevelCategory]
		@SampleLevelCategoryName = N'Low',
		@SampleLevelCategoryDescription = N'levels below normal acceptable ranges',
		@NewSampleLevelCategoryID = @NewSampleLevelCategoryID OUTPUT

SELECT	@NewSampleLevelCategoryID as N'@NewSampleLevelCategoryID'

SELECT	'Return Value' = @return_value

GO
