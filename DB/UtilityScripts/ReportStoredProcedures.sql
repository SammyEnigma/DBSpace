set statistics IO on
set Statistics Time on

DECLARE @StartDate date, @EndDate date, @DEBUG bit;
SET @StartDate = '20120104';
SET @EndDate = '20150525';
SET @DEBUG = 1;

EXEC usp_SlCountClients
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountNewClients
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SLCountAdults
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountNursingMothers
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountNursingInfants
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountPregnantWomen
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountBloodTests
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SLCountBloodLeadLevels
	@MinLeadValue = 5.0
	, @MaxLeadValue = 10.0
	, @StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SLCountBloodLeadLevels
	@MinLeadValue = 10.0
	, @StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG

EXEC usp_SlCountHomeVisitSoilSample
	@StartDate = @StartDate
	, @EndDate = @EndDate
	, @DEBUG = @DEBUG
