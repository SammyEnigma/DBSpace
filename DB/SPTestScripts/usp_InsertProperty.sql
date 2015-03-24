USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@PropertyID int

EXEC	@return_value = [dbo].[usp_InsertProperty]
		@ConstructionTypeID = NULL,
		@AreaID = NULL,
		@isinHistoricDistrict = 1,
		@isRemodeled = 1,
		@RemodelDate = '20120525',
		@isinCityLimits = 1,
		@AddressLine1 = N'128 W. 8th St.',
		@City = N'Leadville',
		@State = N'CO',
		@Zipcode = N'80461',
		@YearBuilt = '1901',
		@Ownerid = 1286,
		@isOwnerOccuppied = 1,
		@ReplacedPipesFaucets = 1,
		@TotalRemediationCosts = NULL,
		@New_PropertyNotes = N'replaced all lead plumbing and repainted',
		@isResidential = 1,
		@isCurrentlyBeingRemodeled = 0,
		@hasPeelingChippingPaint = 0,
		@County = N'Lake',
		@isRental = 0,
		@PropertyID = @PropertyID OUTPUT

SELECT	@PropertyID as N'@PropertyID'

SELECT	'Return Value' = @return_value

GO
