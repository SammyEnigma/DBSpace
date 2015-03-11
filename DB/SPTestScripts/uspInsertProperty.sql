USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@PropertyID int

EXEC	@return_value = [dbo].[usp_InsertProperty]
		@ConstructionTypeID = NULL,
		@AreaID = NULL,
		@isinHistoricDistrict = NULL,
		@isRemodeled = NULL,
		@RemodelDate = NULL,
		@isinCityLimits = NULL,
		@AddressLine1 = N'23 E. Maple St',
		@Apartmentnumber = NULL,
		@City = N'Leadville',
		@State = N'CO',
		@Zipcode = N'80461',
		@YearBuilt = '1974',
		@Ownerid = NULL,
		@isOwnerOccuppied = NULL,
		@ReplacedPipesFaucets = NULL,
		@TotalRemediationCosts = NULL,
		@New_PropertyNotes = N'''quaint little cottage''',
		@isResidential = 1,
		@isCurrentlyBeingRemodeled = NULL,
		@hasPeelingChippingPaint = 1,
		@County = N'Lake',
		@isRental = 1,
		@PropertyID = @PropertyID OUTPUT

SELECT	@PropertyID as N'@PropertyID'

SELECT	'Return Value' = @return_value

GO
