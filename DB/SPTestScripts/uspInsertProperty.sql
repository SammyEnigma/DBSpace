USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@PropertyID int

EXEC	@return_value = [dbo].[usp_InsertProperty]
		@ConstructionTypeID = NULL,
		@AreaID = 1,
		@isinHistoricDistrict = 1,
		@isRemodeled = 1,
		@RemodelDate = '20120501',
		@isinCityLimits = 1,
		@AddressLine1 = N'12 W. Main St',
		@AddressLine2 = N'Apt 2',
		@City = N'Leadville',
		@State = N'CO',
		@Zipcode = N'80461',
		@YearBuilt = '1918',
		@Ownerid = 2772,
		@isOwnerOccuppied = 1,
		@ReplacedPipesFaucets = 1,
		@TotalRemediationCosts = NULL,
		@New_PropertyNotes = NULL,
		@isResidential = 1,
		@isCurrentlyBeingRemodeled = 0,
		@hasPeelingChippingPaint = 0,
		@County = N'Lake',
		@isRental = 0,
		@OverRideDuplicate = 0,
		@PropertyID = @PropertyID OUTPUT

SELECT	@PropertyID as N'@PropertyID'

SELECT	'Return Value' = @return_value

GO
