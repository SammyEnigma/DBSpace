-- Check if temp database exists 
-- Tempdatabase is used for determining the default database path 
--if the zztempDefaultPath db exists drop  


IF EXISTS(SELECT 1 FROM [master].[sys].[databases] WHERE [name] = 'zzTempDBForDefaultPath')   

BEGIN  
    DROP DATABASE zzTempDBForDefaultPath   
END;

-- Create temp database. Because no options are given, the default data and --- log path locations are used 

CREATE DATABASE zzTempDBForDefaultPath;

--Declare variables for creating temp database   

DECLARE @Default_Data_Path VARCHAR(512),   
        @Default_Log_Path VARCHAR(512);

--Get the default data path   

SELECT @Default_Data_Path =    
(   SELECT LEFT(physical_name,LEN(physical_name)-CHARINDEX('\',REVERSE(physical_name))+1) 
    FROM sys.master_files mf   
    INNER JOIN sys.[databases] d   
    ON mf.[database_id] = d.[database_id]   
    WHERE d.[name] = 'zzTempDBForDefaultPath' AND type = 0);

--Get the default Log path   

SELECT @Default_Log_Path =    
(   SELECT LEFT(physical_name,LEN(physical_name)-CHARINDEX('\',REVERSE(physical_name))+1)   
    FROM sys.master_files mf   
    INNER JOIN sys.[databases] d   
    ON mf.[database_id] = d.[database_id]   
    WHERE d.[name] = 'zzTempDBForDefaultPath' AND type = 1);

--Clean up. Drop de temp database 

IF EXISTS(SELECT 1 FROM [master].[sys].[databases] WHERE [name] = 'zzTempDBForDefaultPath')   
BEGIN  
    DROP DATABASE zzTempDBForDefaultPath   
END;

PRINT    @Default_Data_Path;   
PRINT    @Default_Log_Path;
DECLARE @DBCreateSQLcmd nvarchar(4000);
SELECT @DBCreateSQLcmd = 'CREATE DATABASE [LCCHPPublic]
 ON  PRIMARY 
( NAME = N''LCCHP'', FILENAME = N''' + @Default_Data_Path + 'LCCHPPublic.mdf'' , SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 4096KB ), 
-- FILEGROUP [LCCHPAttachments] CONTAINS FILESTREAM  DEFAULT 
--( NAME = N''LCCHPAttachments'', FILENAME = N''D:\MSSQL\Filestream\LCCHPAttachmentsPublic'' , MAXSIZE = UNLIMITED), 
 FILEGROUP [UData]  DEFAULT 
( NAME = N''LCCHP_UData'', FILENAME = N''' + @Default_Data_Path + 'LCCHPPublic_UData.ndf'' , SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 4096KB )
 LOG ON 
( NAME = N''LCCHP_log'', FILENAME = N''' + @Default_Log_Path + 'LCCHPPublic_log.ldf'' , SIZE = 8MB , MAXSIZE = 2048GB , FILEGROWTH = 4096KB )'
SELECT @DBCreateSQLcmd
EXEC (@DBCreateSQLcmd)
GO
ALTER DATABASE [LCCHPPublic] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LCCHPPublic].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LCCHPPublic] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LCCHPPublic] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LCCHPPublic] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LCCHPPublic] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LCCHPPublic] SET ARITHABORT OFF 
GO
ALTER DATABASE [LCCHPPublic] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LCCHPPublic] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [LCCHPPublic] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LCCHPPublic] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LCCHPPublic] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LCCHPPublic] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LCCHPPublic] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LCCHPPublic] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LCCHPPublic] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LCCHPPublic] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LCCHPPublic] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LCCHPPublic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LCCHPPublic] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LCCHPPublic] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LCCHPPublic] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LCCHPPublic] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LCCHPPublic] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LCCHPPublic] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LCCHPPublic] SET RECOVERY FULL 
GO
ALTER DATABASE [LCCHPPublic] SET  MULTI_USER 
GO
ALTER DATABASE [LCCHPPublic] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LCCHPPublic] SET DB_CHAINING OFF 
GO
--ALTER DATABASE [LCCHPPublic] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF, DIRECTORY_NAME = N'LCCHPAttachmentsPublic' ) 
--GO
ALTER DATABASE [LCCHPPublic] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [LCCHPPublic]
GO
/****** Object:  User [WIN-1M8NQQ69OEH\SQLMaintenenace]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE USER [WIN-1M8NQQ69OEH\SQLMaintenenace] FOR LOGIN [WIN-1M8NQQ69OEH\SQLMaintenenace] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [appUser]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE USER [appUser] FOR LOGIN [appUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [WIN-1M8NQQ69OEH\SQLMaintenenace]
GO
ALTER ROLE [db_owner] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [appUser]
GO
/****** Object:  StoredProcedure [dbo].[DELETE_usp_InsertPersontoStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoStatus records
-- =============================================

CREATE PROCEDURE [dbo].[DELETE_usp_InsertPersontoStatus]   -- usp_InsertPersontoStatus
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@StatusID int = NULL,
	@StatusDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoStatus( PersonID, StatusID, StatusDate )
					 Values ( @PersonID, @StatusID, @StatusDate )
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[DELETE_usp_SlCountClients]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150604
-- Description:	procedure returns the number of
--              entries in the persons table where
--              isClient = 1 filtered by age 
--              and Report Dates
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_usp_SlCountClients] 
	-- Add the parameters for the stored procedure here
	@Max_Age int = NULL,
	@Start_Date datetime = '18000101',
	@End_Date datetime = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@End_Date IS NULL)
		SELECT @End_Date = GetDate();

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @MaxAge int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT TotalClients = count([PersonId]) from [person] WHERE isClient = 1'

		IF (@Max_Age IS NOT NULL)
		BEGIN
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [Age] <= @MaxAge';
		END

		IF (@Start_Date IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND 	( CreatedDate >= @StartDate OR ModifiedDate >= @StartDate ) '

		IF @Recompile = 1
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@MaxAge VARCHAR(50), @StartDate datetime'
		, @MaxAge = @Max_Age
		, @StartDate = @Start_Date

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[TransProc]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TransProc] @PriKey INT, @CharCol CHAR(3) AS
BEGIN TRANSACTION InProc
INSERT INTO TestTrans VALUES (@PriKey, @CharCol)
INSERT INTO TestTrans VALUES (@PriKey + 1, @CharCol)
COMMIT TRANSACTION InProc;

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertAccessAgreement]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new 
--				AccessAgreement records
-- =============================================
-- HISTORY
-- 12/13/2014	modified procedure to accept OUTPUT parameters

CREATE PROCEDURE [dbo].[usp_InsertAccessAgreement]   -- usp_InsertAccessAgreement 
	-- Add the parameters for the stored procedure here
	@AccessPurposeID int = NULL,
	@Notes varchar(3000) = NULL,
	@AccessAgreementFile varbinary(max) = NULL,
	@PropertyID int = NULL,
	@InsertedAccessAgreementID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into AccessAgreement (AccessPurposeID, AccessAgreementFile, PropertyID) 
					 Values ( @AccessPurposeID, @AccessAgreementFile, @PropertyID);
		SELECT @InsertedAccessAgreementID = SCOPE_IDENTITY();

		IF (@NOTES IS NOT NULL)
		BEGIN TRY 
			INSERT into AccessAgreementNotes (AccessAgreementID, Notes)
					Values (@InsertedAccessAgreementID, @Notes)
		END TRY
		BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		END CATCH;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertAccessPurpose]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new AccessPurpose records
-- =============================================
-- HISTORY
-- 12/13/2014	modified procedure to accept OUTPUT parameters

CREATE PROCEDURE [dbo].[usp_InsertAccessPurpose]   -- usp_InsertAccessPurpose 
	-- Add the parameters for the stored procedure here
	@AccessPurposeName varchar(50) = NULL,
	@AccessPurposeDescription varchar(250) = NULL,
	@AccessPurposeID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into AccessPurpose ( AccessPurposeName, AccessPurposeDescription)
					 Values ( @AccessPurposeName, @AccessPurposeDescription);
		SELECT @AccessPurposeID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertArea]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Area records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertArea]   -- usp_InsertArea 
	-- Add the parameters for the stored procedure here
	@AreaDescription varchar(250) = NULL,
	@AreaName varchar(50) = NULL,
	@NewAreaID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Area ( AreaDescription, HistoricAreaID)
					 Values ( @AreaDescription, @AreaName);
		SELECT @NewAreaID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
	-- Call procedure to print error information.
    EXECUTE dbo.uspPrintError;

    -- Roll back any active or uncommittable transactions before
    -- inserting information in the ErrorLog.
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
	RETURN ERROR_NUMBER()
END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertBloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new BloodTestResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertBloodTestResults]   -- usp_InsertBloodTestResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PersonID int = NULL,
	@SampleDate date = NULL,
	@LabSubmissionDate date = NULL,
	@LeadValue numeric(4,1) = NULL,
	@LeadValueCategoryID tinyint = NULL,
	@HemoglobinValue numeric(4,1) = NULL,
	@HemoglobinValueCategoryID tinyint = NULL, -- lookup in the database
	@HematocritValueCategoryID tinyint = NULL, -- lookup in the database
	@LabID int = NULL,
	@ClientStatusID smallint = NULL,
	@BloodTestCosts money = NULL,
	@sampleTypeID tinyint = NULL,
	@New_Notes varchar(3000) = NULL,
	@TakenAfterPropertyRemediationCompleted bit = NULL,
	@BloodTestResultID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ExistsPersonID int -- does the person have a record in BloodTestResults table
			, @ErrorLogID int, @NotesID int;
	-- Handle Null sampleDate?
	-- Handle Null LabSubmissionDate?

	-- check if the person exists
	IF NOT EXISTS (select PersonID from Person where PersonID = @PersonID)
	BEGIN
		RAISERROR ('Person does not exist. Cannot create a BloodtestResult record', 11, -1);
		RETURN;
	END

	-- check if the person has a record in BloodTestResults Table
	select @ExistsPersonID = PersonID from BloodTestResults

    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPersonID is not NULL )
			BEGIN
				SET @isBaseline = 0;
			END
			ELSE -- the person has no entry in BloodTestResults, this is a baseline entry
			BEGIN
				SET @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 0 ) -- this should not be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPersonID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPersonID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into BloodTestResults ( isBaseline, PersonID, SampleDate, LabSubmissionDate, LeadValue, LeadValueCategoryID,
		                                HemoglobinValue, HemoglobinValueCategoryID, HematocritValueCategoryID, LabID, ClientStatusID,
										BloodTestCosts, SampleTypeID, TakenAfterPropertyRemediationCompleted)
					 Values ( @isBaseline, @PersonID, @SampleDate, @LabSubmissionDate, @LeadValue, @LeadValueCategoryID,
		                      @HemoglobinValue, @HemoglobinValueCategoryID, @HematocritValueCategoryID, @LabID, @ClientStatusID,
							  @BloodTestCosts, @SampleTypeID, @TakenAfterPropertyRemediationCompleted);
		SELECT @BloodTestResultID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertBloodTestResultsNotes]
							@BloodtestResults_ID = @BloodTestResultID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertBloodTestResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert BloodTestResults notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertBloodTestResultsNotes] 
	-- Add the parameters for the stored procedure here
	@BloodTestResults_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update BloodTestResults information
		INSERT INTO BloodTestResultsNotes (BloodTestResultsID, Notes) 
				values (@BloodTestResults_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertCleanupStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new CleanupStatus records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertCleanupStatus]   -- usp_InsertCleanupStatus 
	-- Add the parameters for the stored procedure here
	@CleanupStatusDescription varchar(200) = NULL,
	@CleanupStatusName varchar(25) = NULL,
	@NewCleanupStatusID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into CleanupStatus ( CleanupStatusDescription, CleanupStatusName)
					 Values ( @CleanupStatusDescription, @CleanupStatusName);
		SELECT @NewCleanupStatusID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertConstructionType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ConstructionType records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertConstructionType]   -- usp_InsertConstructionType 
	-- Add the parameters for the stored procedure here
	@ConstructionTypeDescription varchar(250) = NULL,
	@ConstructionTypeName varchar(50) = NULL,
	@NewConstructionTypeID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ConstructionType ( ConstructionTypeDescription, ConstructionTypeName)
					 Values ( @ConstructionTypeDescription, @ConstructionTypeName);
		SELECT @NewConstructionTypeID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertContractor]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Contractor records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractor]   -- usp_InsertContractor 
	-- Add the parameters for the stored procedure here
	@ContractorDescription varchar(250) = NULL,
	@ContractorName varchar(50) = NULL,
	@NewContractorID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Contractor ( ContractorDescription, ContractorName)
					 Values ( @ContractorDescription, @ContractorName);
		SELECT @NewContractorID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoProperty]   -- usp_InsertContractortoProperty 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoProperty ( ContractorID, PropertyID, StartDate, EndDate)
					 Values ( @ContractorID, @PropertyID, @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoRemediation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoRemediation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoRemediation]   -- usp_InsertContractortoRemediation 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@RemediationID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isSubContractor bit = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoRemediation ( ContractorID, RemediationID, StartDate, EndDate, isSubContractor)
					 Values ( @ContractorID, @RemediationID, @StartDate, @EndDate, @isSubContractor);
		SELECT SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END







GO
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoRemediationActionPlan]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoRemediationPlan records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoRemediationActionPlan]   -- usp_InsertContractortoRemediationPlan 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@RemediationActionPlanID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isSubContractor bit = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoRemediationActionPlan ( ContractorID, RemediationActionPlanID, StartDate, EndDate, isSubContractor)
					 Values ( @ContractorID, @RemediationActionPlanID, @StartDate, @EndDate, @isSubContractor);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertCountry]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Country records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertCountry]   -- usp_InsertCountry 
	-- Add the parameters for the stored procedure here
	@CountryName varchar(50) = NULL,
	@NewCountryID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Country ( CountryName)
					 Values ( @CountryName);
		SELECT @NewCountryID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycare]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Daycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycare]   -- usp_InsertDaycare 
	-- Add the parameters for the stored procedure here
	@DaycareName varchar(50) = NULL,
	@DaycareDescription varchar(200) = NULL,
	@newDayCareID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Daycare ( DaycareName, DaycareDescription )
					 Values ( @DaycareName, @DaycareDescription );
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycarePrimaryContact]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new DaycarePrimaryContact records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycarePrimaryContact]   -- usp_InsertDaycarePrimaryContact 
	-- Add the parameters for the stored procedure here
	@DaycareID int = NULL,
	@PersonID int = NULL,
	@ContactPriority tinyint = NULL,
	@PrimaryPhoneNumberID int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into DaycarePrimaryContact ( DayCareID, PersonID, ContactPriority, PrimaryPhoneNumberID )
					 Values ( @DayCareID, @PersonID, @ContactPriority, @PrimaryPhoneNumberID );
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycaretoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new DaycaretoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycaretoProperty]   -- usp_InsertDaycaretoProperty 
	-- Add the parameters for the stored procedure here
	@DaycareID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into DaycaretoProperty ( DaycareID, PropertyID, StartDate, EndDate)
					 Values ( @DaycareID, @PropertyID, @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEmployer]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Employer records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEmployer]   -- usp_InsertEmployer 
	-- Add the parameters for the stored procedure here
	@EmployerName VARCHAR(50) = NULL,
	@NewEmployerID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Employer ( EmployerName )
					 Values ( @EmployerName );
		SELECT @NewEmployerID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEmployertoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new EmployertoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEmployertoProperty]   -- usp_InsertEmployertoProperty 
	-- Add the parameters for the stored procedure here
	@EmployerID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into EmployertoProperty ( EmployerID, PropertyID, StartDate, EndDate)
					 Values ( @EmployerID, @PropertyID, @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEnvironmentalInvestigation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new EnvironmentalInvestigation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEnvironmentalInvestigation]   -- usp_InsertEnvironmentalInvestigation 
	-- Add the parameters for the stored procedure here
	@ConductEnvironmentalInvestigation bit = NULL,
	@ConductEnvironmentalInvestigationDecisionDate date = NULL,
	@Cost money = NULL,
	@EnvironmentalInvestigationDate date = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@NewEnvironmentalInvestigation int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into EnvironmentalInvestigation ( ConductEnvironmentalInvestigation, ConductEnvironmentalInvestigationDecisionDate,
		                                          Cost, EnvironmentalInvestigationDate, PropertyID, StartDate, EndDate )
					 Values ( @ConductEnvironmentalInvestigation, @ConductEnvironmentalInvestigationDecisionDate,
		                      @Cost, @EnvironmentalInvestigationDate, @PropertyID, @StartDate, @EndDate  );
		SELECT @NewEnvironmentalInvestigation = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEthnicity]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Ethnicity records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEthnicity]   -- usp_InsertEthnicity 
	-- Add the parameters for the stored procedure here
	@Ethnicity varchar(50) = NULL,
	@NewEthnicityID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Ethnicity ( Ethnicity )
					 Values ( @Ethnicity );
		SELECT @NewEthnicityID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamily]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert new Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50) = NULL,
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@ForeignTravel bit = NULL,
	@New_Travel_Notes varchar(3000) = NULL,
	@Travel_Start_Date date = NULL,
	@Travel_End_Date date = NULL,
	@Pets tinyint = NULL,
	@Petsinandout bit = NULL,
	@PrimaryPropertyID int = NULL,
	@FrequentlyWashPets bit = NULL,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @FamilyNotesReturnValue int, @InsertedFamilyNotesID int
			, @TravelNotesReturnValue int, @InsertedTravelNotesID int;

	BEGIN TRY -- insert Family
		BEGIN TRANSACTION InsertFamilyTransaction
			INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID, Pets, Petsinandout
						, PrimaryPropertyID, FrequentlyWashPets, ForeignTravel) 
						Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Pets, @Petsinandout
						, @PrimaryPropertyID, @FrequentlyWashPets, @ForeignTravel)
			SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values

			IF (@Notes IS NOT NULL)
				EXEC	@FamilyNotesReturnValue = [dbo].[usp_InsertFamilyNotes]
													@Family_ID = @FID,
													@Notes = @Notes,
													@InsertedNotesID = @InsertedFamilyNotesID OUTPUT
	
			IF (@New_Travel_Notes IS NOT NULL)
				EXEC	@TravelNotesReturnValue = [dbo].[usp_InsertTravelNotes]
						@Family_ID = @FID,
						@Travel_Notes = @New_Travel_Notes,
						@Start_Date = @Travel_Start_Date,
						@End_Date = @Travel_End_Date,
						@InsertedNotesID = @InsertedTravelNotesID OUTPUT

		COMMIT TRANSACTION InsertFamilyTransaction
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150214
-- Description:	stored procedure to insert family notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertFamilyNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Family information
		INSERT INTO FamilyNotes (FamilyID, Notes) 
				values (@Family_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150404
-- Description:	Stored Procedure to insert new 
--				FamilytoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoPhoneNumber]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistingNumberPriority tinyint, @FamilytoPhoneNumberExists bit = 0
		, @FamilyPhonePriorityExists int = 0, @SwapPriority tinyint;
    -- Insert statements for procedure here
	BEGIN TRY
				-- see if family already has that number
		SELECT @FamilytoPhoneNumberExists = 1, @SwapPriority = NumberPriority from FamilytoPhoneNumber where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID
		-- see if the family already has a number with same priority get the PHoneNumberID
		SELECT @FamilyPhonePriorityExists = PhoneNumberID from FamilytoPhoneNumber where FamilyID = @FamilyID and NumberPriority = @NumberPriority

		-- If the family is already associated with the phone number
		IF (@FamilytoPhoneNumberExists = 1)
		BEGIN
			-- if the priority is the same do nothing
			IF (@SwapPriority = @NumberPriority)
				RETURN;
			ELSE IF (@FamilyPhonePriorityExists = 0)  -- there are no numbers for that family with that priority, set the New number priority for the specified number
				update FamilytoPhoneNumber set NumberPriority = @NumberPriority where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID

			ELSE -- there is another number for that family with the desired priority, swap priorities
			BEGIN
				-- Set the New number priority for the specified number
				update FamilytoPhoneNumber set NumberPriority = @NumberPriority where FamilyID = @FamilyID and PhoneNumberID = @PhoneNumberID 

				-- Set number priority for number that had the existing @NumberPriority to the previous priority from the passed in phone number 
				update FamilytoPhoneNumber set NumberPriority = @SwapPriority where FamilyID = @FamilyID and PhoneNumberID = @FamilyPhonePriorityExists 			
			END
		END
		ELSE -- the family is not associated with that phone number
		BEGIN
			-- there are no numbers for that family with that priority
			IF (@FamilyPhonePriorityExists = 0)
			BEGIN
				INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
				 Values ( @FamilyID, @PhoneNumberID, @NumberPriority )
			END
			ELSE
			BEGIN
				-- Insert the New number and priority
				INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
				 Values ( @FamilyID, @PhoneNumberID, @NumberPriority ) 

				-- determine next priority
				select @SwapPriority = max(NumberPriority)+1 from FamilytoPhoneNumber where FamilyID = @FamilyID
				-- Set number priority for number that had the existing @NumberPriority to the lowest priority
				update FamilytoPhoneNumber set NumberPriority = @SwapPriority where FamilyID = @FamilyID and PhoneNumberID = @FamilyPhonePriorityExists 
			END
		END
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		THROW
		-- RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 201504817
-- Description:	Stored Procedure to insert new FamilytoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoProperty]   -- usp_InsertFamilytoProperty
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PropertyID int = NULL,
	@PropertyLinkTypeID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@DEBUG bit = NULL,
	@NewFamilytoPropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @FamilytoPropertyID int, @update_return_value int;
    -- Insert statements for procedure here
	BEGIN TRY
		select @FamilytoPropertyID = FamilytoPropertyID from FamilytoProperty where FamilyId = @FamilyID and PropertyID = @PropertyID

		IF @FamilytoPropertyID IS NOT NULL
		BEGIN
			EXEC @update_return_value = usp_upFamilytoProperty
				@FamilytoPropertyID = @FamilytoPropertyID,
				@PropertyLinkTypeID = @PropertyLinkTypeID,
				@StartDate = @StartDate,
				@EndDate = @EndDate,
				@isPrimaryResidence = @isPrimaryResidence,
				@DEBUG = @DEBUG
		END
		ELSE
			 INSERT into FamilytoProperty( FamilyID, PropertyID, PropertyLinkTypeID, StartDate, EndDate, isPrimaryResidence)
						 Values ( @FamilyID, @PropertyID, @PropertyLinkTypeID, @StartDate, @EndDate, @isPrimaryResidence )
		--SELECT @NewFamilytoPropertyID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertForeignFood]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ForeignFood records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertForeignFood]   -- usp_InsertForeignFood 
	-- Add the parameters for the stored procedure here
	@ForeignFoodName varchar(50) = NULL,
	@ForeignFoodDescription varchar(256) = NULL,
	@NewForeignFoodID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ForeignFood ( ForeignFoodName, ForeignFoodDescription )
					 Values ( @ForeignFoodName, @ForeignFoodDescription );
		SELECT @NewForeignFoodID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER();
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertForeignFoodtoCountry]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ForeignFoodtoCountry records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertForeignFoodtoCountry]   -- usp_InsertForeignFoodtoCountry 
	-- Add the parameters for the stored procedure here
	@ForeignFoodID int = NULL,
	@CountryID tinyint = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ForeignFoodtoCountry ( ForeignFoodID, CountryID ) --, StartDate, EndDate)
					 Values ( @ForeignFoodID, @CountryID ) -- , @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertGiftCard]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new GiftCard records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertGiftCard]   -- usp_InsertGiftCard 
	-- Add the parameters for the stored procedure here
	@GiftCardValue money = NULL,
	@IssueDate date = NULL,
	@PersonID int = NULL,
	@NewGiftCardID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here

	BEGIN TRY
		IF EXISTS (SELECT PersonID from Person where PersonID = @PersonID) print 'Person exists'
		 INSERT into GiftCard ( GiftCardValue, IssueDate, PersonID )
					 Values ( @GiftCardValue, @IssueDate, @PersonID );
		SELECT @NewGiftCardID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertHobby]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Hobby records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHobby]   -- usp_InsertHobby 
	-- Add the parameters for the stored procedure here
	@HobbyName varchar(50) = NULL,
	@HobbyDescription varchar(256) = NULL,
	@LeadExposure bit = NULL,
	@NewHobbyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Hobby ( HobbyName, HobbyDescription, LeadExposure )
					 Values ( @HobbyName, @HobbyDescription, @LeadExposure );
		SELECT @NewHobbyID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertHomeRemedies]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new HomeRemedies records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHomeRemedies]   -- usp_InsertHomeRemedies 
	-- Add the parameters for the stored procedure here
	@HomeRemedyName varchar(50) = NULL,
	@HomeRemedyDescription varchar(256) = NULL,
	@NewHomeRemedyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into HomeRemedy ( HomeRemedyName, HomeRemedyDescription )
					 Values ( @HomeRemedyName, @HomeRemedyDescription );
		SELECT @NewHomeRemedyID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertHouseholdSourcesofLead]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new HouseholdSourcesofLead records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHouseholdSourcesofLead]   -- usp_InsertHouseholdSourcesofLead 
	-- Add the parameters for the stored procedure here
	@HouseholdItemName varchar(50) = NULL,
	@HouseholdItemDescription varchar(512) = NULL,
	@NewHouseholdItemID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into HouseholdSourcesofLead ( HouseholdItemName, HouseholdItemDescription )
					 Values ( @HouseholdItemName, @HouseholdItemDescription );
		SELECT @NewHouseholdItemID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertInsuranceProvider]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new InsuranceProvider records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertInsuranceProvider]   -- usp_InsertInsuranceProvider 
	-- Add the parameters for the stored procedure here
	@InsuranceProviderName varchar(50) = NULL,
	@NewInsuranceProviderID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into InsuranceProvider ( InsuranceProviderName ) --, HouseholdItemDescription )
					 Values ( @InsuranceProviderName ) -- , @HouseholdItemDescription );
		SELECT @NewInsuranceProviderID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLab]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Lab records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLab]   -- usp_InsertLab 
	-- Add the parameters for the stored procedure here
	@LabName varchar(50) = NULL,
	@LabDescription varchar(250) = NULL,
	@New_Lab_Notes varchar(3000) = NULL,
	@NewLabID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Lab ( LabName, LabDescription )
					 Values ( @LabName, @LabDescription );
		SELECT @NewLabID = SCOPE_IDENTITY();

		IF (@New_Lab_Notes IS NOT NULL)
		EXEC	[dbo].[usp_InsertLabNotes]
							@Lab_ID = @NewLabID,
							@Notes = @New_Lab_Notes,
							@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLabNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Lab notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertLabNotes] 
	-- Add the parameters for the stored procedure here
	@Lab_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Lab information
		INSERT INTO LabNotes (LabID, Notes) 
				values (@Lab_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLanguage]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new Languages
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLanguage]   -- usp_InsertLanguage "Italian"
	-- Add the parameters for the stored procedure here
	@LanguageName varchar(50),
	@LANGUAGEID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DBNAME NVARCHAR(128), @ErrorLogID int;
	SET @DBNAME = DB_NAME();

	BEGIN TRY
	     if Exists (select LanguageName from language where LanguageName = @LanguageName) 
		 BEGIN
		 RAISERROR
			(N'The language: %s already exists.',
			11, -- Severity.
			1, -- State.
			@LanguageName);
		 END
	
		INSERT into Language (LanguageName) Values (upper(@LanguageName))
		SET @LANGUAGEID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertMedium]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Medium records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertMedium]   -- usp_InsertMedium 
	-- Add the parameters for the stored procedure here
	@MediumName varchar(50) = NULL,
	@MediumDescription varchar(250) = NULL,
	@TriggerLevel int = NULL,
	@TriggerLevelUnitsID smallint = NULL,
	@NewMediumID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Medium ( MediumName, MediumDescription, TriggerLevel, TriggerLevelUnitsID )
					 Values ( @MediumName, @MediumDescription, @TriggerLevel, @TriggerLevelUnitsID );
		SELECT @NewMediumID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertMediumSampleResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new MediumSampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertMediumSampleResults]   -- usp_InsertMediumSampleResults 
	-- Add the parameters for the stored procedure here
	@MediumID int = NULL,
	@MediumSampleValue numeric(9,4) = NULL,
	@UnitsID smallint = NULL,
	@SampleLevelCategoryID tinyint = NULL,
	@MediumSampleDate date = getdate,
	@LabID int = NULL,
	@LabSubmissionDate date = getdate,
	@Notes varchar(3000) = NULL,
	@IsAboveTriggerLevel bit = NULL,
	@NewMediumSampleResultsID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @TriggerlevelUnitsID smallint, @TriggerLevel numeric(9,4), @NotesID int, @Notes_results int;
    -- Insert statements for procedure here
	
	-- See if Value is above Trigger Level - initially assume units are identical
	-- Determine Trigger level units and Trigger Level
	Select @TriggerLevel = M.TriggerLevel , @TriggerLevelUnitsID = M.TriggerLevelUnitsID FROM MediumSampleresults AS MSR 
		JOIN Medium as M on M.MediumID = MSR.MediumID 
		JOIN Units AS TLU on M.TriggerLevelUnitsID = TLU.UnitsID;

	-- IF the units are the same, 
	IF (@UnitsID = @TriggerlevelUnitsID )
	BEGIN
		print 'units are identical comparing values'
		IF ( @MediumSampleValue < @TriggerLevel ) 
			SET @IsAboveTriggerLevel = 0;
		ELSE 
			SET @IsAboveTriggerLevel = 1;
	END
	ELSE  
		print 'consider converting values to the same units'


	BEGIN TRY
		 INSERT into MediumSampleResults ( MediumID, MediumSampleValue, UnitsID, SampleLevelCategoryID, MediumSampleDate, LabID,
		                                   LabSubmissionDate, IsAboveTriggerLevel )
					 Values ( @MediumID, @MediumSampleValue, @UnitsID, @SampleLevelCategoryID, @MediumSampleDate, @LabID,
		                      @LabSubmissionDate, @IsAboveTriggerLevel );
		SELECT @NewMediumSampleResultsID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	@Notes_results = [usp_InsertMediumSampleResultsNotes]
								@MediumSampleResults_ID = @NewMediumSampleResultsID,
								@Notes = @Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertMediumSampleResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150417
-- Description:	stored procedure to insert MediumSampleResults notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertMediumSampleResultsNotes] 
	-- Add the parameters for the stored procedure here
	@MediumSampleResults_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update MediumSample information
		INSERT INTO MediumSampleResultsNotes (MediumSampleResultsID, Notes) 
				values (@MediumSampleResults_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141217
-- Description:	stored procedure to insert data retrieved from 
--				the Blood Lead Test Results web screen
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Sample_Date date = NULL,
	@Lab_Date date = Null,
	@Blood_Lead_Result numeric(4,1)= NULL, -- Is this Lead value?
	@Flag INT = 365, -- flag follow up date
	@Test_Type tinyint = NULL, -- SampleTypeID need to determine if/how new testTypes are created
	@Lab varchar(50) = NULL,  -- is this necessary i think the lab should be selected from a drop down with the option to add a new lab and an id should be passed?
	@Lab_ID int = NULL,
	@Child_Status_Code smallint = NULL, -- StatusID need to determine if/how new statusCodes are created
	@Child_Status_Date date = NULL,
	@Hemoglobin_Value numeric(4,1) = NULL,
	@DEBUG bit = 0,
	@Blood_Test_Results_ID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @BloodTestResult_return_value int, @RetestDate_return_value int
			,@Retest_Date date, @ChildStatusCode_return_value int, @ErrorLogID int;

	-- set default date if necessary 
	IF (@Sample_Date is null) 
	BEGIN
		set @Sample_Date = GetDate();
		RAISERROR ('Need to specify the SampleDate, setting to today by default', 5, 0);
	END
	
	IF (@Person_ID IS NULL)
	BEGIN
		RAISERROR ('Client name must be supplied', 11, -1);
		RETURN;
	END;
	BEGIN TRY
		EXEC	@BloodTestResult_return_value = [dbo].[usp_InsertBloodTestResults]
				@isBaseline = NULL,
				@PersonID = @Person_ID,
				@SampleDate = @Sample_Date,
				@LabSubmissionDate = @Lab_Date,
				@LeadValue = @Blood_Lead_Result,
				@LeadValueCategoryID = NULL,
				@HemoglobinValue = @Hemoglobin_Value,
				@HemoglobinValueCategoryID = NULL,
				@HematocritValueCategoryID = NULL,
				@LabID = @Lab_ID,
				@ClientStatusID = @Child_Status_Code,
				@BloodTestCosts = NULL,
				@sampleTypeID = @Test_Type,
				@New_Notes = NULL,
				@TakenAfterPropertyRemediationCompleted = NULL,
				@BloodTestResultID = @Blood_Test_Results_ID OUTPUT

		--IF (@Child_Status_Code IS NOT NULL)
		--BEGIN
		--	IF (@Child_Status_Date IS NULL)
		--		SELECT @Child_Status_Date = GetDate();

		--	IF @DEBUG = 1
		--		SELECT '@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus] @PersonID = @Person_ID, @StatusID = @Child_Status_Code, @StatusDate = @Sample_Date' 
		--					,@Person_ID , @Child_Status_Code, @Sample_Date

		--	EXEC	@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus]
		--			@PersonID = @Person_ID,
		--			@StatusID = @Child_Status_Code,
		--			@StatusDate = @Sample_Date
		--END

		-- set the retest date based on integer value passed in as Flag
		SET @Retest_Date = DATEADD(dd,@Flag,@Sample_Date);

		-- update Person table with the new retest date
		-- anyone with a blood test is a client
		EXEC	@RetestDate_return_value = [dbo].[usp_upPerson]
				@Person_ID = @Person_ID
				, @New_RetestDate = @Retest_Date
				, @New_ClientStatusID = @Child_Status_Code
				, @New_isClient = 1;
	END TRY
	BEGIN CATCH
	    -- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 	
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewClientWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@First_Name varchar(50) = NULL,
	@Middle_Name varchar(50) = NULL,
	@Last_Name varchar(50) = NULL,
	@Birth_Date date = NULL,
	@Gender_ char(1) = NULL,
	@Language_ID tinyint = NULL,
	@Ethnicity_ID int = NULL,
	@Moved_ bit = NULL,
	@Travel bit = NULL, --ForeignTravel  REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Travel_Notes varchar(3000) = NULL,  -- REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Out_of_Site bit = NULL, 
	@Hobby_ID smallint = NULL,
	@Hobby_Notes varchar(3000) = NULL,
	@Client_Notes varchar(3000) = NULL,
	@Release_Notes varchar(3000) = NULL,
	@is_Smoker bit = NULL,
	@Occupation_ID smallint = NULL,
	@Occupation_Start_Date date = NULL,
	@OverrideDuplicatePerson bit = 0,
	@EmailAddress VARCHAR(320) = NULL,
	@is_Client bit = 1,
	@NursingMother bit = NULL,
	@NursingInfant bit = NULL,
	@Pregnant bit = NULL,
	@ClientID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL)
		BEGIN
			RAISERROR ('Family name must be supplied', 11, -1);
			RETURN;
		END;

		-- If the family doesn't exist, return an error
		IF ((select FamilyID from family where FamilyID = @Family_ID) is NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Unable to associate non-existent family. Family does not exist.'
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END
	
		if (@Last_Name is null)
		BEGIN
			select @Last_Name = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- insert new person
			EXEC	[dbo].[usp_InsertPerson]
					@FirstName = @First_Name,
					@MiddleName = @Middle_Name,
					@LastName = @Last_Name,
					@BirthDate = @Birth_Date,
					@Gender = @Gender_,
					@Moved = @Moved_,
					@ForeignTravel = @Travel,
					@EmailAddress = @EmailAddress,
					@OutofSite = @Out_of_Site,
					@New_Notes = @Client_Notes,
					@Hobby_Notes = @Hobby_Notes, 
					@Release_Notes = @Release_Notes,
					@Travel_Notes = @Travel_Notes,
					@isSmoker = @is_Smoker,
					@isClient = @is_Client,
					@NursingMother = @NursingMother,
					@NursingInfant = @NursingInfant,
					@Pregnant = @Pregnant,
					@OverrideDuplicate = @OverrideDuplicatePerson,
					@PID = @CLientID OUTPUT;

			-- Associate person to Ethnicity
			IF (@Ethnicity_ID IS NOT NULL)
			EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
					@PersonID = @ClientID,
					@EthnicityID = @Ethnicity_ID

			-- Associate person to family
			if (@Family_ID is not NULL)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @ClientID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			if (@Language_ID is not NULL)
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @Language_ID, @PersonID = @ClientID, @isPrimaryLanguage = 1;

			-- associate person to Hobby
			if (@Hobby_ID is not NULL)
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby_ID, @PersonID = @ClientID;

			-- associate person to occupation
			if (@Occupation_ID is not NULL)
			EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
					@PersonID = @ClientID,
					@OccupationID = @Occupation_ID
		END TRY
		BEGIN CATCH -- insert person
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; -- insert new person
	END

	IF (@Family_ID is not NULL AND @PersontoFamily_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to family', 11, -1);
		RETURN;
	END
	
	IF (@Hobby_ID is not NULL AND @PersontoHobby_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to Hobby', 11, -1);
		RETURN;
	END
	
	IF (@Language_ID is not NULL AND @PersontoLanguage_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to language', 11, -1);
		RETURN;
	END
	
	IF (@Occupation_ID is not NULL and @PersontoOccupation_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to occupation', 11, -1);
		RETURN;
	END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewFamilyWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new family web page
-- =============================================
-- 20150102	Fixed bug with family/property association checking
CREATE PROCEDURE [dbo].[usp_InsertNewFamilyWebScreen]
	-- Add the parameters for the stored procedure here
	@FamilyLastName varchar(50) = NULL, 
	@Address_Line1 varchar(100) = NULL,
	@Address_Line2 varchar(100) = NULL,
	@CityName varchar(50) = NULL,
	@StateAbbr char(2) = NULL,
	@ZipCode varchar(10) = NULL,
	@Year_Built date = NULL,
	@Movein_Date date = NULL,
	@MoveOut_Date date = NULL,
	@Owner_id int = NULL,
	@is_Owner_Occupied bit = NULL,
	@is_Residential bit = NULL,
	@has_Peeling_Chipping_Paint bit = NULL,
	@is_Rental bit = NULL,
	@PrimaryPhone bigint = NULL,
	@PrimaryPhonePriority tinyint = 1,
	@SecondaryPhone bigint = NULL,
	@SecondaryPhonePriority tinyint = 2,
	@Language tinyint = NULL, 
	@NumSmokers tinyint = NULL,
	@Pets tinyint = NULL,
	@Frequently_Wash_Pets bit = NULL,
	@Petsinandout bit = NULL,
	@FamilyNotes varchar(3000) = NULL,
	@PropertyNotes varchar(3000) = NULL,
	@Travel bit = NULL,
	@Travel_Notes varchar(3000) = NULL,
	@Travel_Start_Date varchar(3000) = NULL,
	@Travel_End_Date varchar(3000) = NULL,
	@OverrideDuplicateProperty bit = 0,
	@OverrideDuplicateFamilyPropertyAssociation bit = 0,
	@OwnerContactInformation varchar(1000) = NULL,
	@DEBUG BIT = 0,
	@FamilyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@FamilyLastName IS NULL
		AND @Address_Line1 IS NULL
		AND @Address_Line2 IS NULL
		AND @PrimaryPhone IS NULL
		AND @SecondaryPhone IS NULL)
	BEGIN
		RAISERROR ('You must supply at least one of the following: Family name, StreetNumber, Street Name, Street Suffix, Apartment number, Primary phone, or Secondary phone', 11, -1);
		RETURN;
	END;

	BEGIN
		DECLARE @return_value int,
				@PhoneTypeID tinyint, 
				@Family_return_value int,
				@PropID int, @LID tinyint,
				@InsertedFamilytoPropertyID int,
				@FamilytoProperty_return_value int,
				@Primaryphone_return_value int,
				@Secondaryphone_return_value int,
				@NewFamilyNotesID int,
				@TravelNotesReturnValue int,
				@ErrorLogID int;

		BEGIN TRY
			-- Insert the property address if it doesn't already exist
			-- Check if the property already exists, if it does, return the propertyID
			SELECT @PropID = [dbo].udf_DoesPropertyExist (
						@Address_Line1,
						@Address_Line2,
						@CityName,
						@StateAbbr,
						@ZipCode
						)

			--if (@is_Owner_Occupied = 1) 
			--	select @Owner_id = IDENT_CURRENT('Family')+1
			select 'PropertyID ' = @PropID;
			if ( @PropID is NULL)
			BEGIN -- enter property
				EXEC	[dbo].[usp_InsertProperty] 
						@AddressLine1 = @Address_Line1,
						@AddressLine2 = @Address_Line2,
						@City = @CityName,
						@State = @StateAbbr,
						@Zipcode = @ZipCode,
						@New_PropertyNotes = @PropertyNotes,
						@YearBuilt = @Year_Built,
						@Ownerid = @Owner_id,
						@isOwnerOccuppied = @is_Owner_Occupied,
						@isResidential = @is_Residential,
						@hasPeelingChippingPaint = @has_Peeling_Chipping_Paint,
						@isRental = @is_Rental,
						@OverrideDuplicate = @OverrideDuplicateProperty,
						@OwnerContactInformation = @OwnerContactInformation,
						@PropertyID = @PropID OUTPUT;
					END -- enter property

			-- Check if Family is already associated with property, if so, skip insert and return warning:
			if ((select count(PrimarypropertyID) from Family where LastName = @FamilyLastName and PrimaryPropertyID = @PropID) > 0)
			BEGIN
				if ( @OverrideDuplicateFamilyPropertyAssociation = 1)
				BEGIN
					-- update address in the future??
					RAISERROR ('Family is already associated with that Property', 11, -1);
					RETURN;
				END 
				ELSE
				BEGIN
					RAISERROR ('Family is already associated with that Property', 11, -1);
					RETURN;
				END;
			END
			ELSE
			BEGIN
				EXEC	[dbo].[usp_InsertFamily]
						@LastName = @FamilyLastName,
						@NumberofSmokers = @NumSmokers,
						@PrimaryLanguageID = @Language,
						@Notes = @FamilyNotes,
						@ForeignTravel = @Travel,
						@New_Travel_Notes = @Travel_Notes,
						@Travel_Start_Date = @Travel_Start_Date,
						@Travel_End_Date = @Travel_End_Date,
						@Pets = @Pets,
						@Petsinandout = @Petsinandout,
						@FrequentlyWashPets = @Frequently_Wash_Pets,
						@PrimaryPropertyID = @PropID,
						@FID = @FamilyID OUTPUT;
			END

			-- Associate family to property
			EXEC @FamilytoProperty_return_value = [usp_InsertFamilytoProperty] 
					@FamilyID = @FamilyID,
					@PropertyID = @PropID,
					@StartDate = @Movein_Date,
					@EndDate = @MoveOut_Date,
					@DEBUG = @DEBUG,
					@NewFamilytoPropertyID = @InsertedFamilytoPropertyID OUTPUT

			if (@PrimaryPhone is not NULL) 
			BEGIN  -- insert Primary Phone
				DECLARE @PrimaryPhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Primary Phone';

				EXEC	@Primaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @PrimaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @PrimaryPhoneNumberID_OUTPUT OUTPUT
				
				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @PrimaryPhonePriority,
						@PhoneNumberID = @PrimaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
			END  -- insert Primary Phone

			if (@SecondaryPhone is not NULL) 
			BEGIN  -- insert Secondary Phone
				DECLARE @SecondaryPhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Secondary Phone';

				EXEC	@Secondaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @SecondaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @SecondaryPhoneNumberID_OUTPUT OUTPUT

				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @SecondaryPhonePriority,
						@PhoneNumberID = @SecondaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
						
			END  -- insert Secondary Phone
		END TRY
		BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; 
	END
END



GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewQuestionnaireWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141208
-- Description:	stored procedure to insert data 
--              from the Lead Research Subject Questionnaire web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewQuestionnaireWebScreen]
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@QuestionnaireDate date = NULL,
	@PaintPeeling bit = NULL,
	@PaintDate date = NULL, 
	@VisitRemodel bit = NULL,
	@RemodelDate date = NULL, 
	@Vitamins bit = NULL,
	@HandWash bit = NULL,
	@Bottle bit = NULL,
	@NursingMother bit = NULL,
	@NursingInfant bit = NULL,
	@Pregnant bit = NULL,
	@Pacifier bit = NULL,
	@BitesNails bit = NULL,
	@EatsOutdoors bit = NULL, 
	@NonFoodInMouth bit = NULL,
	@EatsNonFood bit = NULL,
	@SucksThumb bit = NULL,
	@Mouthing bit = NULL,
	@DaycareID int = NULL,
	@VisitsOldHomes bit = NULL,
	@DayCareNotes varchar(3000) = NULL,
	@Source int = NULL,
	@QuestionnaireNotes varchar(3000) = NULL,
	@Hobby1ID smallint = NULL,
	@Hobby2ID smallint = NULL,
	@Hobby3ID smallint = NULL,
	@HobbyNotes varchar(3000) = NULL,
	@DEBUG bit = 0,
	@Questionnaire_return_value int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@PaintPeeling = '') SET @PaintPeeling = NULL;

	DECLARE @ErrorLogID int, @New_Notes varchar(3000), @PersontoHobby1_return_value int
		, @PersontoHobby2_return_value int, @PersontoHobby3_return_value int, @HobbyNotesID int; 

	BEGIN TRY
		-- set default date if necessary 
		IF (@QuestionnaireDate is null) 
		BEGIN
			print 'Need to specify QuestionnaireDate, setting to today by defualt';
			set @QuestionnaireDate = GetDate();
		END

		IF (@Person_ID IS NULL)
		BEGIN
			RAISERROR ('Client name must be supplied', 11, -1);
			RETURN;
		END;

		-- Client ID must already exist in the database
		IF ( (select PersonID from person where personID = @Person_ID ) is NULL)
		BEGIN
			RAISERROR ('Specified ClientID does not exist', 11, -1);
			RETURN;
		END

		SET @New_Notes = concat(@QuestionnaireNotes,' ',@DayCareNotes);
	
		EXEC	[dbo].[usp_InsertQuestionnaire]
				@PersonID = @Person_ID,
				@QuestionnaireDate = @QuestionnaireDate,
				@QuestionnaireDataSourceID = @Source,
				@VisitRemodeledProperty = @VisitRemodel,
				@PaintDate = @PaintDate,
				@RemodelPropertyDate = @RemodelDate,
				@isExposedtoPeelingPaint = @PaintPeeling,
				@isTakingVitamins = @Vitamins,
				@NursingMother = @NursingMother,
				@NursingInfant = @NursingInfant,
				@Pregnant = @Pregnant,
				@isUsingPacifier = @Pacifier,
				@isUsingBottle = @Bottle,
				@BitesNails = @BitesNails,
				@NonFoodEating = @EatsNonFood,
				@NonFoodinMouth = @NonFoodInMouth,
				@EatOutside = @EatsOutdoors,
				@Suckling = @SucksThumb,
				@Mouthing = @Mouthing,
				@FrequentHandWashing = @HandWash,
				@DaycareID = @DaycareID,
				@VisitsOldHomes = @VisitsOldHomes,
				@New_Notes = @New_Notes,
				@DEBUG = @DEBUG,
				@QuestionnaireID = @Questionnaire_return_value OUTPUT 

		-- Set NursingMother, NursingInfant, and Pregnant attributes of the person according to the questionnaire
		-- anyone that completes a questionnaire is a client
		EXEC [dbo].[usp_upPerson] @Person_ID = @Person_ID, @New_NursingMother = @NursingMother, @New_NursingInfant = @NursingInfant
								, @New_Pregnant = @Pregnant, @New_isClient = 1, @DEBUG = @DEBUG

		-- associate person to Hobby
		if (@Hobby1ID is not NULL)
			EXEC	@PersontoHobby1_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby1ID, @PersonID = @Person_ID;

		if (@Hobby2ID is not NULL)
			EXEC	@PersontoHobby2_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby2ID, @PersonID = @Person_ID;

		if (@Hobby3ID is not NULL)
			EXEC	@PersontoHobby3_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby3ID, @PersonID = @Person_ID;

		-- insert hobby notes
		IF (@HobbyNotes IS NOT NULL)
		EXEC	[dbo].[usp_InsertPersonHobbyNotes]
						@Person_ID = @Person_ID,
						@Notes = @HobbyNotes,
						@InsertedNotesID = @HobbyNotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertOccupation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Occupation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertOccupation]   -- usp_InsertOccupation 
	-- Add the parameters for the stored procedure here
	@OccupationName varchar(50) = NULL,
	@OccupationDescription varchar(256) = NULL,
	@LeadExposure bit = NULL,
	@NewOccupationID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Occupation ( OccupationName, OccupationDescription, LeadExposure )
					 Values ( @OccupationName, @OccupationDescription, @LeadExposure );
		SELECT @NewOccupationID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPerson]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new people records
-- =============================================
-- DROP PROCEDURE usp_InsertPerson
CREATE PROCEDURE [dbo].[usp_InsertPerson]   -- usp_InsertPerson "Bonifacic",'James','Marco','19750205','M'
	-- Add the parameters for the stored procedure here
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(50) = NULL,
	@LastName varchar(50) = NULL, 
	@BirthDate date = NULL,
	@Gender char(1) = NULL,
	@StatusID smallint = NULL,
	@ForeignTravel bit = NULL,
	@OutofSite bit = NULL,
	@EatsForeignFood bit = NULL,
	@EmailAddress VARCHAR(320) = NULL,
	@RetestDate datetime = NULL,
	@Moved bit = NULL,
	@MovedDate date = NULL,
	@isClosed bit = 0,
	@isResolved bit = 0,
	@New_Notes varchar(3000) = NULL,
	@Release_Notes varchar(3000) = NULL,
	@Hobby_Notes varchar(3000) = NULL,
	@Travel_Notes varchar(3000) = NULL,
	@GuardianID int = NULL,
	@isSmoker bit = NULL,
	@isClient bit = 1,
	@NursingMother bit = 0,
	@NursingInfant bit = 0,
	@Pregnant bit = 0,
	@OverrideDuplicate bit = 0,
	@PID int OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;

	-- set default retest date if none specified
	IF @RetestDate is null
		SET @RetestDate = DATEADD(yy,1,GetDate());
	
	Select @PID = PersonID from Person where Lastname = @LastName and FirstName = @FirstName AND BirthDate = @BirthDate;
	IF (@PID IS NOT NULL AND @OverrideDuplicate = 0)
	BEGIN
		DECLARE @ErrorString VARCHAR(3000);
		SET @ErrorString ='Person appears to be a duplicate of personID: ' + cast(@PID as varchar(256))
		RAISERROR (@ErrorString, 11, -1);
		RETURN;
	END	

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into person ( LastName,  FirstName,  MiddleName,  BirthDate,  Gender,  StatusID, 
							  ForeignTravel,  OutofSite,  EatsForeignFood,  EmailAddress,  RetestDate, 
							  Moved,  MovedDate,  isClosed,  isResolved,  GuardianID,  isSmoker, 
							  isClient, NursingMother, NursingInfant, Pregnant) 
					 Values (@LastName, @FirstName, @MiddleName, @BirthDate, @Gender, @StatusID,
							 @ForeignTravel, @OutofSite, @EatsForeignFood, @EmailAddress, @RetestDate,
							 @Moved, @MovedDate, @isClosed, @isResolved,  @GuardianID, @isSmoker, 
							 @isClient, @NursingMother, @NursingInfant, @Pregnant);
		SET @PID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
							@Person_ID = @PID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Release_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonReleaseNotes]
							@Person_ID = @PID,
							@Notes = @Release_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Travel_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonTravelNotes]
							@Person_ID = @PID,
							@Notes = @Travel_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Hobby_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonHobbyNotes]
							@Person_ID = @PID,
							@Notes = @Hobby_Notes,
							@InsertedNotesID = @NotesID OUTPUT

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonHobbyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert PersonHobby notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonHobbyNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PersonHobby information
		INSERT INTO PersonHobbyNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END



GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Person notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Person information
		INSERT INTO PersonNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonReleaseNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert PersonRelease notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonReleaseNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PersonRelease information
		INSERT INTO PersonReleaseNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoAccessAgreement]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoAccessAgreement records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoAccessAgreement]   -- usp_InsertPersontoAccessAgreement
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@AccessAgreementID int = NULL,
	@AccessAgreementDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoAccessAgreement( PersonID, AccessAgreementID, AccessAgreementDate) --, EndDate)
					 Values ( @PersonID, @AccessAgreementID, @AccessAgreementDate ) -- , @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoDaycare]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoDaycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoDaycare]   -- usp_InsertPersontoDaycare
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DaycareID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DaycareNotes varchar(3000) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoDaycare( PersonID, DaycareID, StartDate, EndDate)
					 Values ( @PersonID, @DaycareID, @StartDate, @EndDate);
		--SELECT SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoEmployer]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoEmployer records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoEmployer]   -- usp_InsertPersontoEmployer
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@EmployerID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoEmployer( PersonID, EmployerID, StartDate, EndDate)
					 Values ( @PersonID, @EmployerID, @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoEthnicity]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoEthnicity records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoEthnicity]   -- usp_InsertPersontoEthnicity
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@EthnicityID int = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- only provide support for association with a single ethnicity as per initial scope
		IF EXISTS (Select PersonID from PersontoEthnicity where PersonID = @PersonID)
			update PersontoEthnicity set EthnicityID = @EthnicityID where PersonID = @PersonID;
		ELSE
			INSERT into PersontoEthnicity( PersonID, EthnicityID )
					Values ( @PersonID, @EthnicityID )

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoFamily]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoFamily records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoFamily]   -- usp_InsertPersontoFamily
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@FamilyID int = NULL,
	@OUTPUT int OUTPUT
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoFamily( PersonID, FamilyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @FamilyID ) -- , @StartDate, @EndDate);
		SELECT @OUTPUT = SCOPE_IDENTITY();
	END TRY
BEGIN CATCH
    -- Call procedure to print error information.
    EXECUTE dbo.uspPrintError;

    -- Roll back any active or uncommittable transactions before
    -- inserting information in the ErrorLog.
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
	RETURN ERROR_NUMBER()
END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoForeignFood]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoForeignFood records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoForeignFood]   -- usp_InsertPersontoForeignFood
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@ForeignFoodID int = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoForeignFood( PersonID, ForeignFoodID ) --, StartDate, EndDate)
					 Values ( @PersonID, @ForeignFoodID ) -- , @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoHobby]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoHobby records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoHobby]   -- usp_InsertPersontoHobby
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@HobbyID int = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoHobby( PersonID, HobbyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @HobbyID ) -- , @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoHomeRemedy]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoHomeRemedy records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoHomeRemedy]   -- usp_InsertPersontoHomeRemedy
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@HomeRemedyID int = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoHomeRemedy( PersonID, HomeRemedyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @HomeRemedyID ) -- , @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoInsurance]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoInsurance records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoInsurance]   -- usp_InsertPersontoInsurance
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@InsuranceID smallint = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoInsurance( PersonID, InsuranceID, StartDate, EndDate, GroupID)
					 Values ( @PersonID, @InsuranceID, @StartDate, @EndDate, @GroupID);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoLanguage]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoLanguage records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoLanguage]   -- usp_InsertPersontoLanguage
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@LanguageID smallint = NULL,
	@isPrimaryLanguage bit = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL,
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		IF EXISTS (SELECT PersonID from PersontoLanguage where PersonID = @PersonID and LanguageID = @LanguageID)
		BEGIN
			-- make sure there are no other primary languages
			IF (@isPrimaryLanguage = 1)
				update PersontoLanguage set isPrimaryLanguage = 0 WHERE PersonID = @PersonID AND LanguageID != @LanguageID AND isPrimaryLanguage = 1
			update PersontoLanguage set isPrimaryLanguage = @isPrimaryLanguage WHERE PersonID = @PersonID AND LanguageID = @LanguageID
		END
		ELSE
			INSERT into PersontoLanguage( PersonID, LanguageID, isPrimaryLanguage ) -- StartDate, EndDate, GroupID)
					 Values ( @PersonID, @LanguageID, @isPrimaryLanguage ) -- @StartDate, @EndDate, @GroupID);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoOccupation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoOccupation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoOccupation]   -- usp_InsertPersontoOccupation
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID smallint = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @return_value int, @ErrorLogID int;

	-- at the very least assume the start date is today
	IF (@StartDate is NULL) SELECT @StartDate = GETDATE();

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoOccupation( PersonID, OccupationID, StartDate, EndDate)
					 Values ( @PersonID, @OccupationID, @StartDate, @EndDate);
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPerson]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150323
-- Description:	Stored Procedure to insert 
--              new PersontoPerson records how 
--              they are related
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoPerson]   -- usp_InsertPersontoPerson
	-- Add the parameters for the stored procedure here
	@Person1ID int = NULL,
	@Person2ID smallint = NULL,
	@RelationshipType int = NULL,
	@isGuardian bit = NULL, -- True if P1 is guardian of P2
	@isPrimaryContact bit = NULL
	--@EndDate date = NULL,
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoPerson( Person1ID, Person2ID, RelationshipTypeID, isGuardian, isPrimaryContact ) 
					 Values ( @Person1ID, @Person2ID, @RelationShipType, @isGuardian, @isPrimaryContact )
		 
		 -- Switch isGuardian information to update reciprocal relationship
		 --IF (@isGuardian = 1) SET @isGuardian = 0;
		 --ELSE SET @isGuardian = 1;
		 
		 --INSERT into PersontoPerson (Person1ID, Person2ID, isGuardian) values (@Person2ID, @Person1ID, @isGuardian)

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoPhoneNumber]   -- usp_InsertPersontoPhoneNumber
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoPhoneNumber( PersonID, PhoneNumberID, NumberPriority)
					 Values ( @PersonID, @PhoneNumberID, @NumberPriority )
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoProperty]   -- usp_InsertPersontoProperty
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@NewPersontoPropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoProperty( PersonID, PropertyID, StartDate, EndDate, isPrimaryResidence)
					 Values ( @PersonID, @PropertyID, @StartDate, @EndDate, @isPrimaryResidence )
		SELECT @NewPersontoPropertyID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoTravelCountry]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoTravelCountry records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoTravelCountry]   -- usp_InsertPersontoTravelCountry
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@TravelCountryID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoTravelCountry( PersonID, CountryID, StartDate, EndDate )
					 Values ( @PersonID, @TravelCountryID, @StartDate, @EndDate )
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonTravelNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert PersonTravel notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonTravelNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PersonTravel information
		INSERT INTO PersonTravelNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumber]   -- usp_InsertPhoneNumber 
	-- Add the parameters for the stored procedure here
	@CountryCode tinyint = 1,
	@PhoneNumber bigint = NULL,
	@PhoneNumberTypeID tinyint = NULL,
	@DEBUG bit = NULL,
	@PhoneNumberID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if the phone number already exists
		SELECT @PhoneNumberID_OUTPUT = PhoneNumberID from PHoneNumber where PhoneNumber = @PhoneNumber

		-- If the phone number doesn't exist, insert it and get the new id
		IF (@PhoneNumberID_OUTPUT IS NULL)
		BEGIN
			IF (@DEBUG = 1)
				SELECT 'INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );', @CountryCode, @PhoneNumber, @PhoneNumberTypeID

			INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );
			SELECT @PhoneNumberID_OUTPUT = SCOPE_IDENTITY();
		END
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumberType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20141220
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumberType]   -- usp_InsertPhoneNumberType
	-- Add the parameters for the stored procedure here
	@PhoneNumberTypeName VarChar(50) = NULL,
	@PhoneNumberTypeID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PhoneNumberType ( PhoneNumberTypeName )
					 Values ( @PhoneNumberTypeName );
		SELECT @PhoneNumberTypeID_OUTPUT = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertProperty]   -- usp_InsertProperty 
	-- Add the parameters for the stored procedure here
	@ConstructionTypeID tinyint = NULL,
	@AreaID int = NULL,
	@isinHistoricDistrict bit = NULL, 
	@isRemodeled bit = NULL,
	@RemodelDate date = NULL,
	@isinCityLimits bit = NULL,
	@AddressLine1 varchar(100) = NULL,
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50) = NULL,
	@State char(2) = NULL,
	@Zipcode varchar(12) = NULL,
	@YearBuilt date = NULL,
	@Ownerid int = NULL,
	@isOwnerOccuppied bit = NULL,
	@ReplacedPipesFaucets tinyint = 0,
	@TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@isResidential bit = NULL,
	@isCurrentlyBeingRemodeled bit = NULL,
	@hasPeelingChippingPaint bit = NULL,
	@County varchar(50) = NULL,
	@isRental bit = NULL,
	@OverRideDuplicate bit = 1,
	@OwnerContactInformation varchar(1000) = NULL,
	@PropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Check if the property already exists, if it does, return the propertyID
		SELECT @PropertyID = [dbo].udf_DoesPropertyExist (
						@AddressLine1,
						@AddressLine2,
						@City,
						@State,
						@ZipCode
						)

		if (@PropertyID iS NOT NULL)
		BEGIN
			if (@OverrideDuplicate = 0)
			BEGIN
				DECLARE @ErrorString VARCHAR(3000);
				SET @ErrorString = 'Property Address ' + @AddressLine1 + ', ' + @City + ', ' + @State + ', ' + @ZipCode
								   + ' '  + ' appears to be a duplicate of: ' + cast(@PropertyID as varchar(30));
				RAISERROR('@PropertyID exists: @AddressLine1, @City, @State, @ZipCode', 11, -1);
				RETURN;
			END

			-- RETURN THE PropertyID of the matching property
			PRINT 'returning existing propertyID: ' + cast(@PropertyID as varchar);
			RETURN;
		END


		 INSERT into property (ConstructionTypeID, AreaID, isinHistoricDistrict, isRemodeled, RemodelDate, 
							  isinCityLimits, AddressLine1, AddressLine2, City, [State], Zipcode,
							  YearBuilt, OwnerID, isOwnerOccuppied, ReplacedPipesFaucets, TotalRemediationCosts,
							  isResidential, isCurrentlyBeingRemodeled, hasPeelingChippingPaint, County, isRental
							  , OwnerContactInformation) 
					 Values ( @ConstructionTypeID, @AreaID, @isinHistoricDistrict, @isRemodeled, @RemodelDate, 
							  @isinCityLimits, @AddressLine1, @AddressLine2, @City, @State, @Zipcode,
							  @YearBuilt, @OwnerID, @isOwnerOccuppied, @ReplacedPipesFaucets, @TotalRemediationCosts,
							  @isResidential, @isCurrentlyBeingRemodeled, @hasPeelingChippingPaint, @County, @isRental
							  , @OwnerContactInformation);
		SET @PropertyID = SCOPE_IDENTITY();

		IF (@New_PropertyNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPropertyNotes]
								@Property_ID = @PropertyID,
								@Notes = @New_PropertyNotes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Property notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPropertyNotes] 
	-- Add the parameters for the stored procedure here
	@Property_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Property information
		INSERT INTO PropertyNotes (PropertyID, Notes) 
				values (@Property_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertySampleResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertySampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertySampleResults]   -- usp_InsertPropertySampleResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PropertyID int = NULL,
	@LabSubmissionDate date = getdate,
	@LabID int = NULL,
	@SampleTypeID tinyint = NULL,
	@Notes varchar(3000) = NULL,
	@NewPropertySampleResultsID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistsPropertyID int, @NotesID int, @Notes_Results int;

	-- check if the property has a record in BloodTestResults Table
	select @ExistsPropertyID = PropertyID from PropertySampleResults


    -- Insert statements for procedure here
	BEGIN TRY
	-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPropertyID is not NULL )
			BEGIN
				SET @isBaseline = 0;
			END
			ELSE -- the person has no entry in BloodTestResults, this is a baseline entry
			BEGIN
				SET @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 0 ) -- this should not be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into PropertySampleResults ( isBaseline, PropertyID, LabSubmissionDate, LabID,
		                                   SampleTypeID )
					 Values ( @isBaseline, @PropertyID, @LabSubmissionDate, @LabID,
		                                   @SampleTypeID );
		SELECT @NewPropertySampleResultsID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	@Notes_results = [usp_InsertPropertySampleResultsNotes]
								@PropertySampleResults_ID = @NewPropertySampleResultsID,
								@Notes = @Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertySampleResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150417
-- Description:	stored procedure to insert PropertySampleResults notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPropertySampleResultsNotes] 
	-- Add the parameters for the stored procedure here
	@PropertySampleResults_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PropertySample information
		INSERT INTO PropertySampleResultsNotes (PropertySampleResultsID, Notes) 
				values (@PropertySampleResults_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoCleanupStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoCleanupStatus records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoCleanupStatus]   -- usp_InsertPropertytoCleanupStatus
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@CleanupStatusID tinyint = NULL,
	@CleanupStatusDate date = NULL,
	@CostofCleanup money = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoCleanupStatus( PropertyID, CleanupStatusID, CleanupStatusDate, CostofCleanup )
					 Values ( @PropertyID, @CleanupStatusID, @CleanupStatusDate, @CostofCleanup )
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoHouseholdSourcesofLead]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoHouseholdSourcesofLead records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoHouseholdSourcesofLead]   -- usp_InsertPropertytoHouseholdSourcesofLead
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@HouseholdSourcesofLeadID int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoHouseholdSourcesofLead( PropertyID, HouseholdSourcesofLeadID )
					 Values ( @PropertyID, @HouseholdSourcesofLeadID )
		SELECT SCOPE_IDENTITY();
	END TRY
		BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoMedium]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoMedium records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoMedium]   -- usp_InsertPropertytoMedium
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@MediumID int = NULL,
	@MediumTested bit = 1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoMedium( PropertyID, MediumID, MediumTested )
					 Values ( @PropertyID, @MediumID, @MediumTested )
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertQuestionnaire]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Questionnaire records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertQuestionnaire]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@QuestionnaireDate date = getdate,
	@QuestionnaireDataSourceID int = NULL,
	@VisitRemodeledProperty bit = NULL,
	@PaintDate date = NULL,
	@RemodelPropertyDate date = NULL,
	@isExposedtoPeelingPaint bit = NULL,
	@isTakingVitamins bit = NULL,
	@NursingMother bit = NULL,
	@NursingInfant bit = NULL,
	@Pregnant bit = NULL,
	@isUsingPacifier bit = NULL,
	@isUsingBottle bit = NULL,
	@BitesNails bit = NULL,
	@NonFoodEating bit = NULL,
	@NonFoodinMouth bit = NULL,
	@EatOutside bit = NULL,
	@Suckling bit = NULL,
	@Mouthing bit = NULL,
	@FrequentHandWashing bit = NULL,
	@VisitsOldHomes bit = NULL,
	@DaycareID int = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG bit = NULL,
	@QuestionnaireID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Questionnaire ( PersonID, QuestionnaireDate, QuestionnaireDataSourceID, VisitRemodeledProperty, PaintDate, RemodelPropertyDate,
		                             isExposedtoPeelingPaint, isTakingVitamins, NursingMother, NursingInfant, Pregnant, isUsingPacifier, isUsingBottle,
									 Bitesnails, NonFoodEating, NonFoodinMouth, EatOutside, Suckling, Mouthing,  FrequentHandWashing,
									 VisitsOldHomes, DaycareID )
					 Values ( @PersonID, @QuestionnaireDate, @QuestionnaireDataSourceID, @VisitRemodeledProperty, @PaintDate, @RemodelPropertyDate,
		                      @isExposedtoPeelingPaint, @isTakingVitamins, @NursingMother, @NursingInfant, @Pregnant, @isUsingPacifier, @isUsingBottle,
							  @Bitesnails, @NonFoodEating, @NonFoodinMouth, @EatOutside, @Suckling, @Mouthing, @FrequentHandWashing,
							  @VisitsOldHomes, @DaycareID );
		SELECT @QuestionnaireID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
		EXEC	[dbo].[usp_InsertQuestionnaireNotes]
							@Questionnaire_ID = @QuestionnaireID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertQuestionnaireNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Questionnaire notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertQuestionnaireNotes] 
	-- Add the parameters for the stored procedure here
	@Questionnaire_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Questionnaire information
		INSERT INTO QuestionnaireNotes (QuestionnaireID, Notes) 
				values (@Questionnaire_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Remediation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediation]   -- usp_InsertRemediation 
	-- Add the parameters for the stored procedure here
	@RemediationApprovalDate date = getdate,
	@RemediationStartDate date = NULL,
	@RemediationEndDate date = NULL,
	@PropertyID int = NULL,
	@RemediationActionPlanID int = NULL,
	@AccessAgreementID int = NULL,
	@FinalRemediationReportFile varbinary(max) = NULL,
	@FinalRemediationReportDate date = Null,
	@RemediationCost money = NULL,
	@OneYearRemediationCompleteDate date = NULL,
	@Notes varchar(3000) = NULL,
	@OneYearRemediatioNComplete bit = NULL,
	@NewRemediationID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @RemediationNotes_return int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Remediation ( RemediationApprovalDate, RemediationStartDate, RemediationEndDate, PropertyID
		                           , RemediationActionPlanID, AccessAgreementID, FinalRemediationReportFile, FinalRemediationReportDate
								   , RemediationCost, OneYearRemediationCompleteDate, OneYearRemediationComplete )
					 Values ( @RemediationApprovalDate, @RemediationStartDate, @RemediationEndDate, @PropertyID
		                      , @RemediationActionPlanID, @AccessAgreementID, @FinalRemediationReportFile, @FinalRemediationReportDate
							  , @RemediationCost, @OneYearRemediationCompleteDate, @OneYearRemediationComplete);
		SELECT @NewRemediationID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertRemediationNotes]
								@Remediation_ID = @NewRemediationID,
								@Notes = @Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediationActionPlan]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new RemediationActionPlan records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediationActionPlan]   -- usp_InsertRemediationActionPlan 
	-- Add the parameters for the stored procedure here
	@RemediationActionPlanApprovalDate date = getdate,
	@HomeOwnerConsultationDate date = NULL,
	@ContractorCompletedInvestigationDate date = NULL,
	@EnvironmentalInvestigationID int = NULL,
	@RemediationActionPlanFinalReportSubmissionDate date = NULL,
	@RemediationActionPlanFile varbinary(max) = NULL,
	@PropertyID int = NULL,
	@NewRemediationActionPlanID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into RemediationActionPlan ( RemediationActionPlanApprovalDate, HomeOwnerConsultationDate, ContractorCompletedInvestigationDate
		                                     , EnvironmentalInvestigationID, RemediationActionPlanFinalReportSubmissionDate,
											 RemediationActionPlanFile, PropertyID )
					 Values ( @RemediationActionPlanApprovalDate, @HomeOwnerConsultationDate, @ContractorCompletedInvestigationDate
								, @EnvironmentalInvestigationID, @RemediationActionPlanFinalReportSubmissionDate
								, @RemediationActionPlanFile, @PropertyID );
		SELECT @NewRemediationActionPlanID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediationNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150417
-- Description:	stored procedure to insert Remediation notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertRemediationNotes] 
	-- Add the parameters for the stored procedure here
	@Remediation_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Remediation information
		INSERT INTO RemediationNotes (RemediationID, Notes) 
				values (@Remediation_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END



GO
/****** Object:  StoredProcedure [dbo].[usp_InsertSampleLevelCategory]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new SampleLevelCategory records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertSampleLevelCategory]   -- usp_InsertSampleLevelCategory 
	-- Add the parameters for the stored procedure here
	@SampleLevelCategoryName varchar(20) = NULL,
	@SampleLevelCategoryDescription varchar(256) = NULL,
	@NewSampleLevelCategoryID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into SampleLevelCategory ( SampleLevelCategoryName, SampleLevelCategoryDescription )
					 Values ( @SampleLevelCategoryName, @SampleLevelCategoryDescription );
		SELECT @NewSampleLevelCategoryID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertSampleType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new SampleType records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertSampleType]   -- usp_InsertSampleType 
	-- Add the parameters for the stored procedure here
	@SampleTypeName varchar(20) = NULL,
	@SampleTypeDescription varchar(256) = NULL,
	@NewSampleTypeID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into SampleType ( SampleTypeName, SampleTypeDescription )
					 Values ( @SampleTypeName, @SampleTypeDescription );
		SELECT @NewSampleTypeID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Status records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertStatus]   -- usp_InsertStatus 
	-- Add the parameters for the stored procedure here
	@StatusName varchar(20) = NULL,
	@StatusDescription varchar(256) = NULL,
	@NewStatusID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Status ( StatusName, StatusDescription )
					 Values ( @StatusName, @StatusDescription );
		SELECT @NewStatusID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertTravelNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	stored procedure to insert Travel notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertTravelNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Travel_Notes VARCHAR(3000) = NULL,
	@Start_Date date = NULL,
	@End_Date date = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Property information
		INSERT INTO TravelNotes (FamilyID, Notes, StartDate, EndDate) 
				values (@Family_ID, @Travel_Notes, @Start_Date, @End_Date);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END



GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResults] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(4,1) = NULL,
	@Max_Lead_Value numeric(4,1) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 
	BEGIN
    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'SELECT ''ClientID'' = [P].[personid], ''LastName'' = [P].[LastName], [P].[FirstName], ''BirthDate'' = [P].[BirthDate]
								, [BTR].[SampleDate], ''Pb_ug_Per_dl'' = [BTR].[LeadValue]
								, ''Hb_g_Per_dl'' = [BTR].[HemoglobinValue], ''RetestBL'' = [P].[RetestDate]
								, ''Closed'' = [P].[isClosed] , ''Moved'' = [P].[Moved], ''Movedate'' = [P].[MovedDate]
							from [Person] [P]
							join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
							WHERE [P].[isClient] = 1'

	IF @Person_ID IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID'
		SET @OrderBy = ' ORDER BY [BTR].[LeadValue],[BTR].[SampleDate] desc'
	END

	IF @Min_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] >= @MinLeadValue'
	END

	IF @Max_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] < @MaxLeadValue'
	END

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr;
		SET @OrderBy = N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END


	SELECT @spexecutesqlStr = @spexecutesqlStr + @OrderBy

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value IS NULL) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PersonID' = @Person_ID, 'MinLeadValue' = @Min_Lead_Value, 'MaxLeadValue' = @Max_Lead_Value, 'Recompile' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value, @MaxLeadValue = @Max_Lead_Value;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResults2]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResults2] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(4,1) = NULL,
	@Max_Lead_Value numeric(4,1) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 


    -- Insert statements for procedure here
	SET FMTONLY OFF
	SELECT @spexecutesqlStr = N'SELECT ''ClientID'' = [P].[personid], ''LastName'' = [P].[LastName], ''BirthDate'' = [P].[BirthDate]
								, [BTR].[SampleDate], ''Pb_ug_Per_dl'' = [BTR].[LeadValue], ''Hb_g_per_dl'' = [BTR].[HemoglobinValue], ''RetestDate'' = [P].[RetestDate]
								, ''Close'' = [P].[isClosed], ''Moved'' = [P].[Moved], ''Movedate'' = [P].[MovedDate]
							from [Person] [P]
							join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
							WHERE 1 = 1'

	IF @Person_ID IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID'
		SET @OrderBy = ' ORDER BY [BTR].[LeadValue],[BTR].[SampleDate] desc'
	END

	IF @Min_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] >= @MinLeadValue'
	END

	IF @Max_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] <= @MaxLeadValue'
	END

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr;
		SET @OrderBy = N' ORDER BY [BTR].[Leadvalue], [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END


	SELECT @spexecutesqlStr = @spexecutesqlStr + @OrderBy

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value IS NULL) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PersonID' = @Person_ID, 'MinLeadValue' = @Min_Lead_Value, 'MaxLeadValue' = @Max_Lead_Value, 'Recompile' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value, @MaxLeadValue = @Max_Lead_Value;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResultsMetaData]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResultsMetaData] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 
	BEGIN
    -- Insert statements for procedure here
	SELECT 'ClientID' = [P].[personid], 'LastName' = [P].[LastName], 'BirthDate' = [P].[BirthDate]
				, [BTR].[SampleDate], 'Pb_ug_Per_dl' = [BTR].[LeadValue]
				, 'Hb_g_Per_dl' = [BTR].[HemoglobinValue], 'RetestBL' = DATEADD(yy,1,sampledate)
				, 'RetestHB' = DATEADD(yy,1,sampledate), 'Close' = [P].[isClosed], 'Moved' = [P].[Moved]
				, 'Movedate' = [P].[MovedDate]
			from [Person] [P]
			join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
			WHERE 1 = 0
	END
END




GO
/****** Object:  StoredProcedure [dbo].[usp_SlChildStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlChildStatus] 
	-- Add the parameters for the stored procedure here
	@TargetType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(3000)

	select @spexecutesqlStr =''


    -- Insert statements for procedure here
	SELECT [TS].[StatusName],[TS].[StatusID] from [TargetStatus] AS [TS]
	where 1 = 1 AND TargetType = 'Person'

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlClientFollowUp]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150715
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlClientFollowUp]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [P].[PersonID],[P].[LastName],[P].[Firstname],[P].[RetestDate]  from [person] as [p]
		 where 1=1';

	IF (@StartDate IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[RetestDate] >= @StartDate';

	IF (@EndDate IS NOT NULL)
	BEGIN
		SET @EndDate = DateAdd(dd,1,@EndDate);
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[RetestDate] < @EndDate';
	END

	SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' order by [P].[RetestDate] ASC'

	IF (DateDiff(yy,@EndDate,@StartDate) > 4) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@StartDate date, @EndDate date'
			, @StartDate = @StartDate
			, @EndDate = @EndDate;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlColumnDetails]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141124
-- Description:	stored procedure to list column details for each column in a table
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlColumnDetails] 
	-- Add the parameters for the stored procedure here
	@TableName varchar(256) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Table' = @TableName,
    c.name 'Column Name',
    t.Name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL(i.is_primary_key, 0) 'Primary Key'
	FROM    
		sys.columns c
	INNER JOIN 
		sys.types t ON c.user_type_id = t.user_type_id
	LEFT OUTER JOIN 
		sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	LEFT OUTER JOIN 
		sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
	WHERE
		c.object_id = OBJECT_ID(@TableName)
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountAdults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150610
-- Description:	User defined stored procedure to
--              count adults visiting during 
--				reporting period
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountAdults]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinAge tinyint = 17,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE  @ErrorLogID int, @ReturnError int;

	BEGIN TRY 

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101'

		IF (@ENDDate IS NULL)
			SET @EndDate = GetDate();

		SET @EndDate = DateAdd(dd,1,@EndDate);

		-- Create temporary table
		CREATE Table #TempPotentialAdults
		( PersonID int 
			, TestID int
			, AgeAtVisit tinyint
			, MostRecentVisit date
			, Birthdate date
			, Visits tinyint
		)

		-- insert values from bloodtest results
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				select PersonID,MostRecentVisit = SampleDate, TestID = BloodTestResultsID 
				from BloodtestResults 
					where SampleDate >= @StartDate AND SampleDate < @EndDate 

		-- insert values from questionnaire	
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				Select PersonID,MostRecentVisit = QuestionnaireDate, TestID = QuestionnaireID 
				from Questionnaire 
					where QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
					and (ISNULL(Questionnaire.NursingMother,0) = 0 OR  ISNULL(Questionnaire.Pregnant,0) = 0 )

		-- populate birthdate only if the difference from most recent visit to birthdate is at least minAge
			update #TempPotentialAdults set BirthDate = Person.Birthdate,
				 AgeAtVisit = [dbo].[udf_CalculateAge]([Person].[BirthDate],MostRecentVisit)
			FROM #TempPotentialAdults
			JOIN Person on Person.PersonID = #TempPotentialAdults.PersonID
			where Datediff(yy,Person.BirthDate,MostRecentVisit) > @MinAge

		Select AdultsTested = count(distinct PersonID) from #TempPotentialAdults
		where AgeAtVisit > @MinAge

		drop table #TempPotentialAdults
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		-- DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountBloodLeadLevels]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150601
-- Description:	procedure returns the number of 
--				entries in the persons table
--				with blood test results within 
--				the specified date range, and 
--				>= 5 and < 10
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountBloodLeadLevels] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT EBLLTests = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1';

		IF (@MinLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND Leadvalue >= @MinLeadValue';
		
		IF (@MaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue <= @MaxLeadValue';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate';

		IF (@EndDate IS NOT NULL)
		BEGIN
			SET @EndDate = DateAdd(dd,1,@EndDate);
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate';
		END
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @MinLeadValue
		, @MaxLeadValue = @MaxLeadValue;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountBloodTests]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountBloodTests] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT BloodTests = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1';

		IF (@MinLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND Leadvalue >= @MinLeadValue';
		
		IF (@MaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue <= @MaxLeadValue';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate';

		IF (@EndDate IS NOT NULL)
		BEGIN
			SET @EndDate = DateAdd(dd,1,@EndDate);
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate';
		END

		IF ( (DATEDIFF(YYYY,@StartDate,@EndDate)) > 5)
			SET @Recompile = 0;

		IF ( (@MaxLeadValue - @MinLeadValue) > 5)
			SET @Recompile = 0;
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @MinLeadValue
		, @MaxLeadValue = @MaxLeadValue;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountClients]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountClients] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);

		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar)
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select  Clients = count(PersonID) from (
			SELECT  PersonID from bloodTestResults WHERE 1=1 AND SampleDate >= @StartDate AND SampleDate < @EndDate
			UNION
			SELECT  PersonID from Questionnaire WHERE 1=1 AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
			) total';
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountFamilyMembers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141125
-- Description:	stored procedure to count family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname], Members = count([P].[Lastname]) from [Family] AS [F]
		 LEFT OUTER JOIN [persontoFamily] [p2f] on [F].[FamilyID] = [p2F].[Familyid] 
		 LEFT OUTER JOIN [Person] AS [P] on [P].[Personid] = [p2f].[Personid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' group by [f].[familyid],[f].[lastname]
			order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @FamilyID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountHomeVisitSoilSample]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150611
-- Description:	User defined stored procedure to
--              count clients that have a status
--				of home visit and/or soil sample
--              during the reporting period
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountHomeVisitSoilSample]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	IF (@StartDate IS NULL)
		SET @StartDate = '18000101'

	IF (@ENDDate IS NULL)
		SET @EndDate = GetDate();

	SET @EndDate = DateAdd(dd,1,@EndDate);

	select @spexecutesqlStr ='select [HomeVisitSoilSamples] = count(PersonID) from (
						SELECT PersonID
						from BloodTestResults where SampleDate >= @StartDate and SampleDate < @EndDate
								AND ClientStatusID in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
														where TargetType = ''Person''
														AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')
													  )
						UNION
						-- people with questionnaire but no blood test during reporting period
						Select Q.PersonID
						from Questionnaire AS Q
								LEFT OUTER JOIN  [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
																select top 1 [BloodTestResultsID] from [BloodTestResults] 
																where [BloodTestResults].[PersonID] = [Q].[PersonID]
																-- AND SampleDate >= @StartDate AND SampleDate < @EndDate
																AND BTR.ClientStatusID
																	in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
																			where TargetType = ''Person''
																			AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
																		)
																order by SampleDate desc
																)
								where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate 
								AND BTR.ClientStatusID
									in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
											where TargetType = ''Person''
											AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
										)
						) HomeVisitSoilSamples';
	
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		-- DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountNewClients]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				clients onboarded during the 
--              reporting period.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountNewClients] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();
		
		SET @EndDate = DateAdd(dd,1,@EndDate);

		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar);
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select  NewClients = count(PersonID) from Person WHERE isClient = 1';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate >= @StartDate';
	
		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate < @EndDate';
					
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountNewPeople]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountNewPeople] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);

		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar);
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select  NewPeople = count(PersonID) from Person WHERE 1=1';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate >= @StartDate';
	
		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate < @EndDate';
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountNursingInfants]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150607
-- Description:	procedure returns the number of 
--				nursing infants that either had a
--              bloodtest or completed a questionnaire
--				within the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountNursingInfants] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);
		
		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar);
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select [NursingInfants] = COUNT(PersonID) from (
									Select BTR.PersonID,Q.NursingInfant from BloodTestResults AS BTR
									LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																	select TOP 1 [QuestionnaireID] from [Questionnaire] 
																	where [Questionnaire].[PersonID] = [BTR].[PersonID]
																	AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																	order by NursingInfant desc
																	)
									where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingInfant = 1

									UNION 
									SELECT PersonID,NursingInfant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
									AND NursingInfant = 1
								) ClientsinReportingPeriod
								where ClientsinReportingPeriod.NursingInfant = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountNursingMothers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150607
-- Description:	procedure returns the number of 
--				nursing Mothers that either had a
--              bloodtest or completed a questionnaire
--				within the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountNursingMothers] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);
		
		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar)
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		SELECT @spexecutesqlStr = 'Select [NursingMothers] = COUNT(PersonID) from (
								Select BTR.PersonID,Q.NursingMother from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by NursingMother desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingMother = 1

								UNION 
								SELECT PersonID,NursingMother from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND NursingMother = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.NursingMother = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeople]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 2/13/2014
-- Description:	procedure returns the number of entries in the persons table, being the number of participants
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeople] 
	-- Add the parameters for the stored procedure here
	@Max_Age int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @MaxAge int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT NewPeople = count([PersonId]) from [person] WHERE 1=1';

		IF (@Max_Age IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [Age] <= @MaxAge';
		
		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate >= @StartDate';
	
		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate < @EndDate';

		SET @EndDate = DateAdd(dd,1,@EndDate);
		
		IF @Recompile = 1
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@MaxAge VARCHAR(50),@StartDate date, @EndDate date'
		, @MaxAge = @Max_Age
		, @StartDate = @StartDate
		, @EndDate = @EndDate;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAge]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141222
-- Description:	returns count of people grouped by 
--              age. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAge]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='select Age, ''Personcount'' = count(PersonID)
		from [person]
		where isClient = 1';
	
	-- group people by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' group by [dbo].udf_CalculateAge(BirthDate,GetDate())';

	-- order by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' order by Age';

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';
	
	EXEC [sp_executesql] @spexecutesqlStr
 --   , N'@LastName varchar(50)'
	--, @LastName = @Last_Name;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAgeGroup]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150112
-- Description:	returns count of people grouped by 
--              age categories. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAgeGroup]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;


	; with AgeGroups as 
	(  SELECT CASE
		  WHEN Age < 1 THEN '0'
		  WHEN Age >= 1 and Age < 4 THEN '01 - 03'
		  WHEN Age >= 4 AND Age < 7 THEN '04 - 06'
		  WHEN Age >= 7 AND Age < 18 THEN '07 - 17'
		  ELSE '18 and Over' 
	  END  AS Groups
	  -- , MaxAge = max(Person.Age)
	  FROM Person
	  where isClient = 1
	)

	SELECT ROW_NUMBER() OVER(ORDER BY Groups DESC) AS Row, AgeGroups = Coalesce(Groups,'Total'), 
								Clients =  Count(Groups) From AgeGroups group by Groups;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT AgeGroups = Coalesce(Groups,''Total''), 
								Clients =  Count(Groups) From AgeGroups group by Groups with ROLLUP';
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByLastName]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByLastName]
		@Last_Name VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @spExecutesqlStr NVARCHAR(4000), @Recompile BIT = 1;

	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT [lastname],''Members'' = count([firstname]) from [person] WHERE 1=1';

		if (@Last_Name is not NULL)
		BEGIN
			SET @Recompile = 1;
			SELECT @spExecutesqlStr = @spExecutesqlStr + ' AND [person].[LastName] = @LastName'
		END
		ELSE
			SET @Recompile = 0

		-- Group by last name for counting purposes
		SELECT @spExecutesqlStr = @spExecutesqlStr + ' group by [lastname]'

		-- force recompile for selective query
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spExecutesqlStr 
			, N'@LastName VARCHAR(50)'
			, @LastName = @Last_Name;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPregnantWomen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Liam Thier
-- Create date: 20150610
-- Description:	User defined stored procedure to
--              count Pregnant Women
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPregnantWomen]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	IF (@StartDate IS NULL)
		SET @StartDate = '18000101'

	IF (@ENDDate IS NULL)
		SET @EndDate = GetDate();

	SET @EndDate = DateAdd(dd,1,@EndDate);
	
	select @spexecutesqlStr ='Select [PregnantWomen] = COUNT(PersonID) from (
								Select BTR.PersonID,Q.Pregnant from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by Pregnant desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.Pregnant = 1

								UNION 
								SELECT PersonID,Pregnant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND Pregnant = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.Pregnant = 1';
	
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime'
		, @StartDate = @StartDate
		, @EndDate = @EndDate;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		-- DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlDaycare]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	returns daycare name, id, description
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlDaycare] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select DaycareID,DaycareName,DaycareDescription from Daycare order by DaycareName

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditBloodTestResultsWebScreenInformation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to select 
--              bloodtestresults edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditBloodTestResultsWebScreenInformation]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@PersonID IS NULL)
	BEGIN
		RAISERROR ('You must supply a person.', 11, -1);
		RETURN;
	END;
	
	SELECT @spexecuteSQLStr =
		N'select [BTR].[BloodTestResultsID]
		,[BTR].[SampleDate]
		,[BTR].[LabSubmissiondate]
		,[L].[LabName]
		,[BTR].[LeadValue]
		,[FollowupDate] = [P].[RetestDate]
		,[ST].[SampleTypeName]
		,[TS].[StatusName]
		,[BTR].[HemoglobinValue]
		from [BloodTestResults] AS [BTR]
		LEFT OUTER JOIN [Person] AS [P] on [BTR].[PersonID] = [P].[PersonID]
		LEFT OUTER JOIN [Lab] AS [L] on [BTR].[LabID] = [L].[LabID]
		LEFT OUTER JOIN [SampleType] AS [ST] on [BTR].[SampleTypeID] = [ST].[SampleTypeID]
		LEFT OUTER JOIN [TargetStatus] AS [TS] on [BTR].[ClientStatusID] = [TS].[StatusID]
		where [BTR].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [BTR].[SampleDate] desc';
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditClientInfoWebScreenInformation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150408
-- Description:	stored procedure to select 
--              person edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditClientInfoWebScreenInformation]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@PersonID IS NULL)
	BEGIN
		RAISERROR ('You must supply a person.', 11, -1);
		RETURN;
	END;

	SELECT @spexecuteSQLStr =
		N'select [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[MiddleName]
		,[P].[Birthdate],[P].[Gender]
		,[P].[isClient]
		,[L].[LanguageID]
		,[L].[LanguageName]
		,[E].[EthnicityID]
		,[E].[Ethnicity]
		,[P].[Moved]
		,[MovedOutofCounty] = cast([P].[OutofSite] as varchar)
		,[TravelV] = cast([P].[ForeignTravel] as varchar)
		,[P].[EmailAddress]
		from [Person] AS [P]
		LEFT OUTER JOIN [PersontoLanguage] AS [PL] on [P].[PersonID] = [PL].[PersonID]
		LEFT OUTER JOIN [Language] AS [L] ON [PL].[LanguageID] = [L].[LanguageID]
		LEFT OUTER JOIN [PersontoEthnicity] AS [PE] ON [PE].[PersonID] = [P].[PersonID]
		LEFT OUTER JOIN [Ethnicity] AS [E] ON [PE].[EthnicityID] = [E].[EthnicityID]
		where [P].[PersonID] = @PersonID';

	
	IF EXISTS ( SELECT PersonID from PersontoLanguage where PersonID = @PersonID ) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [PL].[isPrimaryLanguage] = 1';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [L].[CreatedDate] desc';
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditFamilyWebScreenInformation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns Family Lastname, Primary Address,
--				Primary phonenumber, Secondary phonenumber,
--				number of smokers, number of pets,
--				if pets are in and out pets,
--				if pets are washed frequently
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditFamilyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Family_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @PrimaryPhoneNumber bigint, @SecondaryPhoneNumber bigint,
			@spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@Family_ID IS NULL)
	BEGIN
		RAISERROR ('You must supply the Family.', 11, -1);
		RETURN;
	END;
	
	-- Select Primary Phone number
	select  @PrimaryPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 1)

	-- Select Secondary Phone number
	select  @SecondaryPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 2)
	
	SELECT @spexecuteSQLStr =
		N'SELECT [F].[FamilyID],[F].[Lastname],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode],YearBuilt = cast([P].[YearBuilt] as date)
			,MoveinDate = cast(StartDate as date), MoveoutDate = cast(EndDate as date)
			, [OwnerOccupied] = cast([P].[isOwnerOccuppied] as varchar)
			, PrimaryPhoneNumber = @PrimaryPhoneNumber, SecondaryPhoneNumber = @SecondaryPhoneNumber
			,[F].[NumberofSmokers],[F].[Pets],Petsinandout = cast([F].[Petsinandout] as varchar)
			, [P].[OwnerContactInformation]
		FROM [Family] AS [F]
		JOIN [Property] AS [P] ON [F].[PrimaryPropertyID] = [P].[PropertyID]
		JOIN [FamilytoProperty] AS [F2P] ON [F].[FamilyID] = [F2P].[FamilyID] AND [F].[PrimaryPropertyID] = [F2P].[PropertyID]
		WHERE 1 = 1'

	IF (@Family_ID IS NULL)
		SET @Recompile = 0;

	IF (@Family_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and [F].[FamilyID] = @FamilyID ORDER by [F].[FamilyID] desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @Family_ID, 'PrimaryPhoneNumber' = @PrimaryPhoneNumber, 'SecondaryPhoneNumber' = @SecondaryPhoneNumber;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@FamilyID int, @PrimaryPhoneNumber bigint, @SecondaryPhoneNumber bigint'
			, @FamilyID = @Family_ID
			, @PrimaryPhoneNumber = @PrimaryPhoneNumber
			, @SecondaryPhoneNumber = @SecondaryPhoneNumber;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditPropertyWebScreenInformation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns AddressLine1, Addressline2
--				City, State, and Zipcode
--				of a specific property
--				if no property ID is passed in, 
--				informatin is returned for all properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditPropertyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Property_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P].[PropertyID],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode]
			FROM [Property] AS [P]
			WHERE 1 = 1'

	IF (@Property_ID IS NULL)
		SET @Recompile = 0;

	IF (@Property_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and PropertyID = @PropertyID ORDER by PropertyID desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PropertyID' = @Property_ID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PropertyID int'
			, @PropertyID = @Property_ID;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END



GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditQuestionnaireWebScreenInformation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to select 
--              questionnaire edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditQuestionnaireWebScreenInformation]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@PersonID IS NULL)
	BEGIN
		RAISERROR ('You must supply a person.', 11, -1);
		RETURN;
	END;
	
	SELECT @spexecuteSQLStr =
		N'select [Q].[QuestionnaireID]
		, [Q].[QuestionnaireDate]
		, [Q].[isExposedtoPeelingPaint]
		, [Q].[PaintDate]
		, [Q].[VisitRemodeledProperty]
		, [Q].[VisitsOldHOmes]
		, [Q].[RemodelPropertyDate]
		, [Q].[isTakingVitamins]
		, [Q].[FrequentHandWashing]
		, [Q].[isUsingBottle]
		, [Q].[NursingMother]
		, [Q].[Pregnant]
		, [Q].[NursingInfant]
		, [Q].[isUsingPacifier]
		, [Q].[BitesNails]
		, [Q].[EatOutside]
		, [Q].[NonFoodinMouth]
		, [Q].[NonFoodEating]
		, [Q].[Suckling]
		, [Q].[Mouthing]
		from [Questionnaire] AS [Q]
		where [Q].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [Q].[QuestionnaireDate] desc';
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyMembers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname], [P].[LastName], [P].[FirstName] from [Family] AS [F]
		 LEFT OUTER JOIN [persontoFamily] [p2f] on [F].[FamilyID] = [p2F].[Familyid] 
		 LEFT OUTER JOIN [Person] AS [P] on [P].[Personid] = [p2f].[Personid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @FamilyID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyNametoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141123
-- Description:	User defined stored procedure to
--              select family and property address
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyNametoProperty]
	-- Add the parameters for the stored procedure here
	@Family_Name varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT ''FamilyName'' = [F].[LastName],[Prop].[StreetNumber],[Prop].[Street],[Prop].[StreetSuffix],[Prop].[ZipCode]
	from [family] AS [F]
	join [Property] as [Prop] on [F].[PrimaryPropertyID] = [Prop].[PropertyID]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	IF (@Family_Name IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [F].[LastName] = @FamilyName'
	ELSE
	    SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@FamilyName varchar(50)'
		, @FamilyName = @Family_Name;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlHobby]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150620
-- Description:	returns hobby name, id, description
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlHobby] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select HobbyID,HobbyName,HobbyDescription from Hobby order by HobbyName

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedData]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedData] 
	-- Add the parameters for the stored procedure here
	@Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'SELECT [P].[PersonID] 
								, ''FamilyLastName'' = [F].[Lastname]
								, [P].[LastName]
								, [P].[MiddleName]
								, [P].[FirstName]
								, [P].[BirthDate]
								, [P].[Gender]
								, ''StreetAddress'' = cast([Prop].[StreetNumber] as varchar)
									+ '' ''+ cast([Prop].[Street] as varchar) + '' '' 
									+ cast([Prop].[StreetSuffix] as varchar)
								, [Prop].[ApartmentNumber]
								, [Prop].[City]
								, [Prop].[State]
								, [Prop].[Zipcode]
								, ''PrimaryPhoneNumber'' = [Ph].[PhoneNumber]
								, [L].[LanguageName]
								, [F].[NumberofSmokers]
								, [F].[Pets]
								, [F].[inandout]
								, [F].[Notes]
								, [P].[Moved]
								, [P].[ForeignTravel]
								, [P].[OutofSite]
								, [H].[HobbyName]
								, [P].[Notes]
								, [P].[isSmoker]
								, [P].[RetestDate]
								, [Q].[QuestionnaireDate]
								, [Q].[isExposedtoPeelingPaint]
								, ''PaintAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[VisitRemodeledProperty]
								, ''RemodelPropertyAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[isTakingVitamins]
								, [Q].[FrequentHandWashing]
								, [Q].[isUsingBottle]
								, [Q].[isNursing]
								, [Q].[isUsingPacifier]
								, [Q].[BitesNails]
								, [Q].[EatOutside]
								, [Q].[NonFoodinMouth]
								, [Q].[NonFoodEating]
								, [Q].[Suckling]
								, [Q].[Daycare]
								, [Q].[Source]
								, [Q].[Notes]
								, [BTR].[SampleDate]
								, [BTR].[LabSubmissionDate]
								, [Lab].[LabName]
								, ''What is status code?''
								, [BTR].[HemoglobinValue]
						  FROM [LeadTrackingTesting-Liam].[dbo].[Person] AS [P]
						  LEFT OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
						  LEFT OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
						  LEFT OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
						  LEFT OUTER JOIN [Questionnaire] as [Q] on [P].[PersonID] = [Q].[PersonID]
						  LEFT OUTER JOIN [BloodTestResults] as [BTR] on [P].[PersonID] = [BTR].[PersonID]
						  LEFT OUTER JOIN [PersontoLanguage] as [P2L] on [P2L].[PersonID] = [P].[PersonID]
						  LEFT OUTER JOIN [Language] as [L] on [L].LanguageID = [P2L].[LanguageID]
						  LEFT OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
						  LEFT OUTER JOIN [PersontoPhoneNumber] as [P2Ph] on [P].[PersonID] = [P2Ph].[PersonID]
						  LEFT OUTER JOIN [PhoneNumber] as [Ph] on [Ph].[PhoneNumberID] = [P2Ph].[PhoneNumberID]
						  LEFT OUTER JOIN [PhoneNumberType] as [PhT] on [Ph].[PhoneNumberTypeID] = [PhT].[PhoneNumberTypeID]
						  LEFT OUTER JOIN [PersontoHobby] as [P2H] on [P].PersonID = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Hobby] as [H] on [H].[HobbyID] = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Lab] on [BTR].[LabID] = [Lab].[LabID]
							WHERE 1 = 1'

	if @Last_Name IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[LastName] = @LastName ORDER BY [P].[PersonID] desc'
	ELSE
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [P].[PersonID] desc'

	IF @Last_name is NULL
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@Lastname varchar(50)'
		, @LastName = @Last_name;  
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedDataSimplified]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedDataSimplified] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int
			, @DEBUG BIT = 0;

    -- Insert statements for procedure here
	BEGIN TRY
	SELECT [P].[PersonID] 
		, 'P2FPersonID' = [P2F].[PersonID]
		, 'FamilyLastName' = [F].[Lastname]
		, [F].[FamilyID]
		, 'P2FFamilyID' = [P2F].[FamilyID]
		, [P].[LastName]
		, [P].[MiddleName]
		, [P].[FirstName]
		, [P].[BirthDate]
		, [P].[Gender]
		--, 'StreetAddress' = cast([Prop].[StreetNumber] as varchar)
		--	+ ' '+ cast([Prop].[Street] as varchar) + ' ' 
		--	+ cast([Prop].[StreetSuffix] as varchar)
		--, [Prop].[ApartmentNumber]
		--, [Prop].[City]
		--, [Prop].[State]
		--, [Prop].[Zipcode]
		--, 'PrimaryPhoneNumber' = [Ph].[PhoneNumber]
		--, [L].[LanguageName]
		, [F].[NumberofSmokers]
		, [F].[Pets]
		, [F].[Petsinandout]
		, [FN].[Notes]

	FROM [Person] AS [P]
	FULL OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
	FULL OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
	FULL OUTER JOIN [FamilyNotes] AS [FN] on [F].[FamilyID] = [FN].[FamilyID]
--	FULL OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
--	FULL OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
	-- where [P2F].FamilyID is NULL
	--  People to families: 3470

	
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlLabName]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150304
-- Description:	Lists lab names
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlLabName] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select LabName from Lab where LabName in ('LeadCare II','Tamarac','Quest Diagnostic','Other')

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLListAllFamilyMembers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150103
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListAllFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname],[P].[LastName],[P].[Firstname]  from [person] as [p]
		 join [persontoFamily] [p2f] on [p].[personid] = [p2f].[personid] 
		 join [family] AS [f] on [f].[familyid] = [p2f].[familyid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[FamilyID],[f].[lastname]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlListClientsByCreatedate]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select People by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListClientsByCreatedate]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[MiddleName],[P].[FirstName],[P].[BirthDate]
								,[P].[Gender],[P].[Age],[P].[ModifiedDate],[P].[CreatedDate]
								from [Person] AS [P]
								where 1 = 1';
	
	-- Return all People if nothing was passed in
	IF ((@StartDate is NULL) AND (@EndDate is NULL))
		SET @Recompile = 0;

	IF (@StartDate is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate';

	IF (@EndDate is NOT NULL)
	BEGIN
		SET @EndDate = DateAdd(dd,1,@EndDate)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate';
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC';
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @StartDate
		, @EndDate = @EndDate;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlListClientsByModifieddate]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select People by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListClientsByModifieddate]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[MiddleName],[P].[FirstName],[P].[BirthDate],[P].[Gender],[P].[ModifiedDate]
								from [Person] AS [P]
								where 1 = 1';

	-- Return all People if nothing was passed in
	IF ((@StartDate is NULL) AND (@EndDate is NULL))
		SET @Recompile = 0;

	IF (@StartDate is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] >= @BeginDate';

	IF (@EndDate is NOT NULL)
	BEGIN
		SET @EndDate = DateAdd(dd,1,@EndDate)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] < @EndDate';
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[ModifiedDate] ASC, [P].[LastName],
	[P].[PersonID] ASC';
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @StartDate
		, @EndDate = @EndDate;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlListFamilies]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150110
-- Description:	User defined stored procedure to
--              select all families
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListFamilies]
	-- Add the parameters for the stored procedure her
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT [F].[FamilyID], ''FamilyName'' = [F].[LastName]
	from [family] AS [F]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName],[F].[FamilyID]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListFamilyMembers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150103
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname],[P].[LastName],[P].[Firstname]  from [person] as [p]
		 join [persontoFamily] [p2f] on [p].[personid] = [p2f].[personid] 
		 join [family] AS [f] on [f].[familyid] = [p2f].[familyid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListNursingWomenbyCreateDateRange]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select NursingWomen by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListNursingWomenbyCreateDateRange]
	-- Add the parameters for the stored procedure here
	@Begin_Date date = NULL,
	@End_Date date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[CreatedDate]
								from [Person] AS [P]
								where NursingMother = 1'
	
	-- Return all NursingWomen if nothing was passed in
	IF ((@Begin_Date is NULL) AND (@End_Date is NULL))
		SET @Recompile = 0

	IF (@Begin_Date is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate'

	IF (@End_Date is NOT NULL)
	BEGIN
		SET @End_Date = DateAdd(dd,1,@End_Date)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate'
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @Begin_Date, 'ENDDate' = @End_Date, 'DEBUG' = @Debug

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @Begin_Date
		, @EndDate = @End_Date;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlListPeoplebyCreateDateRange]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select People by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListPeoplebyCreateDateRange]
	-- Add the parameters for the stored procedure here
	@Begin_Date date = NULL,
	@End_Date date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[CreatedDate]
								from [Person] AS [P]
								where 1 = 1';
	
	-- Return all People if nothing was passed in
	IF ((@Begin_Date is NULL) AND (@End_Date is NULL))
		SET @Recompile = 0;

	IF (@Begin_Date is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate';

	IF (@End_Date is NOT NULL)
	BEGIN
		SET @End_Date = DateAdd(dd,1,@End_Date);
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate';
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @Begin_Date, 'ENDDate' = @End_Date, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @Begin_Date
		, @EndDate = @End_Date;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicatePeople]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate people
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicatePeople]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT P1PersonID = P1.PersonID
				, P2PersonID = P2.PersonID	
				, P1LastName = P1.LastName
				, P2LastName = P2.LastName 
				, P1FirstName = P1.FirstName
				, P2FirstName = P2.FirstName 
				, P1BirthDate = P1.BirthDate
				, P2BirthDate = P2.BirthDate
				, P1Gender = P1.Gender
				, P2Gender = P2.Gender
				, P1CreatedDate = P1.CreatedDate
				, P2CreatedDate = P2.CreatedDate
				, P1ModifiedDate = P1.ModifiedDate
				, P2ModifiedDate = P2.ModifiedDate
			from person AS P1
			JOIN person AS P2 on 
				P1.LastName = P2.LastName
				AND P1.FirstName = P2.FirstName
				AND P1.Age = P2.Age
				AND P1.PersonID != P2.PersonID 
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicateProperties]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicateProperties]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P1PropertyID] = [P1].[PropertyID]
				, [P2PropertyID] = [P2].[PropertyID]
				, [P1StreetNumber] = [P1].[StreetNumber]
				, [P2StreetNumber] = [P2].[StreetNumber]
				, [P1Street] = [P1].[Street]
				, [P2Street] = [P2].[Street]
				, [P1StreetSuffix] = [P1].[StreetSuffix]
				, [P2StreetSuffix] = [P2].[StreetSuffix]
				, [P1City] = [P1].[City]
				, [P2City] = [P2].[City]
				, [P1State] = [P1].[State]
				, [P2State] = [P2].[State]
				, [P1ZipCode] = [P1].[Zipcode]
				, [P2ZipCode] = [P2].[Zipcode]
				, [P1County] = [P1].[County]
				, [P2County] = [P2].[County]
				, [P1CreatedDate] = [P1].[CreatedDate]
				, [P2CreatedDate] = [P2].[CreatedDate]
				, [P1ModifiedDate] = [P1].[ModifiedDate]
				, [P2ModifiedDate] = [P2].[ModifiedDate]
			from [Property] AS [P1]
			JOIN [Property] AS [P2] on 
				[P1].[Street] = [P2].[Street]
				AND [P1].[StreetNumber] = [P2].[StreetNumber]
				AND [P1].[City] = [P2].[City]
				AND [P1].[County] = [P2].[County]
				AND [P1].[Zipcode] = [P2].[Zipcode]
				AND [P1].[State] = [P2].[State]
				AND [P1].[PropertyID] != [P2].[PropertyID]
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListPregnantWomenbyCreateDateRange]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select PregnantWomen by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListPregnantWomenbyCreateDateRange]
	-- Add the parameters for the stored procedure here
	@Begin_Date date = NULL,
	@End_Date date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[CreatedDate]
								from [Person] AS [P]
								where Pregnant = 1'
	
	-- Return all PregnantWomen if nothing was passed in
	IF ((@Begin_Date is NULL) AND (@End_Date is NULL))
		SET @Recompile = 0

	IF (@Begin_Date is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate'

	IF (@End_Date is NOT NULL)
	BEGIN
		SET @End_Date = DateAdd(dd,1,@End_Date)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate'
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @Begin_Date, 'ENDDate' = @End_Date, 'DEBUG' = @Debug

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @Begin_Date
		, @EndDate = @End_Date;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

	--	DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SLMostRecentBloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select most recent blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLMostRecentBloodTestResults] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(4,1) = NULL,
	@Max_Lead_Value numeric(4,1) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 

    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'Select [P].[LastName],[P].[FirstName],[P].[PersonID],[BTR].[LeadValue], [BTR].[SampleDate],[BTR].[HemoglobinValue]
								,[BTR].[CreatedDate],[BTR].[ModifiedDate],[BTR].[BloodTestResultsID] from [Person] AS [P]
								JOIN [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
									select top 1 [BloodTestResultsID] from [BloodTestResults] 
									where [BloodTestResults].[PersonID] = [P].[PersonID]
									-- AND [LeadValue] > @MinLeadValue uncomment to list most recent tests with BLL above minimum
									) 
								WHERE 1=1';

	IF @Min_Lead_Value IS NULL
		SET @Min_Lead_Value = 0.0;

	IF @Person_ID IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID';

	IF (@Min_Lead_Value > 0)
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND  [BTR].[LeadValue] >= @MinLeadValue';

	IF (@Max_Lead_Value > 0)
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND  [BTR].[LeadValue] < @MaxLeadValue';

	IF @Person_ID is NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	
	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value = 0) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PID' = @Person_ID, 'MLV' = @Min_Lead_Value, 'MaxLV' = @Max_Lead_Value, 'R' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(4,1), @MaxLeadvalue numeric(4,1)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value, @MaxleadValue = @Max_Lead_Value;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlPersonNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their ethnicities
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersonNotes]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select P.PersonID,LastName,FirstName, PN.Notes,P.ModifiedDate from Person AS P
			LEFT OUTER JOIN PersonNotes AS PN on P.PersonID = PN.PErsonID
			where Notes is not null';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlPersontoEthnicity]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their ethnicities
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersontoEthnicity]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select P.PersonID,LastName,FirstName,E.Ethnicity from Person AS P
			LEFT OUTER JOIN PersontoEthnicity AS P2E on P.PersonID = P2E.PErsonID
			LEFT OUTER JOIN Ethnicity AS E on P2E.EthnicityID = E.EthnicityID 
			WHERE 1 = 1';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlPersontoLanguage]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their languages
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersontoLanguage]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select [P].PersonID,LastName,FirstName, L.LanguageName from Person AS P
			LEFT OUTER JOIN PersontoLanguage AS P2L on P.PersonID = P2L.PErsonID
			LEFT OUTER JOIN Language AS L on P2L.LanguageID = L.LanguageID 
			WHERE 1 = 1';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlRelationShipTypes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150110
-- Description:	User defined stored procedure to
--              select all relationship types and IDs
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlRelationShipTypes]
	-- Add the parameters for the stored procedure her
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT [RT].[RelationshipTypeID], [RT].[RelationshipTypeName]
	from [RelationshipType] AS [RT]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [RT].[RelationshipTypeName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlStatus] 
	-- Add the parameters for the stored procedure here
	@TargetType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- IF (@StatusType = 'Child')
		select statusName from TargetStatus where TargetType = @TargetType

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlSummaryReport]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlSummaryReport] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@MinAge int = 18,
	@DEBUG bit = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @ParmDefinition nvarchar(500)
	, @ClientCount int, @NewClientCount int, @BLLCount int, @EBLLCount int, @PregnantWomenCount int
	, @NursingMotherCount int, @NursingInfantCount int, @AdultCount int, @BloodTestCount int, @HomeSoilCount int
	, @BllMinLeadValue decimal(4,1), @BllMaxLeadValue decimal(4,1)
	, @EBLLMinLeadValue decimal(4,1), @EBLLMaxLeadValue decimal(4,1);
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);
		
		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar);
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		-- clients
		SELECT @spexecutesqlStr = 'Select  @Clients = count(PersonID) from (
			SELECT  PersonID from bloodTestResults WHERE 1=1 AND SampleDate >= @StartDate AND SampleDate < @EndDate
			UNION
			SELECT  PersonID from Questionnaire WHERE 1=1 AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
			) total'
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @Clients int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @Clients = @ClientCount OUTPUT;

		-- NewClients
		SELECT @spexecutesqlStr = 'Select  @NewClients = count(PersonID) from Person WHERE isClient = 1';
		
		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate >= @StartDate';
	
		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND CreatedDate < @EndDate';

		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NewClients int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NewClients = @NewClientCount OUTPUT;

		-- Total BloodLead Tests
		SELECT @spexecutesqlStr = 'SELECT @BloodTestCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate';

		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate';
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @BloodTestCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @BloodTestCount = @BloodTestCount OUTPUT;

		-- BLL 5 ug/dl - 9.9 ug/dl
		SET @BLLMinLeadValue = 5.0;
		SET @BLLMaxLeadValue = 10.0;

		SELECT @spexecutesqlStr = 'SELECT @BLLCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1';

		IF (@MinLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND Leadvalue >= @MinLeadValue';
		
		IF (@MaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue < @MaxLeadValue';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate';

		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate';
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1), @BLLCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @MinLeadValue
		, @MaxLeadValue = @MaxLeadValue
		, @BLLCount = @BLLCount OUTPUT;

		-- EBLL 10 ug/dl and above
		SET @EBLLMinLeadValue = 10;
		SET @EBLLMaxLeadValue = NULL;

		SELECT @spexecutesqlStr = 'SELECT @EBLLCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1';

		IF (@MinLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND Leadvalue >= @MinLeadValue';
		
		IF (@MaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue < @MaxLeadValue';

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate';

		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate'
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1), @EBLLCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @MinLeadValue
		, @MaxLeadValue = @MaxLeadValue
		, @EBLLCount = @EBLLCount OUTPUT;

		-- Pregnant women
		select @spexecutesqlStr ='Select @PregnantWomen = COUNT(PersonID) from (
								Select BTR.PersonID,Q.Pregnant from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by Pregnant desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.Pregnant = 1

								UNION 
								SELECT PersonID,Pregnant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND Pregnant = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.Pregnant = 1';
	
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime, @PregnantWomen int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @PregnantWomen = @PregnantWomenCount OUTPUT;

		-- Nursing Mothers
		SELECT @spexecutesqlStr = 'Select @NursingMothers = COUNT(PersonID) from (
								Select BTR.PersonID,Q.NursingMother from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by NursingMother desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingMother = 1

								UNION 
								SELECT PersonID,NursingMother from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND NursingMother = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.NursingMother = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NursingMothers int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NursingMothers = @NursingMotherCount OUTPUT;

		-- Nursing Infants
		SELECT @spexecutesqlStr = 'Select @NursingInfants = COUNT(PersonID) from (
									Select BTR.PersonID,Q.NursingInfant from BloodTestResults AS BTR
									LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																	select TOP 1 [QuestionnaireID] from [Questionnaire] 
																	where [Questionnaire].[PersonID] = [BTR].[PersonID]
																	AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																	order by NursingInfant desc
																	)
									where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingInfant = 1

									UNION 
									SELECT PersonID,NursingInfant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
									AND NursingInfant = 1
								) ClientsinReportingPeriod
								where ClientsinReportingPeriod.NursingInfant = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NursingInfants int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NursingInfants = @NursingInfantCount OUTPUT;

		-- Adults
		IF (@StartDate IS NULL)
			SET @StartDate = '18000101';

		IF (@ENDDate IS NULL)
			SET @EndDate = GetDate();

		-- Create temporary table
		CREATE Table #TempPotentialAdults
		( PersonID int 
			, TestID int
			, AgeAtVisit tinyint
			, MostRecentVisit date
			, Birthdate date
			, Visits tinyint
		)

		-- insert values from bloodtest results
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				select PersonID,MostRecentVisit = SampleDate, TestID = BloodTestResultsID 
				from BloodtestResults 
					where SampleDate >= @StartDate AND SampleDate < @EndDate ;

		-- insert values from questionnaire	
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				Select PersonID,MostRecentVisit = QuestionnaireDate, TestID = QuestionnaireID 
				from Questionnaire 
					where QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
					and (ISNULL(Questionnaire.NursingMother,0) = 0 OR  ISNULL(Questionnaire.Pregnant,0) = 0 );

		-- populate birthdate only if the difference from most recent visit to birthdate is at least minAge
			update #TempPotentialAdults set BirthDate = Person.Birthdate,
				 AgeAtVisit = [dbo].[udf_CalculateAge]([Person].[BirthDate],MostRecentVisit)
			FROM #TempPotentialAdults
			JOIN Person on Person.PersonID = #TempPotentialAdults.PersonID
			where Datediff(yy,Person.BirthDate,MostRecentVisit) >= @MinAge;

		Select @AdultCount = count(distinct PersonID) from #TempPotentialAdults
		where AgeAtVisit >= @MinAge;

		drop table #TempPotentialAdults;

		-- Home visits and soil testing
		select @spexecutesqlStr ='select @HomeSoilCount = count(PersonID) from (
						SELECT PersonID
						from BloodTestResults where SampleDate >= @StartDate and SampleDate < @EndDate
								AND ClientStatusID in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
														where TargetType = ''Person''
														AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')
													  )
						UNION
						-- people with questionnaire but no blood test during reporting period
						Select Q.PersonID
						from Questionnaire AS Q
								LEFT OUTER JOIN  [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
																select top 1 [BloodTestResultsID] from [BloodTestResults] 
																where [BloodTestResults].[PersonID] = [Q].[PersonID]
																-- AND SampleDate >= @StartDate AND SampleDate < @EndDate
																AND BTR.ClientStatusID
																	in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
																			where TargetType = ''Person''
																			AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
																		)
																order by SampleDate desc
																)
								where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate 
								AND BTR.ClientStatusID
									in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
											where TargetType = ''Person''
											AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
										)
						) HomeVisitSoilSamples';
	
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime, @HomeSoilCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @HomeSoilCount = @HomeSoilCount OUTPUT;
		-- total tests

		select 'ClientCount' = @ClientCount, 'NewClientCount' = @NewClientCount, 'BloodTestCount' = @BloodTestCount
				, 'BLL5to10ugPerdl' = @BLLCount, 'EBLLCount' = @EBLLCount, 'PregnantWomen' = @PregnantWomenCount
				, 'NursingMotherCount' = @NursingMotherCount, 'NursingInfantCount' = @NursingInfantCount
				, 'AdultCount' = @AdultCount, 'HomeSoilCount' = @HomeSoilCount;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlSummaryReport_MetaData]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlSummaryReport_MetaData] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@MinAge int = 18,
	@DEBUG bit = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @ParmDefinition nvarchar(500)
	, @ClientCount int, @NewClientCount int, @BLLCount int, @EBLLCount int, @PregnantWomenCount int
	, @NursingMotherCount int, @NursingInfantCount int, @AdultCount int, @BloodTestCount int, @HomeSoilCount int;
	
	BEGIN TRY

	

		select 'ClientCount' = @ClientCount, 'NewClientCount' = @NewClientCount, 'BloodTestCount' = @BloodTestCount
				, 'BLL5to10ugPerdl' = @BLLCount, 'EBLLCount' = @EBLLCount, 'PregnantWomen' = @PregnantWomenCount
				, 'NursingMotherCount' = @NursingMotherCount, 'NursingInfantCount' = @NursingInfantCount
				, 'AdultCount' = @AdultCount, 'HomeSoilCount' = @HomeSoilCount
				where 1 = 0;

	--	SELECT @sSQL = N'SELECT @retvalOUT = MAX(PersonID) FROM ' + @tablename;  
--SET @ParmDefinition = N'@retvalOUT int OUTPUT';

--EXEC sp_executesql @sSQL, @ParmDefinition, @retvalOUT=@retval OUTPUT;

--SELECT @retval;
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlTargetSampleType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150102
-- Description:	retrieve sample types for people (lead levels)
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlTargetSampleType] 
	-- Add the parameters for the stored procedure here
	@Sample_Target varchar(50) = NULL, 
	@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr nvarchar(4000), @RECOMPILE bit =1;
    -- Insert statements for procedure here

	SELECT @spexecutesqlStr = 'SELECT [SampleTypeID],[SampleTypeName] from [SampleType] where 1=1'
	
	if (@Sample_Target IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [SampleType].[SampleTarget] = @SampleTarget'

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' OPTION(RECOMPILE)';

	EXEC [sp_executesql] @spexecutesqlStr
		, N'@SampleTarget varchar(50)', @SampleTarget = @Sample_Target
END
GO
/****** Object:  StoredProcedure [dbo].[usp_upBloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130618
-- Description:	Stored Procedure to update 
--              blood test results records
-- =============================================
-- DROP PROCEDURE usp_upBloodTestResults
CREATE PROCEDURE [dbo].[usp_upBloodTestResults]  
	-- Add the parameters for the stored procedure here
	@BloodTestResultsID int = NULL,
	@New_Sample_Date date = NULL,
	@New_Lab_Date date = NULL,
	@New_Blood_Lead_Result numeric(4,1) = NULL,
	-- @New_Flag smallint = NULL,
	@New_Hemoglobin_Value numeric(4,1) = NULL,
	@New_Lab_ID int = NULL,
	@New_Blood_Test_Costs money = NULL,
	@New_Sample_Type_ID tinyint = NULL,
	@New_Taken_After_Property_Remediation_Completed bit = NULL,
	@New_Exclude_Result bit = NULL,
	@New_Client_Status_ID smallint = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdateBloodTestResultssqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if BloodTestResultsID is valid, if not return
		IF NOT EXISTS (SELECT BloodTestResultsID from BloodTestResults where BloodTestResultsID = @BloodTestResultsID)
		BEGIN
			RAISERROR(15000, -1,-1,'usp_upBloodTestResults');
		END
		
		-- BUILD update statement
		if (@New_Blood_Lead_Result is null)
			select @New_Blood_Lead_Result = LeadValue from BloodTestResults where BloodTestResultsID = @BloodTestResultsID
		
		SELECT @spupdateBloodTestResultssqlStr = N'update BloodTestResults set LeadValue = @Blood_Lead_Result'

		IF (@New_Sample_Date IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', SampleDate = @Sample_Date'

		IF (@New_Lab_Date IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', LabSubmissionDate = @Lab_Date'

		IF (@New_Hemoglobin_Value IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', HemoglobinValue = @Hemoglobin_Value'

		IF (@New_Lab_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', LabID = @Lab_ID'

		IF (@New_Blood_Test_Costs IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', BloodTestCosts = @Blood_Test_Costs'

		IF (@New_Sample_Type_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', SampleTypeID = @Sample_Type_ID'

		IF (@New_Taken_After_Property_Remediation_Completed IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', TakenAfterPropertyRemediationCompleted = @Taken_After_Property_Remediation_Completed'

		IF (@New_Exclude_Result IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', ExcludeResult = @Exclude_Result'

		IF (@New_Client_Status_ID IS NOT NULL)
			SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N', ClientStatusID = @Client_Status_ID'

		-- make sure to only update record for specified BloodTestResults
		SELECT @spupdateBloodTestResultssqlStr = @spupdateBloodTestResultssqlStr + N' WHERE BloodTestResultsID = @BloodTestResultsID'

		IF (@DEBUG = 1)
			SELECT @spupdateBloodTestResultssqlStr, LeadValue = @New_Blood_Lead_Result, SampleDate = @New_Sample_Date, LabSubmissionDate = @New_Lab_Date
					, HemoglobinVlaue = @New_Hemoglobin_Value, LabID = @New_Lab_ID, BloodTestCosts = @New_Blood_Test_Costs, SampleTypeID = @New_Sample_Type_ID
					, TakenAfterPropertyRemediationCompleted = @New_Taken_After_Property_Remediation_Completed, ExcludeResult = @New_Exclude_Result
					, ClientStatusID = @New_Client_Status_ID, BloodTestResultsID = @BloodTestResultsID

		EXEC [sp_executesql] @spupdateBloodTestResultssqlStr
				, N'@Blood_Lead_Result numeric(4,1), @Sample_Date date, @Lab_Date date, @Hemoglobin_Value numeric(4,1), @Lab_ID int, @Blood_Test_Costs money
				, @Sample_Type_ID tinyint, @Taken_After_Property_Remediation_Completed bit, @Exclude_Result bit
				, @Client_Status_ID smallint, @BloodTestResultsID int'
				, @Blood_Lead_Result = @New_Blood_Lead_Result
				, @Sample_Date = @New_Sample_Date
				, @Lab_Date = @New_Lab_Date
				, @Hemoglobin_Value = @New_Hemoglobin_Value
				, @Lab_ID = @New_Lab_ID
				, @Blood_Test_Costs = @New_Blood_Test_Costs
				, @Sample_Type_ID = @New_Sample_Type_ID
				, @Taken_After_Property_Remediation_Completed = @New_Taken_After_Property_Remediation_Completed
				, @Exclude_Result = @New_Exclude_Result
				, @Client_Status_ID = @New_Client_Status_ID
				, @BloodTestResultsID = @BloodTestResultsID

			IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertBloodTestResultsNotes]
								@BloodTestResults_ID = @BloodTestResultsID,
								@Notes = @New_Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upBloodTestResultsWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to update blood test results
--              data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_upBloodTestResultsWebScreen]
	-- Add the parameters for the stored procedure here
	@BloodTestResultsID int = NULL,
	@New_Sample_Date date = NULL,
	@New_Lab_Date date = NULL,
	@New_Blood_Lead_Result numeric(4,1) = NULL,
	@New_Sample_Type_ID tinyint = NULL,
	@New_Lab_ID int = NULL,
	@New_Flag smallint = NULL,
	@New_Client_Status_ID smallint = NULL,
	@New_Hemoglobin_Value numeric(4,1) = NULL,
	@New_Blood_Test_Costs money = NULL,
	@New_Taken_After_Property_Remediation_Completed bit = NULL,
	@New_Exclude_Result bit = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int, @RetestDate_return_value int,
				@updateBloodTestResultsReturnValue int;
	
		-- If no family ID was passed in exit
		IF (@BloodTestResultsID IS NULL)
		BEGIN
			RAISERROR ('Blood test results ID must be supplied', 11, -1);
			RETURN;
		END;

		BEGIN TRY  
			-- update person flag/retest date
			IF (@New_Flag IS NOT NULL)
			BEGIN
				declare @Retest_Date date, @Sample_Date date, @Person_ID int;

				-- determine personID
				select @Person_ID = PersonID, @Sample_Date = SampleDate from BloodTestResults where BloodTestResultsID = @BloodTestResultsID
				
				-- set the retest date based on integer value passed in as Flag
				SET @Retest_Date = DATEADD(dd,@New_Flag,@Sample_Date);

				-- update Person table with the new retest date
				-- anyone with a blood test is a client
				EXEC	@RetestDate_return_value = [dbo].[usp_upPerson]
						@Person_ID = @Person_ID
						, @New_RetestDate = @Retest_Date
						, @New_ClientStatusID = @New_Client_Status_ID;
			END

			-- update bloodtestResults
			EXEC	@updateBloodTestResultsReturnValue = [dbo].[usp_upBloodTestResults]
														@BloodTestResultsID = @BloodTestResultsID,
														@New_Sample_Date = @New_Sample_Date,
														@New_Lab_Date = @New_Lab_Date,
														@New_Blood_Lead_Result = @New_Blood_Lead_Result,
														@New_Hemoglobin_Value = @New_Hemoglobin_Value,
														@New_Lab_ID = @New_Lab_ID,
														@New_Blood_Test_Costs = @New_Blood_Test_Costs,
														@New_Sample_Type_ID = @New_Sample_Type_ID,
														@New_Taken_After_Property_Remediation_Completed = @New_Taken_After_Property_Remediation_Completed,
														@New_Exclude_Result = @New_Exclude_Result,
														@New_Client_Status_ID = @New_Client_Status_ID,
														@New_Notes = @New_Notes,
														@DEBUG = @DEBUG

		END TRY
		BEGIN CATCH -- insert person
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; -- insert new person
	END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upClientFlag]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure to update the isClient
--              flag to 1 if the person has completed
--              a bloodtest or a questionnaire.
-- =============================================
CREATE PROCEDURE [dbo].[usp_upClientFlag] 
	-- Add the parameters for the stored procedure here
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		-- Set isClient true if person has a bloodtest or questionnaire
		update Person Set isClient = 1 where isClient = 0 AND PersonID IN
		( Select PersonID from BloodTestResults
			UNION
		  Select PersonID from Questionnaire
		)

		-- Set isClient false if person does not have a bloodtest or a questionnaire
		update Person Set isClient = 0 where isClient = 1 AND PersonID NOT IN
		( Select PersonID from BloodTestResults
			UNION
		  Select PersonID from Questionnaire
		) 
		
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upClientWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150325
-- Description:	stored procedure to update data 
--              from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_upClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@Person_ID int = NULL,
	@New_FirstName varchar(50) = NULL,
	@New_MiddleName varchar(50) = NULL,
	@New_LastName varchar(50) = NULL, 
	@New_BirthDate date = NULL,
	@New_Gender char(1) = NULL,
	@New_StatusID smallint = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OutofSite bit = NULL,
	@New_EatsForeignFood bit = NULL,
	@New_EmailAddress varchar(320) = NULL,
	@New_RetestDate date = NULL,
	@New_Moved bit = NULL,
	@New_MovedDate date = NULL,
	@New_isClosed bit = 0,
	@New_isResolved bit = 0,
	@New_ClientNotes varchar(3000) = NULL,
	@New_TravelNotes varchar(3000) = NULL,
	@New_HobbyNotes varchar(3000) = NULL,
	@New_ReleaseNotes varchar(3000) = NULL,
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	--@New_isNursing bit = NULL,
	--@New_isPregnant bit = NULL,
	@New_EthnicityID tinyint = NULL,
	@New_LanguageID tinyint = NULL,
	@New_PrimaryLanguage bit = 1,
	@New_HobbyID int = NULL,
	@New_OccupationID int = NULL,
	@New_Occupation_StartDate date = NULL,
	@New_Occupation_EndDate date = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@updatePerson_return_value int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL OR @Person_ID IS NULL)
		BEGIN
			RAISERROR ('Family and Person must be supplied', 11, -1);
			RETURN;
		END;

		if (@New_LastName is null)
		BEGIN
			select @New_LastName = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- update person
			EXEC	@updatePerson_return_value = [dbo].[usp_upPerson]
						@Person_ID = @Person_ID,
						@New_FirstName = @New_FirstName,
						@New_MiddleName = @New_MiddleName,
						@New_LastName = @New_LastName,
						@New_BirthDate = @New_BirthDate,
						@New_Gender = @New_Gender,
						@New_StatusID = @New_StatusID,
						@New_ForeignTravel = @New_ForeignTravel,
						@New_OutofSite = @New_OutofSite,
						@New_EatsForeignFood = @New_EatsForeignFood,
						@New_EmailAddress = @New_EmailAddress,
						@New_RetestDate = @New_RetestDate,
						@New_Moved = @New_Moved,
						@New_MovedDate = @New_MovedDate,
						@New_isClosed = @New_isClosed,
						@New_isResolved = @New_isResolved,
						@New_PersonNotes = @New_ClientNotes,
						@New_HobbyNotes = @New_HobbyNotes,
						@New_TravelNotes = @New_TravelNotes,
						@New_ReleaseNotes = @New_ReleaseNotes,
						@New_GuardianID = @New_GuardianID,
						@New_PersonCode = @New_PersonCode,
						@New_isSmoker = @New_isSmoker,
						@New_isClient = @New_isClient,
						@New_NursingMother = @New_NursingMother,
						@New_NursingInfant = @New_NursingInfant,
						@New_Pregnant = @New_Pregnant,
						@DEBUG = @DEBUG

			-- Associate person to Ethnicity
			IF ((@New_EthnicityID IS NOT NULL) AND
					(NOT EXISTS (SELECT PersonID from PersontoEthnicity where EthnicityID = @New_EthnicityID and PersonID = @Person_ID)))
				EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
						@PersonID = @Person_ID,
						@EthnicityID = @New_EthnicityID
			-- CODE FOR FUTURE EXTENSIBILITY OF UPDATING ETHNICITY
			--IF (@New_Ethnicity IS NOT NULL)
			--EXEC	@Ethnicity_return_value = [dbo].[usp_upEthnicity]
			--		@PersonID = @Person_ID,
			--		@New_EthnicityID = @New_EthnicityID,
			--		@DEBUG = @DEBUG,
			--		@PersontoEthnicityID = @New_PersontoEthnicityID OUTPUT

			-- Associate person to family
			-- If the person isn't already associated with that family
			if NOT EXISTS(SELECT PersonID from PersontoFamily where FamilyID = @Family_ID and PersonID = @Person_ID)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @Person_ID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			IF (@New_LanguageID is not NULL)
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @New_LanguageID, @PersonID = @Person_ID, @isPrimaryLanguage = @New_PrimaryLanguage;

			-- associate person to Hobby
			IF ((@New_HobbyID is not NULL) AND 
				(NOT EXISTS (SELECT PersonID from PersontoHobby where HobbyID = @New_HobbyID and PersonID = @Person_ID)) )
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @New_HobbyID, @PersonID = @Person_ID;

			-- associate person to occupation
			if ((@New_OccupationID is not NULL))
				IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where OccupationID = @New_OccupationID and PersonID = @Person_ID))
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@StartDate = @New_Occupation_StartDate,
						@EndDate = @New_Occupation_EndDate
			ELSE
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_upOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@Occupation_StartDate = @New_Occupation_StartDate,
						@Occupation_EndDate = @New_Occupation_EndDate,
						@DEBUG = @DEBUG;
		END TRY
		BEGIN CATCH -- insert person
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; -- insert new person
	END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upFamily]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150214
-- Description:	Stored Procedure to update Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamily]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@New_Last_Name varchar(50) = NULL,
	@New_Number_of_Smokers tinyint = 0,
	@New_Primary_Language_ID tinyint = 1,
	@New_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	@New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @spupdateFamilysqlStr nvarchar(4000)
			, @NotesID INT, @Recompile BIT = 1;
	
	BEGIN TRY -- update Family information
		-- BUILD update statement
		IF (@New_Last_Name IS NULL)
			SELECT @New_Last_Name = LastName from family where FamilyID = @Family_ID;
	
		SELECT @spupdateFamilysqlStr = N'update Family set Lastname = @LastName'

		IF (@New_Number_of_Smokers IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', NumberofSmokers = @NumberofSmokers'

		IF (@New_Primary_Language_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryLanguageID = @PrimaryLanguageID'

		IF (@New_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Pets = @Pets'

		IF (@New_Frequently_Wash_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', FrequentlyWashPets = @FrequentlyWashPets'	
			
		IF (@New_Pets_in_and_out IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Petsinandout = @Petsinandout'

		IF (@New_Primary_Property_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryPropertyID = @PrimaryPropertyID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', ForeignTravel = @ForeignTravel'


		SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N' WHERE FamilyID = @FamilyID'

		IF @DEBUG = 1
			SELECT @spupdateFamilysqlStr, 'Lastname' = @New_Last_Name, 'NumberofSmokers' = @New_Number_of_Smokers
				, 'PrimaryLanguageID' = @New_Primary_Language_ID, 'Pets' = @New_Pets, 'Petsinandout' = @New_Pets_in_and_out
				, 'PrimaryPropertyID' = @New_Primary_Property_ID, 'FrequentlyWashPets' = @New_Frequently_Wash_Pets
				, 'ForeignTravel' = @New_ForeignTravel
			
			IF (@New_Notes IS NOT NULL)
			BEGIN
				IF @DEBUG = 1
					SELECT 'EXEC [dbo].[usp_InsertFamilyNotes] @Family_ID = @Family_ID, @Notes = @New_Notes, @InsertedNotesID = @NotesID OUTPUT ' 
						, @Family_ID, @New_Notes 

				EXEC	[dbo].[usp_InsertFamilyNotes]
							@Family_ID = @Family_ID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT
			END
	
			-- update Family table
			EXEC [sp_executesql] @spupdateFamilysqlStr
				, N'@LastName VARCHAR(50), @NumberofSmokers tinyint, @PrimaryLanguageID tinyint
				, @Pets tinyint, @Petsinandout BIT, @PrimaryPropertyID int, @FrequentlyWashPets bit, @ForeignTravel bit, @FamilyID int'
				, @LastName = @New_Last_Name
				, @NumberofSmokers = @New_Number_of_Smokers
				, @PrimaryLanguageID = @New_Primary_Language_ID
				, @Pets = @New_Pets
				, @Petsinandout = @New_Pets_in_and_out
				, @PrimaryPropertyID = @New_Primary_Property_ID
				, @FrequentlyWashPets = @New_Frequently_Wash_Pets
				, @ForeignTravel = @New_ForeignTravel
				, @FamilyID = @Family_ID
	END TRY -- update Family
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_upFamilytoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20150417
-- Description:	Stored Procedure to update new FamilytoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamilytoProperty]   
	-- Add the parameters for the stored procedure here
	@FamilytoPropertyID int = NULL,
	@PropertyLinkTypeID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @ErrorLogID int, @spexecuteSQLStr nvarchar(4000);
    -- Insert statements for procedure here
	BEGIN TRY
		SELECT @spexecuteSQLStr = N'update FamilytoProperty set EndDate = @End_Date';
		
		IF @PropertyLinkTypeID IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', PropertyLinkTypeID = @Property_Link_Type_ID'

		IF @StartDate IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', StartDate = @Start_Date'

		IF @isPrimaryResidence IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', isPrimaryResidence = @is_Primary_Residence'

		-- Add filters to update the correct record
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' Where FamilytoPropertyID = @Family_to_Property_ID'

		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilytoPropertyID' = @FamilytoPropertyID, 'PropertyLinkTypeID' = @PropertyLinkTypeID
				, 'StartDate' = @StartDate, 'EndDate' = @EndDate, 'isPrimaryResidence' = @isPrimaryResidence;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_to_Property_ID int, @Property_Link_Type_ID int, @Start_Date date, @End_Date date, @is_Primary_Residence bit'
			, @Family_to_Property_ID = @FamilytoPropertyID
			, @Property_Link_Type_ID = @PropertyLinkTypeID
			, @Start_Date = @StartDate
			, @End_Date = @EndDate
			, @is_Primary_Residence = @isPrimaryResidence;

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END


GO
/****** Object:  StoredProcedure [dbo].[usp_upFamilyWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150329
-- Description:	Stored Procedure to update Family 
--              web screen information
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamilyWebScreen]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@isNewAddress bit = 0,
	@New_Last_Name varchar(50) = NULL,
	@PropertyID int = NULL,
	@New_ConstructionType int = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL,
	@New_isRemodeled bit = NULL, 
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	@New_Address_Line1 varchar(100) = NULL,
	@New_Address_Line2 varchar(100) = NULL,
	@New_CityName varchar(50) = NULL,
	@New_County varchar(50) = NULL,
	@New_StateAbbr char(2) = NULL,
	@New_ZipCode varchar(10) = NULL,
	@New_Year_Built date = NULL,
	@New_PropertyLinkTypeID tinyint = NULL,
	@New_Movein_Date date = NULL,
	@New_MoveOut_Date date = NULL,
	@New_isPrimaryResidence bit = NULL,
	@New_Owner_id int = NULL,
	@New_is_Owner_Occupied bit = NULL,
	@New_ReplacedPipesFaucets bit = NULL,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_is_Residential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_has_Peeling_Chipping_Patin bit = NULL,
	@New_is_Rental bit = NULL,
	@New_PrimaryPhone bigint = NULL,
	@PrimaryPhonePriority tinyint = 1,
	@New_SecondaryPhone bigint = NULL,
	@SecondaryPhonePriority tinyint = 2,
	@New_Number_of_Smokers tinyint = NULL,
	@New_Primary_Language_ID tinyint = 1,
	@New_Family_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	-- @New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OwnerContactInformation varchar(1000) = NULL,
	@DEBUG BIT = 1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int
			, @Update_Family_return_value int
			, @Update_Property_return_value int
			, @NotesID INT, @Recompile BIT = 1
			, @New_Primary_Property_ID int
			, @Primaryphone_return_value int
			, @Secondaryphone_return_value int
			, @FamilytoProperty_return_value int
			, @InsertedFamilytoPropertyID int
			, @DebugLogID int
	
	BEGIN TRY -- update Family information
		-- Exit if family isn't specified
		IF (@Family_ID IS NULL or @Family_ID = '')
		BEGIN
			RAISERROR ('Family must be specified', 11, 1);
			RETURN;
		END;

		-- Existing property need the primary property id
		IF (@isNewAddress = 0)
		BEGIN
			-- Select the primary property id
			Select @PropertyID = PrimaryPropertyID from Family where FamilyID = @Family_ID;

			EXEC @Update_Property_return_value = [dbo].[usp_upProperty]
				@PropertyID = @PropertyID,
				@New_ConstructionTypeID = @New_ConstructionType,
				@New_AreaID = @New_AreaID,
				@New_isinHistoricDistrict = @New_isinHistoricDistrict,
				@New_isRemodeled = @New_isRemodeled,
				@New_RemodelDate = @New_RemodelDate,
				@New_isinCityLimits = @New_isinCityLimits,
				@New_AddressLine1 = @New_Address_Line1,
				@New_AddressLine2 = @New_Address_Line2,
				@New_City = @New_CityName,
				@New_State = @New_StateAbbr,
				@New_Zipcode = @New_ZipCode,
				@New_YearBuilt = @New_Year_Built,
				@New_Ownerid = @New_Owner_id,
				@New_isOwnerOccuppied = @New_is_Owner_Occupied,
				@New_ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@New_TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				@New_isResidential = @New_is_Residential,
				@New_isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@New_hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@New_County = @New_County,
				@New_isRental = @New_is_Rental,
				@New_OwnerContactInformation = @New_OwnerContactInformation,
				@DEBUG = @DEBUG

			-- SET the new primary property ID
			SET @New_Primary_Property_ID = @PropertyID;
		END

		IF (@isNewAddress = 1)
		BEGIN
			EXEC [dbo].[usp_InsertProperty]
				@ConstructionTypeID = @New_ConstructionType,
				@AreaID = @New_AreaID,
				@isinHistoricDistrict = @New_isinHistoricDistrict, 
				@isRemodeled = @New_isRemodeled,
				@RemodelDate = @New_RemodelDate,
				@isinCityLimits = @New_isinCityLimits,
				@AddressLine1 = @New_Address_Line1,
				@AddressLine2 = @New_Address_Line2,
				@City = @New_CityName,
				@State = @New_StateAbbr,
				@Zipcode = @New_ZipCode,
				@YearBuilt = @New_Year_Built,
				@Ownerid = @New_Owner_id,
				@isOwnerOccuppied = @New_is_Owner_Occupied,
				@ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				-- @isResidential = @New_isResidential,
				@isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@County = @New_County,
				-- @isRental = @New_isRental,
				--@OverRideDuplicate = @New_OverRideDuplicate,
				@OwnerContactInformation = @New_OwnerContactInformation,
				@PropertyID = @New_Primary_Property_ID OUTPUT
		END

		EXEC	@Update_Family_return_value = [dbo].[usp_upFamily]
				@Family_ID = @Family_ID,
				@New_Last_Name = @New_Last_Name,
				@New_Number_of_Smokers = @New_Number_of_Smokers,
				@New_Primary_Language_ID = @New_Primary_Language_ID,
				@New_Notes = @New_Family_Notes,
				@New_Pets = @New_Pets,
				@New_Frequently_Wash_Pets = @New_Frequently_Wash_Pets,
				@New_Pets_in_and_out = @New_Pets_in_and_out,
				@New_Primary_Property_ID = @New_Primary_Property_ID,
				@New_ForeignTravel = @New_ForeignTravel,
				@DEBUG = @DEBUG;

		EXEC @FamilytoProperty_return_value = [usp_InsertFamilytoProperty] 
				@FamilyID = @Family_ID,
				@PropertyID = @New_Primary_Property_ID,
				@PropertyLinkTypeID = @New_PropertyLinkTypeID,
				@StartDate = @New_Movein_Date,
				@EndDate = @New_MoveOut_Date,
				@isPrimaryResidence = @New_isPrimaryResidence,
				@NewFamilytoPropertyID = @InsertedFamilytoPropertyID OUTPUT


		if (@New_PrimaryPhone is not NULL) 
			BEGIN  -- insert Primary Phone
				DECLARE @PrimaryPhoneNumberID_OUTPUT bigint, @PhoneTypeID tinyint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Primary Phone';

				EXEC	@Primaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @New_PrimaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @PrimaryPhoneNumberID_OUTPUT OUTPUT
				
				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @Family_ID,
						@NumberPriority = @PrimaryPhonePriority,
						@PhoneNumberID = @PrimaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
			END  -- insert Primary Phone

			if (@New_SecondaryPhone is not NULL) 
			BEGIN  -- insert Secondary Phone
				DECLARE @SecondaryPhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Secondary Phone';

				EXEC	@Secondaryphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @New_SecondaryPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @SecondaryPhoneNumberID_OUTPUT OUTPUT

				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @Family_ID,
						@NumberPriority = @SecondaryPhonePriority,
						@PhoneNumberID = @SecondaryPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
						
			END  -- insert Secondary Phone

	END TRY -- update Family
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upOccupation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150327
-- Description:	Stored Procedure to update occupation records
-- =============================================
-- DROP PROCEDURE usp_upOccupation
CREATE PROCEDURE [dbo].[usp_upOccupation] 
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID tinyint = NULL,
	@Occupation_StartDate date = NULL,
	@Occupation_EndDate date = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ErrorMessage NVARCHAR(4000), @Update bit, @spupdateOccupationsqlStr NVARCHAR(4000);

	-- Assume there is nothing to update
	SET @Update = 0;

	-- insert statements for procedure here
	BEGIN TRY
		IF (@PersonID IS NULL OR @OccupationID IS NULL)
		BEGIN
			RAISERROR('Occupation and Person must be specified',11,50000);
			RETURN;
		END

		IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where PersonID = @PersonID AND OccupationID = @OccupationID))
		BEGIN
			SELECT @ErrorMessage = 'Secified person: ' + cast(@PersonID as varchar) + ' is not associated with occupation: ' 
				+ cast(@OccupationID as varchar) +'. Try creating the assocation with usp_InsertPersontoOccupation';
			RAISERROR(@ErrorMessage,8,50000);
			RETURN;
		END
		
		-- BUILD update statement
		SELECT @spupdateOccupationsqlStr = N'update PersontoOccupation Set PersonID = @PersonID'
		
		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', StartDate = @StartDate'
		END

		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', ENDDate = @ENDDate'
		END

		IF (@Update = 1)
		BEGIN
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ' WHERE PersonID = @PersonID and OccupationID = @OccupationID'

			IF (@DEBUG = 1)
				SELECT @spupdateOccupationsqlStr, 'StartDate' = @Occupation_StartDate, 'EndDate' = @Occupation_EndDate,
					'PersonID' = @PersonID, 'OccupationID' = @OccupationID

			EXEC [sp_executesql] @spupdateOccupationsqlStr
					, N'@OccupationID tinyint, @PersonID int, @StartDate date, @EndDate date'
					, @OccupationID = @OccupationID
					, @PersonID = @PersonID
					, @StartDate = @Occupation_StartDate
					, @EndDate = @Occupation_EndDate
		END
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END



GO
/****** Object:  StoredProcedure [dbo].[usp_upPerson]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to update new people records
-- =============================================
-- DROP PROCEDURE usp_upPerson
CREATE PROCEDURE [dbo].[usp_upPerson]  
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@New_FirstName varchar(50) = NULL,
	@New_MiddleName varchar(50) = NULL,
	@New_LastName varchar(50) = NULL, 
	@New_BirthDate date = NULL,
	@New_Gender char(1) = NULL,
	@New_StatusID smallint = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OutofSite bit = NULL,
	@New_EatsForeignFood bit = NULL,
	@New_EmailAddress varchar(320) = NULL,
	@New_RetestDate date = NULL,
	@New_Moved bit = NULL,
	@New_MovedDate date = NULL,
	@New_isClosed bit = 0,
	@New_isResolved bit = 0,
	@New_PersonNotes varchar(3000) = NULL,
	@New_TravelNotes varchar(3000) = NULL,
	@New_HobbyNotes varchar(3000) = NULL,
	@New_ReleaseNotes varchar(3000) = NULL,
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	@New_ClientStatusID smallint = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePersonsqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if PersonID is valid, if not return
		IF NOT EXISTS (SELECT PersonID from Person where PersonID = @Person_ID)
		BEGIN
			RAISERROR(15000, -1,-1,'usp_upPerson');
		END
		
		-- BUILD update statement
		IF (@New_LastName IS NULL)
			SELECT @New_LastName = LastName from Person where PersonID = @Person_ID;
	
		SELECT @spupdatePersonsqlStr = N'update Person set Lastname = @LastName'

		IF (@New_FirstName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', FirstName = @Firstname'

		IF (@New_MiddleName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MiddleName = @MiddleName'

		IF (@New_BirthDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', BirthDate = @BirthDate'

		IF (@New_Gender IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Gender = @Gender'

		IF (@New_StatusID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', StatusID = @StatusID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', ForeignTravel = @ForeignTravel'

		IF (@New_OutofSite IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', OutofSite = @OutofSite'

		IF (@New_EatsForeignFood IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', EatsForeignFood = @EatsForeignFood'

		IF (@New_EmailAddress IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', EmailAddress = @EmailAddress'

		IF (@New_RetestDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', RetestDate = @RetestDate'

		IF (@New_Moved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Moved = @Moved'

		IF (@New_MovedDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MovedDate = @MovedDate'

		IF (@New_isClosed IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClosed = @isClosed'

		IF (@New_isResolved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isResolved = @isResolved'
			
		IF (@New_GuardianID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', GuardianID = @GuardianID'
			
		IF (@New_PersonCode IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', PersonCode = @PersonCode'

		IF (@New_isSmoker IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isSmoker = @isSmoker'

		IF (@New_isClient IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClient = @isClient'

		IF (@New_NursingMother IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', NursingMother = @NursingMother'

		IF (@New_NursingInfant IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', NursingInfant = @NursingInfant'

		IF (@New_Pregnant IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Pregnant = @Pregnant'

		IF (@New_ClientStatusID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', ClientStatusID = @ClientStatusID'

		-- make sure to only update record for specified person
		SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N' WHERE PersonID = @PersonID'

		IF (@DEBUG = 1)
			SELECT @spupdatePersonsqlStr, LastName = @New_LastName, FirstName = @New_FirstName, MiddleName = @New_MiddleName
					, BirthDate = @New_BirthDate, Gender = @New_Gender, StatusID = @New_StatusID, ForeignTravel = @New_ForeignTravel
					, OutofSite = @New_OutofSite, EatsForeignFood = @New_EatsForeignFood, EmailAddress = @New_EmailAddress, RetestDate = @New_RetestDate
					, Moved = @New_Moved, MovedDate = @New_MovedDate, isClosed = @New_isClosed, isResolved = @New_isResolved
					, GuardianID = @New_GuardianID, PersonCode = @New_PersonCode, isSmoker = @New_isSmoker, isClient = @New_isClient
					, NursingMother = @New_NursingMother, NursingInfant = @New_NursingInfant, Pregnant = @New_Pregnant
					, ClientStatusID = @New_ClientStatusID, PersonID = @Person_ID

		EXEC [sp_executesql] @spupdatePersonsqlStr
				, N'@LastName VARCHAR(50), @FirstName VARCHAR(50), @MiddleName VARCHAR(50), @BirthDate date, @Gender char(1)
				, @StatusID smallint, @ForeignTravel BIT, @OutofSite bit, @EatsForeignFood bit, @EmailAddress varchar(320), @RetestDate date
				, @Moved bit, @MovedDate date, @isClosed bit, @isResolved bit, @GuardianID int, @PersonCode smallint, @isSmoker bit
				, @isClient bit, @NursingMother bit, @NursingInfant bit, @Pregnant bit, @ClientStatusID smallint, @PersonID int'
				, @LastName = @New_LastName
				, @FirstName = @New_FirstName
				, @MiddleName = @New_MiddleName
				, @BirthDate = @New_BirthDate
				, @Gender = @New_Gender
				, @StatusID = @New_StatusID
				, @ForeignTravel = @New_ForeignTravel
				, @OutofSite = @New_OutofSite
				, @EatsForeignFood = @New_EatsForeignFood
				, @EMailAddress = @New_EmailAddress
				, @RetestDate = @New_RetestDate
				, @Moved = @New_Moved
				, @MovedDate = @New_MovedDate
				, @isClosed = @New_isClosed
				, @isResolved = @New_isResolved
				, @GuardianID = @New_GuardianID
				, @PersonCode = @New_PersonCode
				, @isSmoker = @New_isSmoker
				, @isClient = @New_isClient
				, @NursingMother = @New_NursingMother
				, @NursingInfant = @New_NursingInfant
				, @Pregnant = @New_Pregnant
				, @ClientStatusID = @New_ClientStatusID
				, @PersonID = @Person_ID

			IF (@New_PersonNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
								@Person_ID = @Person_ID,
								@Notes = @New_PersonNotes,
								@InsertedNotesID = @NotesID OUTPUT

			IF (@New_ReleaseNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonReleaseNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_TravelNotes,
							@InsertedNotesID = @NotesID OUTPUT

			IF (@New_TravelNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonTravelNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_TravelNotes,
							@InsertedNotesID = @NotesID OUTPUT

			IF (@New_HobbyNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonHobbyNotes]
							@Person_ID = @Person_ID,
							@Notes = @New_HobbyNotes,
							@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to update property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_upProperty]   -- usp_upProperty 
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@New_ConstructionTypeID tinyint = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL, 
	@New_isRemodeled bit = NULL,
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	@New_AddressLine1 varchar(100) = NULL,
	@New_AddressLine2 varchar(100) = NULL,
	@New_City varchar(50) = NULL,
	@New_State char(2) = NULL,
	@New_Zipcode varchar(12) = NULL,
	@New_YearBuilt date = NULL,
	@New_Ownerid int = NULL,
	@New_isOwnerOccuppied bit = NULL,
	@New_ReplacedPipesFaucets tinyint = 0,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_isResidential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_hasPeelingChippingPaint bit = NULL,
	@New_County varchar(50) = NULL,
	@New_isRental bit = NULL,
	@New_OwnerContactInformation varchar(1000) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePropertysqlStr nvarchar(4000);
    -- Insert statements for procedure here
	BEGIN TRY
		if (@PropertyID iS NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Property must be specified';
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		-- BUILD update statement
		IF (@New_isinHistoricDistrict IS NULL)
			SELECT @New_isinHistoricDistrict = isinHistoricDistrict from Property where PropertyID = @PropertyID;
	
		SELECT @spupdatePropertysqlStr = N'update Property set isinHistoricDistrict = @isinHistoricDistrict'

		IF (@New_ConstructionTypeID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ConstructionTypeID = @ConstructionTypeID'

		IF (@New_AreaID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AreaID = @AreaID'

		IF (@New_isRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRemodeled = @isRemodeled'

		IF (@New_RemodelDate IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', RemodelDate = @RemodelDate'

		IF (@New_isinCityLimits IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isinCityLimits = @isinCityLimits'

		IF (@New_AddressLine1 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine1 = @AddressLine1'

		IF (@New_AddressLine2 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine2 = @AddressLine2'	
			
		IF (@New_City IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', City = @City'

		IF (@New_State IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', State = @State'

		IF (@New_Zipcode IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ZipCode = @ZipCode'

		IF (@New_Ownerid IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', OwnerID = @OwnerID'
			
		IF (@New_isOwnerOccuppied IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isOwnerOccuppied = @isOwnerOccuppied'
			
		IF (@New_ReplacedPipesFaucets IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ReplacedPipesFaucets = @ReplacedPipesFaucets'
			
		IF (@New_TotalRemediationCosts IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', TotalRemediationCosts = @TotalRemediationCosts'
			
		IF (@New_isResidential IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isResidential = @isResidential'
			
		IF (@New_isCurrentlyBeingRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isCurrentlyBeingRemodeled = @isCurrentlyBeingRemodeled'
			
		IF (@New_hasPeelingChippingPaint IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', hasPeelingChippingPaint = @hasPeelingChippingPaint'
			
		IF (@New_County IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', County = @County'
			
		IF (@New_isRental IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRental = @isRental'
			
		IF (@New_YearBuilt IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', YearBuilt = @YearBuilt'

		IF (@New_OwnerContactInformation IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', OwnerContactInformation = @OwnerContactInformation'

		SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N' WHERE PropertyID = @PropertyID'

		-- update property table
		IF @DEBUG = 1
			SELECT @spupdatePropertysqlStr, New_ConstructionTypeID = @New_ConstructionTypeID, New_AreaID = @New_AreaID
					, New_isinHistoricDistrict = @New_isinHistoricDistrict, New_isRemodeled = @New_isRemodeled
					, New_RemodelDate = @New_RemodelDate, New_isinCityLimits = @New_isinCityLimits
					, New_AddressLine1 = @New_AddressLine1, New_AddressLine2 = @New_AddressLine2, New_City = @New_City
					, New_State = @New_State, New_Zipcode = @New_Zipcode, New_OwnerID = @New_Ownerid
					, New_isOwnerOccuppied = @New_isOwnerOccuppied, New_ReplacedPipesFaucets = @New_ReplacedPipesFaucets
					, New_PropertyNotes = @New_PropertyNotes, New_TotalRemediationCosts = @New_TotalRemediationCosts
					, New_isResidential = @New_isResidential, New_isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled
					, New_hasPeelingChippingPaint = @New_hasPeelingChippingPaint, New_County = @New_County
					, New_isRental = @New_isRental, New_YearBuilt = @New_YearBuilt
					, New_OwnerContactInformation = @New_OwnerContactInformation, PropertyID = @PropertyID

		EXEC [sp_executesql] @spupdatePropertysqlStr 
			, N'@ConstructionTypeID tinyint, @AreaID int, @isinHistoricDistrict bit, @isRemodeled bit, @RemodelDate date
			, @isinCityLimits BIT, @AddressLine1 varchar(100), @AddressLine2 varchar(100), @City varchar(50), @State char(2)
			, @Zipcode varchar(12), @OwnerID int, @isOwnerOccuppied bit, @ReplacedPipesFaucets tinyint, @TotalRemediationCosts money
			, @isResidential bit, @isCurrentlyBeingRemodeled bit, @hasPeelingChippingPaint bit
			, @County varchar(50), @isRental bit, @YearBuilt date, @OwnerContactInformation varchar(1000), @PropertyID int'
			, @ConstructionTypeID = @New_ConstructionTypeID
			, @AreaID = @New_AreaID
			, @isinHistoricDistrict = @New_isinHistoricDistrict
			, @isRemodeled = @New_isRemodeled
			, @RemodelDate = @New_RemodelDate
			, @isinCityLimits = @New_isinCityLimits
			, @AddressLine1 = @New_AddressLine1
			, @AddressLine2 = @New_AddressLine2
			, @City = @New_City
			, @State = @New_State
			, @Zipcode = @New_Zipcode
			, @OwnerID = @New_Ownerid
			, @isOwnerOccuppied = @New_isOwnerOccuppied
			, @ReplacedPipesFaucets = @New_ReplacedPipesFaucets
			, @TotalRemediationCosts = @New_TotalRemediationCosts
			, @isResidential = @New_isResidential
			, @isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled
			, @hasPeelingChippingPaint = @New_hasPeelingChippingPaint
			, @County = @New_County
			, @isRental = @New_isRental
			, @YearBuilt = @New_YearBuilt
			, @OwnerContactInformation = @New_OwnerContactInformation
			, @PropertyID = @PropertyID

		IF (@New_PropertyNotes IS NOT NULL)
		BEGIN
			IF @DEBUG = 1
				SELECT 'EXEC [dbo].[usp_InsertPropertyNotes] @Property_ID = @Property_ID, @Notes = @New_PropertyNotes, @InsertedNotesID = @NotesID OUTPUT ' 
					, @PropertyID, @New_PropertyNotes

				EXEC	[dbo].[usp_InsertPropertyNotes]
						@Property_ID = @PropertyID,
						@Notes = @New_PropertyNotes,
						@InsertedNotesID = @NotesID OUTPUT
		END

	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upQuestionnaire]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130618
-- Description:	Stored Procedure to update 
--              questionnaire records
-- =============================================
-- DROP PROCEDURE usp_upQuestionnaire
CREATE PROCEDURE [dbo].[usp_upQuestionnaire]  
	-- Add the parameters for the stored procedure here
	@QuestionnaireID int = NULL,
	@New_QuestionnaireDate date = NULL,
	@New_QuestionnaireDataSourceID int = NULL,
	@New_VisitRemodeledProperty bit = NULL,
	@New_PaintDate date = NULL,
	@New_RemodelPropertyDate date = NULL,
	@New_isExposedtoPeelingPaint bit = NULL,
	@New_isTakingVitamins bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	@New_isUsingPacifier bit = NULL,
	@New_isUsingBottle bit = NULL,
	@New_BitesNails bit = NULL,
	@New_NonFoodEating bit = NULL,
	@New_NonFoodinMouth bit = Null,
	@New_EatOutside bit = NULL,
	@New_Suckling bit = NULL,
	@New_Mouthing bit = NULL,
	@New_FrequentHandWashing bit = NULL,
	@New_VisitsOldHomes bit = NULL,
	@New_DaycareID int = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdateQuestionnairesqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if QuestionnaireID is valid, if not return
		IF NOT EXISTS (SELECT QuestionnaireID from Questionnaire where QuestionnaireID = @QuestionnaireID)
		BEGIN
			RAISERROR('QuestionnaireID must be specified and valid', 11,-1,'usp_upQuestionnaire');
		END
		
		-- BUILD update statement
		if (@New_QuestionnaireDate is null)
			select @New_QuestionnaireDate = QuestionnaireDate from Questionnaire where QuestionnaireID = @QuestionnaireID
		
		SELECT @spupdateQuestionnairesqlStr = N'update Questionnaire set QuestionnaireDate = @QuestionnaireDate'

		IF (@New_QuestionnaireDataSourceID IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', QuestionnaireDataSourceID = @QuestionnaireDataSourceID'

		IF (@New_VisitRemodeledProperty IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', VisitRemodeledProperty = @VisitRemodeledProperty'

		IF (@New_PaintDate IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', PaintDate = @PaintDate'

		IF (@New_RemodelPropertyDate IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', RemodelPropertyDate = @RemodelPropertyDate'

		IF (@New_isExposedtoPeelingPaint IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isExposedtoPeelingPaint = @isExposedtoPeelingPaint'

		IF (@New_isTakingVitamins IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isTakingVitamins = @isTakingVitamins'

		IF (@New_NursingMother IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NursingMother = @NursingMother'

		IF (@New_NursingInfant IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NursingInfant = @NursingInfant'

		IF (@New_Pregnant IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Pregnant = @Pregnant'

		IF (@New_isUsingPacifier IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isUsingPacifier = @isUsingPacifier'

		IF (@New_isUsingBottle IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isUsingBottle = @isUsingBottle'

		IF (@New_BitesNails IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', BitesNails = @BitesNails'

		IF (@New_NonFoodEating IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NonFoodEating = @NonFoodEating'

		IF (@New_NonFoodinMouth IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NonFoodinMouth = @NonFoodinMouth'

		IF (@New_EatOutside IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', EatOutside = @EatOutside'

		IF (@New_Suckling IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Suckling = @Suckling'

		IF (@New_Mouthing IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Mouthing = @Mouthing'
		
		IF (@New_FrequentHandWashing IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', FrequentHandWashing = @FrequentHandWashing'

		IF (@New_VisitsOldHomes IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', VisitsOldHomes = @VisitsOldHomes'

		IF (@New_DaycareID IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', DayCareID = @DaycareID'

		-- make sure to only update record for specified Questionnaire
		SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N' WHERE QuestionnaireID = @QuestionnaireID'

		IF (@DEBUG = 1)
			SELECT @spupdateQuestionnairesqlStr, QuestionnaireDate = @New_QuestionnaireDate, QuestionnaireDataSourceID = @New_QuestionnaireDataSourceID
					, VisitRemodeledProperty = @New_VisitRemodeledProperty, PaintDate = @New_PaintDate, RemodelPropertyDate = @New_RemodelPropertyDate
					, isExposedtoPeelingPaint = @New_isExposedtoPeelingPaint, isTakingVitamins = @New_isTakingVitamins, NursingMother = @New_NursingMother
					, NursingInfant = @New_NursingInfant, Pregnant = @New_Pregnant, isUsingPacifier = @New_isUsingPacifier, isUsingBottle = @New_isUsingBottle
					, Bitesnails = @New_BitesNails, NonFoodEating = @New_NonFoodEating, NonFoodinMouth = @New_NonFoodinMouth, EatOutside = @New_EatOutside
					, Suckling = @New_Suckling, Mouthing = @New_Mouthing, FrequentHandWashing = @New_FrequentHandWashing, VisitsOldHomes = @New_VisitsOldHomes
					, DaycareID = @New_DaycareID, QuestionnaireID = @QuestionnaireID, DEBUG = @DEBUG

		EXEC [sp_executesql] @spupdateQuestionnairesqlStr
				, N'@QuestionnaireDate date, @QuestionnaireDataSourceID int, @VisitRemodeledProperty bit, @PaintDate date, @RemodelPropertyDate date
				, @isExposedtoPeelingPaint bit, @isTakingVitamins bit, @NursingMother bit, @NursingInfant bit, @Pregnant bit, @isUsingPacifier bit
				, @isUsingBottle bit, @BitesNails bit, @NonFoodEating bit, @NonFoodinMouth bit, @Eatoutside bit, @Suckling bit, @Mouthing bit
				, @FrequentHandWashing bit , @VisitsOldHomes bit, @DaycareID int, @QuestionnaireID int'
				, @QuestionnaireDate = @New_QuestionnaireDate
				, @QuestionnairedataSourceID = @New_QuestionnaireDataSourceID
				, @VisitRemodeledProperty = @New_VisitRemodeledProperty
				, @PaintDate = @New_PaintDate
				, @RemodelPropertyDate = @New_RemodelPropertyDate
				, @isExposedtoPeelingPaint = @New_isExposedtoPeelingPaint
				, @isTakingVitamins = @New_isTakingVitamins
				, @NursingMother = @New_NursingMother
				, @NursingInfant = @New_NursingInfant
				, @Pregnant = @New_Pregnant
				, @isUsingPacifier = @New_isUsingPacifier
				, @isUsingBottle = @New_isUsingBottle
				, @BitesNails = @New_BitesNails
				, @NonFoodEating = @New_NonFoodEating
				, @NonFoodinMouth = @New_NonFoodinMouth
				, @EatOutside = @New_EatOutside
				, @Suckling = @New_Suckling
				, @Mouthing = @New_Mouthing
				, @FrequentHandWashing = @New_FrequentHandWashing
				, @VisitsOldHomes = @New_VisitsOldHomes
				, @DaycareID = @New_DaycareID
				, @QuestionnaireID = @QuestionnaireID

			IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertQuestionnaireNotes]
								@Questionnaire_ID = @QuestionnaireID,
								@Notes = @New_Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		THROW
	END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_upQuestionnaireWebScreen]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to update 
--              questionnaire data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_upQuestionnaireWebScreen]
	-- Add the parameters for the stored procedure here
		@QuestionnaireID int = NULL,
		@QuestionnaireDate date = NULL,
		@QuestionnaireDataSourceID int = NULL,
		@VisitRemodeledProperty bit = NULL,
		@PaintDate date = NULL,
		@RemodelPropertyDate date = NULL,
		@isExposedtoPeelingPaint bit = NULL,
		@isTakingVitamins bit = NULL,
		@NursingMother bit = NULL,
		@NursingInfant bit = NULL,
		@Pregnant bit = NULL,
		@isUsingPacifier bit = NULL,
		@isUsingBottle bit = NULL,
		@BitesNails bit = NULL,
		@NonFoodEating bit = NULL,
		@NonFoodinMouth bit = Null,
		@EatOutside bit = NULL,
		@Suckling bit = NULL,
		@Mouthing bit = NULL,
		@FrequentHandWashing bit = NULL,
		@VisitsOldHomes bit = NULL,
		@DaycareID int = NULL,
		@Notes varchar(3000) = NULL,
		@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int, @updateQuestionnaireReturnValue int;
	
		-- If no family ID was passed in exit
		IF (@QuestionnaireID IS NULL)
		BEGIN
			RAISERROR ('Questionnaire ID must be supplied', 11, -1);
			RETURN;
		END;

		BEGIN TRY  
			-- update questionnaire
			EXEC	@updateQuestionnaireReturnValue = [dbo].[usp_upQuestionnaire]
														@QuestionnaireID = @QuestionnaireID,
														@New_QuestionnaireDate = @QuestionnaireDate,
														@New_QuestionnaireDataSourceID = @QuestionnaireDataSourceID,
														@New_VisitRemodeledProperty = @VisitRemodeledProperty,
														@New_PaintDate = @PaintDate,
														@New_RemodelPropertyDate = @RemodelPropertyDate,
														@New_isExposedtoPeelingPaint = @isExposedtoPeelingPaint,
														@New_isTakingVitamins = @isTakingVitamins,
														@New_NursingMother = @NursingMother,
														@New_NursingInfant = @NursingInfant,
														@New_Pregnant = @Pregnant,
														@New_isUsingPacifier = @isUsingPacifier,
														@New_isUsingBottle = @isUsingBottle,
														@New_BitesNails = @BitesNails,
														@New_NonFoodEating = @NonFoodEating,
														@New_NonFoodinMouth = @NonFoodinMouth,
														@New_EatOutside = @EatOutside,
														@New_Suckling = @Suckling,
														@New_Mouthing = @Mouthing,
														@New_FrequentHandWashing = @FrequentHandWashing,
														@New_VisitsOldHomes = @VisitsOldHomes,
														@New_DaycareID = @DaycareID,
														@New_Notes = @Notes,
														@DEBUG = @DEBUG

		END TRY
		BEGIN CATCH -- insert person
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; -- insert new person
	END
END

GO
/****** Object:  StoredProcedure [dbo].[uspLogError]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT  -- Contains the ErrorLogID of the row inserted
                                  -- by uspLogError in the ErrorLog table.

AS
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged.
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log.
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END;

        INSERT [dbo].[ErrorLog] 
            (
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SELECT @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END; 
GO
/****** Object:  StoredProcedure [dbo].[uspPrintError]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;

GO
/****** Object:  UserDefinedFunction [dbo].[udf_CalculateAge]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_CalculateAge]
 (
   @BirthDate datetime = NULL,
   @CurrentDate datetime = NULL
 )
 RETURNS int

 AS

 BEGIN

 IF @BirthDate IS NULL
	RETURN -1;

 IF @CurrentDate IS NULL
	SET @CurrentDate = GetDate();

 IF @BirthDate > @CurrentDate
   RETURN 0

 DECLARE @Age int
 SELECT @Age = DATEDIFF(YY, @BirthDate, @CurrentDate) - 
	CASE WHEN(
		(MONTH(@BirthDate)*100 + DAY(@BirthDate)) >
		(MONTH(@CurrentDate)*100 + DAY(@CurrentDate))
	) THEN 1 ELSE 0 END
 RETURN @Age

 END



GO
/****** Object:  UserDefinedFunction [dbo].[udf_DateInThePast]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150220
-- Description:	function to ensure date is less than current date
-- =============================================
CREATE FUNCTION [dbo].[udf_DateInThePast] 
(
	-- Add the parameters for the function here
	@CheckDate date
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result bit

	-- Add the T-SQL statements to compute the return value here
	IF (@CheckDate < GetDate())
		SET @Result = 1;
	ELSE 
		SET @Result = 0;

	-- Return the result of the function
	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[udf_DoesPropertyExist]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150322
-- Description:	Function to check for duplicate property
-- =============================================
CREATE FUNCTION [dbo].[udf_DoesPropertyExist] 
(
	-- Add the parameters for the function here
	@AddressLine1 varchar(100),
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50),
	@State char(2),
	@ZipCode varchar(12)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PropertyID int

	
	IF (@AddressLine2 IS NULL)
		SELECT @PropertyID = PropertyID from Property where
			-- (dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AddressLine1 = @AddressLine1
			AND (AddressLine2 = '')
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)
	ELSE
		SELECT @PropertyID = PropertyID from Property where
			--(dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AddressLine1 = @AddressLine1
			--AND (dbo.RemoveSpecialChars(AddressLine2) = dbo.RemoveSpecialChars(@AddressLine2))
			AND AddressLine2 = @AddressLine2
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)


	-- Return the result of the function
	RETURN @PropertyID

END

GO
/****** Object:  UserDefinedFunction [dbo].[udf_SlFamilyPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	select specific phone number of 
--				specified type for specific family
-- =============================================
CREATE FUNCTION [dbo].[udf_SlFamilyPhoneNumber] 
(
	-- Add the parameters for the function here
	@Family_ID int,
	@PhoneNumberTypeID tinyint
)
RETURNS bigint
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PhoneNumber bigint--, @PhoneNumberTypeID tinyint; --, @Family_ID int, @PhoneNumberTypeID tinyint;
	--SET @PhoneNumberTypeID = 1
	-- Add the T-SQL statements to compute the return value here
--	SELECT @PhoneNumber = @Family_ID

	Select @PhoneNumber = [P].[PhoneNumber] from [PhoneNumber] AS [P]
	JOIN [FamilytoPhoneNumber] AS [P2N] ON [P].[PhoneNumberID] = [P2N].[PhoneNumberID]
	JOIN [Family] AS [F] ON [P2N].[FamilyID] = [F].[FamilyID]
	WHERE [F].[FamilyID] = @Family_ID and [P2N].[NumberPriority] = @PhoneNumberTypeID

	-- Select @PhoneNumber
	-- Return the result of the function
	RETURN @PhoneNumber

END

GO
/****** Object:  Table [dbo].[Person]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[BirthDate] [date] NULL,
	[Gender] [char](1) NULL,
	[StatusID] [smallint] NULL,
	[ForeignTravel] [bit] NULL,
	[OutofSite] [bit] NULL,
	[EatsForeignFood] [bit] NULL,
	[HistoricChildID] [smallint] NULL,
	[RetestDate] [date] NULL,
	[Moved] [bit] NULL,
	[MovedDate] [date] NULL,
	[isClosed] [bit] NULL,
	[isResolved] [bit] NULL,
	[GuardianID] [int] NULL,
	[personCode] [smallint] NULL,
	[isSmoker] [bit] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Person_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[Age]  AS ([dbo].[udf_CalculateAge]([BirthDate],getdate())),
	[isClient] [bit] NULL CONSTRAINT [DF_Person_isClient]  DEFAULT ((1)),
	[NursingMother] [bit] NULL,
	[Pregnant] [bit] NULL,
	[ReleaseStatusID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[EmailAddress] [varchar](320) NULL,
	[NursingInfant] [bit] NULL,
	[ClientStatusID] [smallint] NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vNursingMothers]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vNursingMothers]
AS
SELECT        P.PersonID, P.LastName, P.FirstName, P.Age, P.Gender,P.NursingMother
FROM            dbo.Person AS P
WHERE        (P.NursingMother = 1)
				AND P.isClient = 1

GO
/****** Object:  View [dbo].[vAdults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vAdults]
AS
SELECT        P.PersonID, P.LastName, P.FirstName, P.Age, P.Gender,P.BirthDate, P.Pregnant, P.NursingMother
FROM            dbo.Person AS P
WHERE        (P.Age > 17) and P.isClient = 1 AND P.Pregnant = 0 AND P.NursingMother = 0

GO
/****** Object:  Table [dbo].[BloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BloodTestResults](
	[BloodTestResultsID] [int] IDENTITY(1,1) NOT NULL,
	[isBaseline] [bit] NOT NULL CONSTRAINT [DF_BloodTestResults_isBaseline]  DEFAULT ((0)),
	[PersonID] [int] NULL,
	[SampleDate] [date] NOT NULL CONSTRAINT [DF_BloodTestResults_SampleDate]  DEFAULT (getdate()),
	[LabSubmissionDate] [date] NULL,
	[LeadValue] [numeric](4, 1) NULL,
	[LeadValueCategoryID] [tinyint] NULL,
	[HemoglobinValue] [numeric](4, 1) NULL,
	[HemoglobinValueCategoryID] [tinyint] NULL,
	[HematocritValueCategoryID] [tinyint] NULL,
	[LabID] [int] NULL,
	[BloodTestCosts] [money] NULL,
	[SampleTypeID] [tinyint] NULL,
	[TakenAfterPropertyRemediationCompleted] [bit] NULL CONSTRAINT [DF_BloodTestResults_TakenAfterPropertyRemediationCompleted]  DEFAULT ((0)),
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_BloodTestResults_CreatedDate]  DEFAULT (getdate()),
	[HematocritValue]  AS ([hemoglobinValue]*(3)),
	[ExcludeResult] [bit] NULL,
	[HistoricBloodTestResultsID] [int] NULL,
	[HistoricLabResultsID] [varchar](10) NULL,
	[ClientStatusID] [smallint] NULL,
 CONSTRAINT [PK_BloodTestResults] PRIMARY KEY CLUSTERED 
(
	[BloodTestResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vMostRecentBloodTestResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [dbo].[vMostRecentBloodTestResults]

AS

Select [P].[LastName],[P].[FirstName],[P].[PersonID],[BTR].[BloodTestResultsID]
	,[BTR].[isBaseline]
      ,[BTR].[SampleDate]
      ,[BTR].[LabSubmissionDate]
      ,[BTR].[LeadValue]
      ,[BTR].[LeadValueCategoryID]
      ,[BTR].[HemoglobinValue]
      ,[BTR].[HemoglobinValueCategoryID]
      ,[BTR].[HematocritValueCategoryID]
      ,[BTR].[LabID]
      ,[BTR].[BloodTestCosts]
      ,[BTR].[SampleTypeID]
      ,[BTR].[TakenAfterPropertyRemediationCompleted]
      ,[BTR].[ModifiedDate]
      ,[BTR].[CreatedDate]
      ,[BTR].[HematocritValue]
      ,[BTR].[ExcludeResult]
	  ,[BTR].[ClientStatusID]
      ,[BTR].[HistoricBloodTestResultsID]
      ,[BTR].[HistoricLabResultsID] from [Person] AS [P]
	JOIN [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
									select top 1 [BloodTestResultsID] from [BloodTestResults] 
									where [BloodTestResults].[PersonID] = [P].[PersonID]
									-- AND [LeadValue] > @MinLeadValue uncomment to list most recent tests with BLL above minimum
									)
	WHERE [P].[isClient] = 1

GO
/****** Object:  Table [dbo].[Questionnaire]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaire](
	[QuestionnaireID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[QuestionnaireDate] [date] NULL,
	[QuestionnaireDataSourceID] [int] NULL,
	[VisitRemodeledProperty] [bit] NULL,
	[isExposedtoPeelingPaint] [bit] NULL,
	[isTakingVitamins] [bit] NULL CONSTRAINT [DF_Questionnaire_isTakingVitamins]  DEFAULT ((0)),
	[NursingMother] [bit] NULL CONSTRAINT [DF_Questionnaire_isNursing]  DEFAULT ((0)),
	[isUsingPacifier] [bit] NULL CONSTRAINT [DF_Questionnaire_isUsingPacifier]  DEFAULT ((0)),
	[isUsingBottle] [bit] NULL CONSTRAINT [DF_Questionnaire_isUsingBottle]  DEFAULT ((0)),
	[BitesNails] [bit] NULL CONSTRAINT [DF_Questionnaire_Bitesnails]  DEFAULT ((0)),
	[NonFoodEating] [bit] NULL CONSTRAINT [DF_Questionnaire_NonFoodEating]  DEFAULT ((0)),
	[NonFoodinMouth] [bit] NULL CONSTRAINT [DF_Questionnaire_NonFoodinMouth]  DEFAULT ((0)),
	[EatOutside] [bit] NULL CONSTRAINT [DF_Questionnaire_EatOutside]  DEFAULT ((0)),
	[Suckling] [bit] NULL CONSTRAINT [DF_Questionnaire_Suckling]  DEFAULT ((0)),
	[FrequentHandWashing] [bit] NULL CONSTRAINT [DF_Questionnaire_FrequentHandWashing]  DEFAULT ((0)),
	[DaycareID] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Questionnaire_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[Mouthing] [bit] NULL,
	[VisitsOldHomes] [bit] NULL,
	[NursingInfant] [bit] NULL,
	[Pregnant] [bit] NULL,
	[PaintDate] [date] NULL,
	[RemodelPropertyDate] [date] NULL,
	[PaintAge]  AS ([dbo].[udf_CalculateAge]([PaintDate],getdate())),
	[RemodelPropertyAge]  AS ([dbo].[udf_CalculateAge]([RemodelPropertyDate],getdate())),
 CONSTRAINT [PK_Questionnaire] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  View [dbo].[vMostRecentQuestionnaires]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [dbo].[vMostRecentQuestionnaires]

AS

Select [P].[LastName],[P].[FirstName],[P].[PersonID]
	  ,[Q].[QuestionnaireID]
      ,[Q].[QuestionnaireDate]
      ,[Q].[QuestionnaireDataSourceID]
      ,[Q].[VisitRemodeledProperty]
      ,[Q].[isExposedtoPeelingPaint]
      ,[Q].[isTakingVitamins]
      ,[Q].[NursingMother]
      ,[Q].[isUsingPacifier]
      ,[Q].[isUsingBottle]
      ,[Q].[BitesNails]
      ,[Q].[NonFoodEating]
      ,[Q].[NonFoodinMouth]
      ,[Q].[EatOutside]
      ,[Q].[Suckling]
      ,[Q].[FrequentHandWashing]
      ,[Q].[DaycareID]
      ,[Q].[CreatedDate]
      ,[Q].[ModifiedDate]
      ,[Q].[RemodelPropertyDate]
      ,[Q].[RemodelPropertyAge]
      ,[Q].[PaintDate]
      ,[Q].[PaintAge]
      ,[Q].[ReviewStatusID]
      ,[Q].[Mouthing]
      ,[Q].[VisitsOldHomes]
      ,[Q].[NursingInfant]
      ,[Q].[Pregnant]
	   from [Person] AS [P]
	JOIN [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
									select top 1 [QuestionnaireID] from [Questionnaire] 
									where [Questionnaire].[PersonID] = [P].[PersonID]
									-- AND [LeadValue] > @MinLeadValue uncomment to list most recent tests with BLL above minimum
									)
	WHERE [P].[isClient] = 1

GO
/****** Object:  View [dbo].[vNursingInfants]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vNursingInfants]
AS
SELECT        P.PersonID, P.LastName, P.FirstName, P.Age, P.Gender,P.NursingInfant
FROM            dbo.Person AS P
WHERE        (P.NursingInfant = 1)
		AND [P].[isClient] = 1

GO
/****** Object:  View [dbo].[vPregnant]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vPregnant]
AS
SELECT        P.PersonID, P.LastName, P.FirstName, P.Age, P.Gender,P.Pregnant
FROM            dbo.Person AS P
WHERE        (P.Pregnant = 1)
		AND P.isClient = 1

GO
/****** Object:  UserDefinedFunction [dbo].[RemoveSpecialChars]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Removes special characters from a string value.
-- All characters except 0-9, a-z and A-Z are removed and
-- the remaining characters are returned.
-- Author: Christian d'Heureuse, www.source-code.biz
CREATE function [dbo].[RemoveSpecialChars] (@s varchar(256)) returns varchar(256)
   with schemabinding
begin
   if @s is null
      return null
   declare @s2 varchar(256)
   set @s2 = ''
   declare @l int
   set @l = len(@s)
   declare @p int
   set @p = 1
   while @p <= @l begin
      declare @c int
      set @c = ascii(substring(@s, @p, 1))
      if @c between 48 and 57 or @c between 65 and 90 or @c between 97 and 122
         set @s2 = @s2 + char(@c)
      set @p = @p + 1
      end
   if len(@s2) = 0
      return null
   return @s2
   end
GO
/****** Object:  Table [dbo].[AccessAgreement]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessAgreement](
	[AccessAgreementID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPurposeID] [int] NULL,
	[AccessAgreementFile] [varbinary](max) NULL,
	[PropertyID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_AccessAgreement_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_AccessAgreement] PRIMARY KEY CLUSTERED 
(
	[AccessAgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccessAgreementNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessAgreementNotes](
	[AccessAgreementNotesID] [int] IDENTITY(1,1) NOT NULL,
	[AccessAgreementID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_AccessAgreementNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NULL,
 CONSTRAINT [PK_AccessAgreementNotes] PRIMARY KEY CLUSTERED 
(
	[AccessAgreementNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccessPurpose]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessPurpose](
	[AccessPurposeID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPurposeName] [varchar](50) NULL,
	[AccessPurposeDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_AccessPurpose_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_AccessPurpose] PRIMARY KEY CLUSTERED 
(
	[AccessPurposeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ActionStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActionStatus](
	[ActionStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ActionStatusDescription] [varchar](253) NULL,
	[ActionStatusName] [varchar](50) NULL,
	[HistoricActionStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ActionStatus] PRIMARY KEY CLUSTERED 
(
	[ActionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Area]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Area](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[AreaDescription] [varchar](253) NULL,
	[HistoricAreaID] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Area_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BloodTestResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BloodTestResultsNotes](
	[BloodTestResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[BloodTestResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_BloodTestResultsNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_BloodTestResultsNotes] PRIMARY KEY CLUSTERED 
(
	[BloodTestResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CleanupStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CleanupStatus](
	[CleanupStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CleanupStatusDescription] [varchar](253) NULL,
	[CleanupStatusName] [varchar](50) NULL,
	[HistoricCleanupStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_CleanupStatus_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CleanupStatus] PRIMARY KEY CLUSTERED 
(
	[CleanupStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Condition]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Condition](
	[ConditionID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ConditionDescription] [varchar](253) NULL,
	[ConditionName] [varchar](50) NULL,
	[HistoricConditionID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Condition] PRIMARY KEY CLUSTERED 
(
	[ConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ConstructionType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConstructionType](
	[ConstructionTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeName] [varchar](50) NOT NULL,
	[ConstructionTypeDescription] [varchar](253) NULL,
	[HistoricConstructionTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ConstructionType_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ConstructionType] PRIMARY KEY CLUSTERED 
(
	[ConstructionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactType](
	[ContactTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ContactTypeDescription] [varchar](253) NULL,
	[ContactTypeName] [varchar](50) NULL,
	[HistoricContactTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Contractor]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contractor](
	[ContractorID] [int] IDENTITY(1,1) NOT NULL,
	[ContractorName] [varchar](50) NULL,
	[ContractorDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Contractor_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Contractor] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContractortoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoProperty](
	[ContractorID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ContractortoProperty_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ContractortoProperty] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[ContractortoRemediation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoRemediation](
	[ContractorID] [int] NOT NULL,
	[RemediationID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[isSubContractor] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ContractortoRemediation_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ContractortoRemediation] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[RemediationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[ContractortoRemediationActionPlan]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoRemediationActionPlan](
	[ContractorID] [int] NOT NULL,
	[RemediationActionPlanID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[isSubContractor] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ContractortoRemediationActionPlan_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ContractortoRemediationActionPlan] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[RemediationActionPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Country_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataSource]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataSource](
	[DataSourceID] [tinyint] IDENTITY(1,1) NOT NULL,
	[DataSourceDescription] [varchar](253) NULL,
	[DataSourceName] [varchar](50) NULL,
	[HistoricDataSourceID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED 
(
	[DataSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Daycare]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Daycare](
	[DaycareID] [int] IDENTITY(1,1) NOT NULL,
	[DaycareName] [varchar](50) NOT NULL,
	[DaycareDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Daycare_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Daycare] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DaycarePrimaryContact]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DaycarePrimaryContact](
	[DaycareID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[ContactPriority] [tinyint] NOT NULL CONSTRAINT [DF_DaycareContactPerson_ContactPriority]  DEFAULT ((1)),
	[PrimaryPhoneNumberID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_DaycarePrimaryContact_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_DaycareContactPerson] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC,
	[PersonID] ASC,
	[ContactPriority] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[DaycaretoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DaycaretoProperty](
	[DaycareID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_DaycaretoProperty_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_DaycaretoProperty_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_DaycaretoProperty] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC,
	[PropertyID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[Employer]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Employer](
	[EmployerID] [int] IDENTITY(1,1) NOT NULL,
	[EmployerName] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Employer_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Employer] PRIMARY KEY CLUSTERED 
(
	[EmployerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmployertoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployertoProperty](
	[EmployerID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_EmployertoProperty_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_EmployertoProperty_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_EmployertoProperty] PRIMARY KEY CLUSTERED 
(
	[EmployerID] ASC,
	[PropertyID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[EnvironmentalInvestigation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnvironmentalInvestigation](
	[EnvironmentalInvestigationID] [int] IDENTITY(1,1) NOT NULL,
	[ConductEnvironmentalInvestigation] [bit] NULL,
	[ConductEnvironmentalInvestigationDecisionDate] [date] NULL,
	[Cost] [money] NULL,
	[EnvironmentalInvestigationDate] [date] NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_EnvironmentalInvestigation_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_EnvironmentalInvestigation] PRIMARY KEY CLUSTERED 
(
	[EnvironmentalInvestigationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](128) NOT NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](128) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NULL,
	[ErrorTime] [datetime] NULL CONSTRAINT [DF_ErrorLog_ErrorTime]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ErrorLog_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED 
(
	[ErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[Ethnicity]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ethnicity](
	[EthnicityID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Ethnicity] [varchar](50) NOT NULL,
	[HistoricEthnicityCode] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Ethnicity_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Ethnicity] PRIMARY KEY CLUSTERED 
(
	[EthnicityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Family]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Family](
	[FamilyID] [int] IDENTITY(1,1) NOT NULL,
	[Lastname] [varchar](50) NOT NULL,
	[NumberofSmokers] [tinyint] NULL,
	[PrimaryLanguageID] [tinyint] NULL CONSTRAINT [DF_Family_PrimaryLanguageID]  DEFAULT ((1)),
	[Pets] [tinyint] NULL,
	[Petsinandout] [bit] NULL,
	[HistoricFamilyID] [smallint] NULL,
	[PrimaryPropertyID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Family_CreatedDate]  DEFAULT (getdate()),
	[FrequentlyWashPets] [bit] NULL,
	[ForeignTravel] [bit] NULL,
	[ReviewStatusID] [tinyint] NULL,
 CONSTRAINT [PK_Family] PRIMARY KEY CLUSTERED 
(
	[FamilyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FamilyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FamilyNotes](
	[FamilyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FamilyNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_FamilyNotes] PRIMARY KEY CLUSTERED 
(
	[FamilyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FamilytoPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilytoPhoneNumber](
	[FamilyID] [int] NOT NULL,
	[PhoneNumberID] [int] NOT NULL,
	[NumberPriority] [tinyint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FamilytoPhoneNumber_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_FamilytoPhoneNumber] PRIMARY KEY CLUSTERED 
(
	[FamilyID] ASC,
	[PhoneNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[FamilytoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilytoProperty](
	[FamilytoPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[PropertyLinkTypeID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[StartDate] [date] NULL CONSTRAINT [DF_FamilytoProperty_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[isPrimaryResidence] [bit] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FamilytoProperty_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_FamilytoProperty] PRIMARY KEY CLUSTERED 
(
	[FamilytoPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[FileType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FileType](
	[FileTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[FileTypeName] [varchar](50) NOT NULL,
	[FileTypeDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FileType_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_FileTypes] PRIMARY KEY CLUSTERED 
(
	[FileTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Flag]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Flag](
	[FlagID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FlagDescription] [varchar](253) NULL,
	[FlagName] [varchar](50) NULL,
	[HistoricFlagID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Flag] PRIMARY KEY CLUSTERED 
(
	[FlagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ForeignFood]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ForeignFood](
	[ForeignFoodID] [int] IDENTITY(1,1) NOT NULL,
	[ForeignFoodName] [varchar](50) NULL,
	[ForeignFoodDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ForeignFood_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ForeignFood] PRIMARY KEY CLUSTERED 
(
	[ForeignFoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ForeignFoodtoCountry]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForeignFoodtoCountry](
	[ForeignFoodID] [int] NOT NULL,
	[CountryID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ForeignFoodtoCountry_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ForeignFoodtoCountry] PRIMARY KEY CLUSTERED 
(
	[ForeignFoodID] ASC,
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[Frequency]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Frequency](
	[FrequencyID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FrequencyDescription] [varchar](253) NULL,
	[FrequencyName] [varchar](50) NULL,
	[HistoricFrequencyID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Frequency] PRIMARY KEY CLUSTERED 
(
	[FrequencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GiftCard]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCard](
	[GiftCardID] [int] IDENTITY(1,1) NOT NULL,
	[GiftCardValue] [money] NOT NULL CONSTRAINT [DF_GiftCertificate_GiftCertificateValue]  DEFAULT ((25)),
	[IssueDate] [date] NOT NULL CONSTRAINT [DF_GiftCard_IssueDate]  DEFAULT (getdate()),
	[PersonID] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_GiftCard_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_GiftCertificate] PRIMARY KEY CLUSTERED 
(
	[GiftCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[HistoricContribution]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoricContribution](
	[HistoricContributionID] [tinyint] IDENTITY(1,1) NOT NULL,
	[HistoricContributionDescription] [varchar](253) NULL,
	[HistoricContributionName] [varchar](50) NULL,
	[HistoricHistoricContributionID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_HistoricContribution] PRIMARY KEY CLUSTERED 
(
	[HistoricContributionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Hobby]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hobby](
	[HobbyID] [smallint] IDENTITY(1,1) NOT NULL,
	[HobbyDescription] [varchar](253) NULL,
	[HobbyName] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Hobby_CreatedDate]  DEFAULT (getdate()),
	[LeadExposure] [bit] NULL,
 CONSTRAINT [PK_Hobby] PRIMARY KEY CLUSTERED 
(
	[HobbyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HomeRemedy]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HomeRemedy](
	[HomeRemedyID] [int] IDENTITY(1,1) NOT NULL,
	[HomeRemedyName] [varchar](50) NOT NULL,
	[HomeRemedyDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_HomeRemedy_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_HomeRemedies] PRIMARY KEY CLUSTERED 
(
	[HomeRemedyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HouseholdSourcesofLead]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HouseholdSourcesofLead](
	[HouseholdSourcesofLeadID] [int] IDENTITY(1,1) NOT NULL,
	[HouseholdItemName] [varchar](50) NULL,
	[HouseholdItemDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_HouseholdSourcesofLead_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_HouseholdSourcesofLead] PRIMARY KEY CLUSTERED 
(
	[HouseholdSourcesofLeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InsuranceProvider]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InsuranceProvider](
	[InsuranceProviderID] [smallint] IDENTITY(1,1) NOT NULL,
	[InsuranceProviderName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_InsuranceProvider_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_InsuranceProvider] PRIMARY KEY CLUSTERED 
(
	[InsuranceProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lab]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lab](
	[LabID] [int] IDENTITY(1,1) NOT NULL,
	[LabName] [varchar](50) NULL,
	[LabDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Lab_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Lab] PRIMARY KEY CLUSTERED 
(
	[LabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LabNotes](
	[LabNotesID] [int] IDENTITY(1,1) NOT NULL,
	[LabID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_LabNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_LabNotes] PRIMARY KEY CLUSTERED 
(
	[LabNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Language]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Language](
	[LanguageID] [tinyint] IDENTITY(1,1) NOT NULL,
	[LanguageName] [varchar](50) NOT NULL,
	[HistoricPrimaryLanguageCode] [char](1) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Language_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LCCHPAttachments]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
--CREATE TABLE [dbo].[LCCHPAttachments] AS FILETABLE ON [UData] FILESTREAM_ON [LCCHPAttachments]
--WITH
--(
--FILETABLE_DIRECTORY = N'LCCHPAttachmentsDev', FILETABLE_COLLATE_FILENAME = SQL_Latin1_General_CP1_CI_AS
--)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Medium]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Medium](
	[MediumID] [int] IDENTITY(1,1) NOT NULL,
	[MediumName] [varchar](50) NOT NULL,
	[MediumDescription] [varchar](253) NULL,
	[TriggerLevel] [int] NULL,
	[TriggerLevelUnitsID] [int] NULL,
	[HistoricMediumCode] [char](1) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Medium_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Medium] PRIMARY KEY CLUSTERED 
(
	[MediumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MediumSampleResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MediumSampleResults](
	[MediumSampleResultsID] [int] IDENTITY(1,1) NOT NULL,
	[MediumID] [int] NOT NULL,
	[MediumSampleValue] [numeric](9, 4) NULL,
	[SampleLevelCategoryID] [tinyint] NULL,
	[MediumSampleDate] [date] NOT NULL CONSTRAINT [DF_MediumTestResults_MediumTestDate]  DEFAULT (getdate()),
	[LabID] [int] NULL,
	[LabSubmissionDate] [date] NULL,
	[IsAboveTriggerLevel] [bit] NULL,
	[UnitsID] [smallint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MediumSampleResults_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_MediumTestResults] PRIMARY KEY CLUSTERED 
(
	[MediumSampleResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[MediumSampleResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MediumSampleResultsNotes](
	[MediumSampleResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[MediumSampleResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MediumSampleResultsNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NULL,
 CONSTRAINT [PK_MediumSampleResultsNotes] PRIMARY KEY CLUSTERED 
(
	[MediumSampleResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Method]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Method](
	[MethodID] [tinyint] IDENTITY(1,1) NOT NULL,
	[MethodDescription] [varchar](253) NULL,
	[MethodName] [varchar](50) NULL,
	[HistoricMethodID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Method] PRIMARY KEY CLUSTERED 
(
	[MethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Occupation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Occupation](
	[OccupationID] [int] IDENTITY(1,1) NOT NULL,
	[OccupationName] [varchar](50) NOT NULL,
	[OccupationDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Occupation_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[LeadExposure] [bit] NULL,
 CONSTRAINT [PK_Occupation] PRIMARY KEY CLUSTERED 
(
	[OccupationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OccupationNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OccupationNotes](
	[OccupationNotesID] [int] IDENTITY(1,1) NOT NULL,
	[OccupationID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_OccupationNotes] PRIMARY KEY CLUSTERED 
(
	[OccupationNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonHobbyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonHobbyNotes](
	[PersonHobbyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonHobbyNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PersonHobbyNotes] PRIMARY KEY CLUSTERED 
(
	[PersonHobbyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonNotes](
	[PersonNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PersonNotes] PRIMARY KEY CLUSTERED 
(
	[PersonNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonReleaseNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonReleaseNotes](
	[PersonReleaseNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonReleaseNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PersonReleaseNotes] PRIMARY KEY CLUSTERED 
(
	[PersonReleaseNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonStatus](
	[PersonStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PersonStatusDescription] [varchar](253) NULL,
	[PersonStatusName] [varchar](50) NULL,
	[HistoricPersonStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersonStatus] PRIMARY KEY CLUSTERED 
(
	[PersonStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersontoAccessAgreement]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoAccessAgreement](
	[PersonID] [int] NOT NULL,
	[AccessAgreementID] [int] NOT NULL,
	[AccessAgreementDate] [date] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoAccessAgreement_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoAccessAgreement] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[AccessAgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoDaycare]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersontoDaycare](
	[PersonID] [int] NOT NULL,
	[DaycareID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_PersontoDaycare_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[DaycareNotes] [varchar](3000) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoDaycare_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoDaycare] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[DaycareID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersontoEmployer]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoEmployer](
	[PersonID] [int] NOT NULL,
	[EmployerID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_PersontoEmployer_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoEmployer_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoEmployer] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[EmployerID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoEthnicity]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoEthnicity](
	[PersonID] [int] NOT NULL,
	[EthnicityID] [tinyint] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoEthnicity_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoEthnicity_1] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[EthnicityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoFamily]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoFamily](
	[PersonID] [int] NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoFamily_CreatedDate]  DEFAULT (getdate()),
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PrimaryContactFamily] [bit] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [PK_PersontoFamily] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[FamilyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoForeignFood]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoForeignFood](
	[PersonID] [int] NOT NULL,
	[ForeignFoodID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoForeignFood_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoForeignFood] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[ForeignFoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoHobby]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoHobby](
	[PersonID] [int] NOT NULL,
	[HobbyID] [smallint] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoHobby_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoHobby] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[HobbyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoHomeRemedy]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoHomeRemedy](
	[PersonID] [int] NOT NULL,
	[HomeRemedyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoHomeRemedy_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoHomeRemedy] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[HomeRemedyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoInsurance]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersontoInsurance](
	[PersonID] [int] NOT NULL,
	[InsuranceID] [smallint] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[GroupID] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoInsurance_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoInsurance] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[InsuranceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersontoLanguage]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoLanguage](
	[PersonID] [int] NOT NULL,
	[LanguageID] [tinyint] NOT NULL,
	[isPrimaryLanguage] [bit] NOT NULL CONSTRAINT [DF_PersontoLanguage_isPrimaryLanguage]  DEFAULT ((1)),
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoLanguage_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoLanguage] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoOccupation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoOccupation](
	[PersonID] [int] NOT NULL,
	[OccupationID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_PersontoOccupation_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoOccupation_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoOccupation] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[OccupationID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoPerson]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoPerson](
	[Person1ID] [int] NOT NULL,
	[Person2ID] [int] NOT NULL,
	[RelationshipTypeID] [int] NOT NULL,
	[isGuardian] [bit] NULL,
	[isPrimaryContact] [bit] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoPerson_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_PersontoPerson_ModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoPerson] PRIMARY KEY CLUSTERED 
(
	[Person1ID] ASC,
	[Person2ID] ASC,
	[RelationshipTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoPhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoPhoneNumber](
	[PersonID] [int] NOT NULL,
	[PhoneNumberID] [int] NOT NULL,
	[NumberPriority] [tinyint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoPhoneNumber_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoPhoneNumber] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PhoneNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersontoProperty]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoProperty](
	[PersonID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_PersontoProperty_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[isPrimaryResidence] [bit] NULL,
	[FamilyID] [int] NULL,
	[PersontoPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersontoProperty_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersontoProperty] PRIMARY KEY CLUSTERED 
(
	[PersontoPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersonToTravelCountry]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonToTravelCountry](
	[PersonID] [int] NOT NULL,
	[CountryID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL CONSTRAINT [DF_PersonToTravelCountry_StartDate]  DEFAULT (getdate()),
	[EndDate] [date] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonToTravelCountry_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_PersonToTravelCountry] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[CountryID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PersonTravelNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonTravelNotes](
	[PersonTravelNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonTravelNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PersonTravelNotes] PRIMARY KEY CLUSTERED 
(
	[PersonTravelNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PhoneNumber]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhoneNumber](
	[PhoneNumberID] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [tinyint] NOT NULL CONSTRAINT [DF_PhoneNumber_CountryCode]  DEFAULT ((1)),
	[PhoneNumber] [bigint] NOT NULL,
	[PhoneNumberTypeID] [tinyint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PhoneNumber_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PhoneNumber] PRIMARY KEY CLUSTERED 
(
	[PhoneNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData],
 CONSTRAINT [IX_PhoneNumber] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PhoneNumberType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhoneNumberType](
	[PhoneNumberTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PhoneNumberTypeName] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PhoneNumberType_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[HistoricPhoneCode] [char](1) NULL,
 CONSTRAINT [PK_PhoneNumberType] PRIMARY KEY CLUSTERED 
(
	[PhoneNumberTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Property]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Property](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeID] [tinyint] NULL,
	[AreaID] [int] NULL,
	[isinHistoricDistrict] [bit] NULL,
	[isRemodeled] [bit] NULL,
	[RemodelDate] [date] NULL,
	[isinCityLimits] [bit] NULL,
	[StreetNumber] [varchar](15) NULL,
	[AddressLine1] [varchar](100) NULL,
	[StreetSuffix] [varchar](20) NULL,
	[AddressLine2] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[Zipcode] [varchar](12) NULL,
	[OwnerID] [int] NULL,
	[isOwnerOccuppied] [bit] NULL,
	[ReplacedPipesFaucets] [tinyint] NULL,
	[TotalRemediationCosts] [money] NULL,
	[isResidential] [bit] NULL,
	[isCurrentlyBeingRemodeled] [bit] NULL,
	[hasPeelingChippingPaint] [bit] NULL,
	[County] [varchar](50) NULL,
	[isRental] [bit] NULL,
	[HistoricPropertyID] [smallint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Property_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[YearBuilt] [date] NULL,
	[Street] [varchar](50) NULL,
	[ReviewStatusID] [tinyint] NULL,
	[AssessorsOfficeID] [varchar](50) NULL,
	[KidsFirstID] [int] NULL,
	[CleanUPStatusID] [tinyint] NULL,
	[OwnerContactInformation] [varchar](1000) NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertyLinkType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyLinkType](
	[PropertyLinkTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PropertyLinkTypeDescription] [varchar](253) NULL,
	[PropertyLinkTypeName] [varchar](50) NULL,
	[HistoricPropertyLinkTypeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertyLinkType] PRIMARY KEY CLUSTERED 
(
	[PropertyLinkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertyNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyNotes](
	[PropertyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertyNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PropertyNotes] PRIMARY KEY CLUSTERED 
(
	[PropertyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertySampleResults]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertySampleResults](
	[PropertySampleResultsID] [int] IDENTITY(1,1) NOT NULL,
	[isBaseline] [bit] NOT NULL CONSTRAINT [DF_PropertyTestResults_isBaseline]  DEFAULT ((0)),
	[PropertyID] [int] NOT NULL,
	[LabSubmissionDate] [date] NULL,
	[LabID] [int] NULL,
	[SampleTypeID] [tinyint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertySampleResults_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertySampletResults] PRIMARY KEY CLUSTERED 
(
	[PropertySampleResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PropertySampleResultsNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertySampleResultsNotes](
	[PropertySampleResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PropertySampleResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertySampleResultsNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PropertySampleResultsNotes] PRIMARY KEY CLUSTERED 
(
	[PropertySampleResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertytoCleanupStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoCleanupStatus](
	[PropertyID] [int] NOT NULL,
	[CleanupStatusID] [tinyint] NOT NULL,
	[CleanupStatusDate] [date] NOT NULL CONSTRAINT [DF_PropertytoCleanupStatus_CleanupStatusDate]  DEFAULT (getdate()),
	[CostofCleanup] [money] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertytoCleanupStatus_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoCleanupStatus] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[CleanupStatusID] ASC,
	[CleanupStatusDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PropertytoHouseholdSourcesofLead]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoHouseholdSourcesofLead](
	[PropertyID] [int] NOT NULL,
	[HouseholdSourcesofLeadID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoHouseholdSourcesofLead] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[HouseholdSourcesofLeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[PropertytoMedium]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertytoMedium](
	[PropertyID] [int] NOT NULL,
	[MediumID] [int] NOT NULL,
	[MediumTested] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PropertytoMedium_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_PropertytoMedium] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC,
	[MediumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
/****** Object:  Table [dbo].[QuestionnaireDataSource]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuestionnaireDataSource](
	[QuestionnaireDataSourceID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireDataSourceName] [varchar](50) NOT NULL,
	[QuestionnaireDataSourceDescription] [varchar](253) NULL,
 CONSTRAINT [PK_QuestionnaireDataSource] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireDataSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QuestionnaireNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuestionnaireNotes](
	[QuestionnaireNotesID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_QuestionnaireNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_QuestionnaireNotes] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RelationshipType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RelationshipType](
	[RelationshipTypeID] [int] IDENTITY(1,1) NOT NULL,
	[RelationshipTypeName] [varchar](50) NULL,
	[RelationshipTypeDescription] [varchar](253) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_RelationshipType_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_RelationshipType_ModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_RelationshipType] PRIMARY KEY CLUSTERED 
(
	[RelationshipTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReleaseStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseStatus](
	[ReleaseStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReleaseStatusDescription] [varchar](253) NULL,
	[ReleaseStatusName] [varchar](50) NULL,
	[HistoricReleaseStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ReleaseStatus] PRIMARY KEY CLUSTERED 
(
	[ReleaseStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Remediation]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Remediation](
	[RemediationID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationApprovalDate] [date] NULL,
	[RemediationStartDate] [date] NULL,
	[RemediationEndDate] [date] NULL,
	[PropertyID] [int] NULL,
	[AccessAgreementID] [int] NULL,
	[FinalRemediationReportFile] [varbinary](max) NULL,
	[FinalRemediationReportDate] [date] NULL,
	[RemediationCost] [money] NULL,
	[OneYearRemediationCompleteDate] [date] NULL,
	[OneYearRemediationComplete] [bit] NULL,
	[RemediationActionPlanID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Remediation_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Remediation] PRIMARY KEY CLUSTERED 
(
	[RemediationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RemediationActionPlan]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RemediationActionPlan](
	[RemediationActionPlanID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationActionPlanApprovalDate] [date] NULL,
	[HomeOwnerConsultationDate] [date] NULL,
	[ContractorCompletedInvestigationDate] [date] NULL,
	[RemediationActionPlanFinalReportSubmissionDate] [date] NULL,
	[RemediationActionPlanFile] [varbinary](max) NULL,
	[PropertyID] [int] NULL,
	[EnvironmentalInvestigationID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_RemediationActionPlan_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_RemediationActionPlan] PRIMARY KEY CLUSTERED 
(
	[RemediationActionPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RemediationNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RemediationNotes](
	[RemediationNotesID] [int] IDENTITY(1,1) NOT NULL,
	[RemediationID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_RemediationNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_RemediationNotes] PRIMARY KEY CLUSTERED 
(
	[RemediationNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReviewStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReviewStatus](
	[ReviewStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReviewStatusDescription] [varchar](253) NULL,
	[ReviewStatusName] [varchar](50) NULL,
	[HistoricReviewStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ReviewStatus] PRIMARY KEY CLUSTERED 
(
	[ReviewStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SampleLevelCategory]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SampleLevelCategory](
	[SampleLevelCategoryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SampleLevelCategoryName] [varchar](50) NULL,
	[SampleLevelCategoryDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_SampleLevelCategory_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SampleLevelCategory] PRIMARY KEY CLUSTERED 
(
	[SampleLevelCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SamplePurpose]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SamplePurpose](
	[SamplePurposeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SamplePurposeDescription] [varchar](253) NULL,
	[SamplePurposeName] [varchar](50) NULL,
	[HistoricSamplePurposeID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_SamplePurpose] PRIMARY KEY CLUSTERED 
(
	[SamplePurposeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SampleType]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SampleType](
	[SampleTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SampleTypeName] [varchar](50) NULL,
	[SampleTypeDescription] [varchar](253) NULL,
	[historicSampleType] [char](1) NULL,
	[SampleTarget] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_SampleType_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SampleType] PRIMARY KEY CLUSTERED 
(
	[SampleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Source]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Source](
	[SourceID] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [varchar](50) NOT NULL,
	[SourceDescription] [varchar](253) NULL,
 CONSTRAINT [PK_Source] PRIMARY KEY CLUSTERED 
(
	[SourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TargetStatus]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TargetStatus](
	[StatusID] [smallint] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](50) NULL,
	[StatusDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Status_CreatedDate]  DEFAULT (getdate()),
	[TargetType] [varchar](50) NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TravelNotes]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TravelNotes](
	[TravelNotesID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_TravelNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_TravelNotes] PRIMARY KEY CLUSTERED 
(
	[TravelNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Units]    Script Date: 7/24/2015 4:56:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Units](
	[UnitsID] [smallint] IDENTITY(1,1) NOT NULL,
	[Units] [varchar](20) NOT NULL,
	[UnitsDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Units_CreatedDate]  DEFAULT (getdate()),
	[HistoricUnitsCode] [char](1) NULL,
 CONSTRAINT [PK_Units] PRIMARY KEY CLUSTERED 
(
	[UnitsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IDX_BloodTestResultsSampleDateLeadValue]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE NONCLUSTERED INDEX [IDX_BloodTestResultsSampleDateLeadValue] ON [dbo].[BloodTestResults]
(
	[PersonID] ASC,
	[SampleDate] ASC,
	[LeadValue] ASC
)
INCLUDE ( 	[BloodTestResultsID],
	[ClientStatusID],
	[LabSubmissionDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [UData]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20141220-115023]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141220-115023] ON [dbo].[Person]
(
	[LastName] ASC,
	[RetestDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
GO
/****** Object:  Index [IDX_QuestionnaireDateIDPersonIDNursingMotherPregnant]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE NONCLUSTERED INDEX [IDX_QuestionnaireDateIDPersonIDNursingMotherPregnant] ON [dbo].[Questionnaire]
(
	[QuestionnaireDate] ASC
)
INCLUDE ( 	[QuestionnaireID],
	[PersonID],
	[NursingMother],
	[Pregnant]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
GO
/****** Object:  Index [NonClusteredIndex-PersonIDQuestionnaireDate]    Script Date: 7/24/2015 4:56:47 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-PersonIDQuestionnaireDate] ON [dbo].[Questionnaire]
(
	[PersonID] ASC,
	[QuestionnaireDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [UData]
GO
ALTER TABLE [dbo].[ActionStatus] ADD  CONSTRAINT [DF_ActionStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Condition] ADD  CONSTRAINT [DF_Condition_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ContactType] ADD  CONSTRAINT [DF_ContactType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[DataSource] ADD  CONSTRAINT [DF_DataSource_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Flag] ADD  CONSTRAINT [DF_Flag_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Frequency] ADD  CONSTRAINT [DF_Frequency_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[HistoricContribution] ADD  CONSTRAINT [DF_HistoricContribution_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Method] ADD  CONSTRAINT [DF_Method_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[OccupationNotes] ADD  CONSTRAINT [DF_OccupationNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersonStatus] ADD  CONSTRAINT [DF_PersonStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertyLinkType] ADD  CONSTRAINT [DF_PropertyLinkType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] ADD  CONSTRAINT [DF_PropertytoHouseholdSourcesofLead_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ReleaseStatus] ADD  CONSTRAINT [DF_ReleaseStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ReviewStatus] ADD  CONSTRAINT [DF_ReviewStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SamplePurpose] ADD  CONSTRAINT [DF_SamplePurpose_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreement_AccessPurpose] FOREIGN KEY([AccessPurposeID])
REFERENCES [dbo].[AccessPurpose] ([AccessPurposeID])
GO
ALTER TABLE [dbo].[AccessAgreement] CHECK CONSTRAINT [FK_AccessAgreement_AccessPurpose]
GO
ALTER TABLE [dbo].[AccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreement_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[AccessAgreement] CHECK CONSTRAINT [FK_AccessAgreement_Property]
GO
ALTER TABLE [dbo].[AccessAgreementNotes]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreementNotes_AccessAgreement] FOREIGN KEY([AccessAgreementID])
REFERENCES [dbo].[AccessAgreement] ([AccessAgreementID])
GO
ALTER TABLE [dbo].[AccessAgreementNotes] CHECK CONSTRAINT [FK_AccessAgreementNotes_AccessAgreement]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_HematocritLevelCategory] FOREIGN KEY([HematocritValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_HematocritLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_HemoglobinLevelCategory] FOREIGN KEY([HemoglobinValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_HemoglobinLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_Lab] FOREIGN KEY([LabID])
REFERENCES [dbo].[Lab] ([LabID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_Lab]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_LeadLevelCategory] FOREIGN KEY([LeadValueCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_LeadLevelCategory]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_Person]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResults_SampleType] FOREIGN KEY([SampleTypeID])
REFERENCES [dbo].[SampleType] ([SampleTypeID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_SampleType]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH NOCHECK ADD  CONSTRAINT [FK_BloodTestResults_TargetStatus] FOREIGN KEY([ClientStatusID])
REFERENCES [dbo].[TargetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [FK_BloodTestResults_TargetStatus]
GO
ALTER TABLE [dbo].[BloodTestResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_BloodTestResultsNotes_BloodTestResults] FOREIGN KEY([BloodTestResultsID])
REFERENCES [dbo].[BloodTestResults] ([BloodTestResultsID])
GO
ALTER TABLE [dbo].[BloodTestResultsNotes] CHECK CONSTRAINT [FK_BloodTestResultsNotes_BloodTestResults]
GO
ALTER TABLE [dbo].[ContractortoProperty]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoProperty_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoProperty] CHECK CONSTRAINT [FK_ContractortoProperty_Contractor]
GO
ALTER TABLE [dbo].[ContractortoProperty]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[ContractortoProperty] CHECK CONSTRAINT [FK_ContractortoProperty_Property]
GO
ALTER TABLE [dbo].[ContractortoRemediation]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediation_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediation] CHECK CONSTRAINT [FK_ContractortoRemediation_Contractor]
GO
ALTER TABLE [dbo].[ContractortoRemediation]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediation_Remediation] FOREIGN KEY([RemediationID])
REFERENCES [dbo].[Remediation] ([RemediationID])
GO
ALTER TABLE [dbo].[ContractortoRemediation] CHECK CONSTRAINT [FK_ContractortoRemediation_Remediation]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationActionPlan_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationActionPlan_Contractor]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationActionPlan_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationActionPlan_RemediationActionPlan]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationPlan_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationPlan_RemediationActionPlan]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoSamplingPlan_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoSamplingPlan_Contractor]
GO
ALTER TABLE [dbo].[DaycaretoProperty]  WITH CHECK ADD  CONSTRAINT [FK_DaycaretoProperty_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[DaycaretoProperty] CHECK CONSTRAINT [FK_DaycaretoProperty_Daycare]
GO
ALTER TABLE [dbo].[DaycaretoProperty]  WITH CHECK ADD  CONSTRAINT [FK_DaycaretoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[DaycaretoProperty] CHECK CONSTRAINT [FK_DaycaretoProperty_Property]
GO
ALTER TABLE [dbo].[EmployertoProperty]  WITH CHECK ADD  CONSTRAINT [FK_EmployertoProperty_Employer] FOREIGN KEY([EmployerID])
REFERENCES [dbo].[Employer] ([EmployerID])
GO
ALTER TABLE [dbo].[EmployertoProperty] CHECK CONSTRAINT [FK_EmployertoProperty_Employer]
GO
ALTER TABLE [dbo].[EmployertoProperty]  WITH CHECK ADD  CONSTRAINT [FK_EmployertoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[EmployertoProperty] CHECK CONSTRAINT [FK_EmployertoProperty_Property]
GO
ALTER TABLE [dbo].[EnvironmentalInvestigation]  WITH CHECK ADD  CONSTRAINT [FK_EnvironmentalInvestigation_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[EnvironmentalInvestigation] CHECK CONSTRAINT [FK_EnvironmentalInvestigation_Property]
GO
ALTER TABLE [dbo].[FamilyNotes]  WITH CHECK ADD  CONSTRAINT [FK_FamilyNotes_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilyNotes] CHECK CONSTRAINT [FK_FamilyNotes_Family]
GO
ALTER TABLE [dbo].[FamilytoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_FamilytoPhoneNumber_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilytoPhoneNumber] CHECK CONSTRAINT [FK_FamilytoPhoneNumber_Family]
GO
ALTER TABLE [dbo].[FamilytoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_FamilytoPhoneNumber_PhoneNumber] FOREIGN KEY([PhoneNumberID])
REFERENCES [dbo].[PhoneNumber] ([PhoneNumberID])
GO
ALTER TABLE [dbo].[FamilytoPhoneNumber] CHECK CONSTRAINT [FK_FamilytoPhoneNumber_PhoneNumber]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Family]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Property]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_PropertyLinkType] FOREIGN KEY([PropertyLinkTypeID])
REFERENCES [dbo].[PropertyLinkType] ([PropertyLinkTypeID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_PropertyLinkType]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_ReviewStatus]
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry]  WITH CHECK ADD  CONSTRAINT [FK_ForeignFoodtoCountry_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry] CHECK CONSTRAINT [FK_ForeignFoodtoCountry_Country]
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry]  WITH CHECK ADD  CONSTRAINT [FK_ForeignFoodtoCountry_ForeignFood] FOREIGN KEY([ForeignFoodID])
REFERENCES [dbo].[ForeignFood] ([ForeignFoodID])
GO
ALTER TABLE [dbo].[ForeignFoodtoCountry] CHECK CONSTRAINT [FK_ForeignFoodtoCountry_ForeignFood]
GO
ALTER TABLE [dbo].[GiftCard]  WITH CHECK ADD  CONSTRAINT [FK_GiftCard_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[GiftCard] CHECK CONSTRAINT [FK_GiftCard_Person]
GO
ALTER TABLE [dbo].[LabNotes]  WITH CHECK ADD  CONSTRAINT [FK_LabNotes_Lab] FOREIGN KEY([LabID])
REFERENCES [dbo].[Lab] ([LabID])
GO
ALTER TABLE [dbo].[LabNotes] CHECK CONSTRAINT [FK_LabNotes_Lab]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Lab] FOREIGN KEY([LabID])
REFERENCES [dbo].[Lab] ([LabID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Lab]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Medium] FOREIGN KEY([MediumID])
REFERENCES [dbo].[Medium] ([MediumID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Medium]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_SampleLevelCategory] FOREIGN KEY([SampleLevelCategoryID])
REFERENCES [dbo].[SampleLevelCategory] ([SampleLevelCategoryID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_SampleLevelCategory]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResults_Units] FOREIGN KEY([UnitsID])
REFERENCES [dbo].[Units] ([UnitsID])
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [FK_MediumSampleResults_Units]
GO
ALTER TABLE [dbo].[MediumSampleResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResultsNotes_MediumSampleResults] FOREIGN KEY([MediumSampleResultsID])
REFERENCES [dbo].[MediumSampleResults] ([MediumSampleResultsID])
GO
ALTER TABLE [dbo].[MediumSampleResultsNotes] CHECK CONSTRAINT [FK_MediumSampleResultsNotes_MediumSampleResults]
GO
ALTER TABLE [dbo].[OccupationNotes]  WITH CHECK ADD  CONSTRAINT [FK_OccupationNotes_Occupation] FOREIGN KEY([OccupationID])
REFERENCES [dbo].[Occupation] ([OccupationID])
GO
ALTER TABLE [dbo].[OccupationNotes] CHECK CONSTRAINT [FK_OccupationNotes_Occupation]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_ReviewStatus]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_TargetStatus] FOREIGN KEY([ClientStatusID])
REFERENCES [dbo].[TargetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_TargetStatus]
GO
ALTER TABLE [dbo].[PersonHobbyNotes]  WITH CHECK ADD  CONSTRAINT [FK_PersonHobbyNotes_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonHobbyNotes] CHECK CONSTRAINT [FK_PersonHobbyNotes_Person]
GO
ALTER TABLE [dbo].[PersonNotes]  WITH CHECK ADD  CONSTRAINT [FK_PersonNotes_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonNotes] CHECK CONSTRAINT [FK_PersonNotes_Person]
GO
ALTER TABLE [dbo].[PersonReleaseNotes]  WITH CHECK ADD  CONSTRAINT [FK_PersonReleaseNotes_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonReleaseNotes] CHECK CONSTRAINT [FK_PersonReleaseNotes_Person]
GO
ALTER TABLE [dbo].[PersontoAccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_PersontoAccessAgreement_AccessAgreement] FOREIGN KEY([AccessAgreementID])
REFERENCES [dbo].[AccessAgreement] ([AccessAgreementID])
GO
ALTER TABLE [dbo].[PersontoAccessAgreement] CHECK CONSTRAINT [FK_PersontoAccessAgreement_AccessAgreement]
GO
ALTER TABLE [dbo].[PersontoAccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_PersontoAccessAgreement_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoAccessAgreement] CHECK CONSTRAINT [FK_PersontoAccessAgreement_Person]
GO
ALTER TABLE [dbo].[PersontoDaycare]  WITH CHECK ADD  CONSTRAINT [FK_PersontoDaycare_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[PersontoDaycare] CHECK CONSTRAINT [FK_PersontoDaycare_Daycare]
GO
ALTER TABLE [dbo].[PersontoDaycare]  WITH CHECK ADD  CONSTRAINT [FK_PersontoDaycare_PersontoDaycare] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoDaycare] CHECK CONSTRAINT [FK_PersontoDaycare_PersontoDaycare]
GO
ALTER TABLE [dbo].[PersontoEmployer]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEmployer_Employer] FOREIGN KEY([EmployerID])
REFERENCES [dbo].[Employer] ([EmployerID])
GO
ALTER TABLE [dbo].[PersontoEmployer] CHECK CONSTRAINT [FK_PersontoEmployer_Employer]
GO
ALTER TABLE [dbo].[PersontoEmployer]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEmployer_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoEmployer] CHECK CONSTRAINT [FK_PersontoEmployer_Person]
GO
ALTER TABLE [dbo].[PersontoEthnicity]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEthnicity_Ethnicity] FOREIGN KEY([EthnicityID])
REFERENCES [dbo].[Ethnicity] ([EthnicityID])
GO
ALTER TABLE [dbo].[PersontoEthnicity] CHECK CONSTRAINT [FK_PersontoEthnicity_Ethnicity]
GO
ALTER TABLE [dbo].[PersontoEthnicity]  WITH CHECK ADD  CONSTRAINT [FK_PersontoEthnicity_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoEthnicity] CHECK CONSTRAINT [FK_PersontoEthnicity_Person]
GO
ALTER TABLE [dbo].[PersontoFamily]  WITH CHECK ADD  CONSTRAINT [FK_PersontoFamily_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[PersontoFamily] CHECK CONSTRAINT [FK_PersontoFamily_Family]
GO
ALTER TABLE [dbo].[PersontoFamily]  WITH CHECK ADD  CONSTRAINT [FK_PersontoFamily_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoFamily] CHECK CONSTRAINT [FK_PersontoFamily_Person]
GO
ALTER TABLE [dbo].[PersontoForeignFood]  WITH CHECK ADD  CONSTRAINT [FK_PersontoForeignFood_ForeignFood] FOREIGN KEY([ForeignFoodID])
REFERENCES [dbo].[ForeignFood] ([ForeignFoodID])
GO
ALTER TABLE [dbo].[PersontoForeignFood] CHECK CONSTRAINT [FK_PersontoForeignFood_ForeignFood]
GO
ALTER TABLE [dbo].[PersontoForeignFood]  WITH CHECK ADD  CONSTRAINT [FK_PersontoForeignFood_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoForeignFood] CHECK CONSTRAINT [FK_PersontoForeignFood_Person]
GO
ALTER TABLE [dbo].[PersontoHobby]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHobby_Hobby] FOREIGN KEY([HobbyID])
REFERENCES [dbo].[Hobby] ([HobbyID])
GO
ALTER TABLE [dbo].[PersontoHobby] CHECK CONSTRAINT [FK_PersontoHobby_Hobby]
GO
ALTER TABLE [dbo].[PersontoHobby]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHobby_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoHobby] CHECK CONSTRAINT [FK_PersontoHobby_Person]
GO
ALTER TABLE [dbo].[PersontoHomeRemedy]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHomeRemedy_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoHomeRemedy] CHECK CONSTRAINT [FK_PersontoHomeRemedy_Person]
GO
ALTER TABLE [dbo].[PersontoHomeRemedy]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHomeRemedy_PersontoHomeRemedy] FOREIGN KEY([HomeRemedyID])
REFERENCES [dbo].[HomeRemedy] ([HomeRemedyID])
GO
ALTER TABLE [dbo].[PersontoHomeRemedy] CHECK CONSTRAINT [FK_PersontoHomeRemedy_PersontoHomeRemedy]
GO
ALTER TABLE [dbo].[PersontoInsurance]  WITH CHECK ADD  CONSTRAINT [FK_PersontoInsurance_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoInsurance] CHECK CONSTRAINT [FK_PersontoInsurance_Person]
GO
ALTER TABLE [dbo].[PersontoInsurance]  WITH CHECK ADD  CONSTRAINT [FK_PersontoInsurance_PersontoInsurance] FOREIGN KEY([InsuranceID])
REFERENCES [dbo].[InsuranceProvider] ([InsuranceProviderID])
GO
ALTER TABLE [dbo].[PersontoInsurance] CHECK CONSTRAINT [FK_PersontoInsurance_PersontoInsurance]
GO
ALTER TABLE [dbo].[PersontoLanguage]  WITH CHECK ADD  CONSTRAINT [FK_PersontoLanguage_Language] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Language] ([LanguageID])
GO
ALTER TABLE [dbo].[PersontoLanguage] CHECK CONSTRAINT [FK_PersontoLanguage_Language]
GO
ALTER TABLE [dbo].[PersontoLanguage]  WITH CHECK ADD  CONSTRAINT [FK_PersontoLanguage_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoLanguage] CHECK CONSTRAINT [FK_PersontoLanguage_Person]
GO
ALTER TABLE [dbo].[PersontoOccupation]  WITH CHECK ADD  CONSTRAINT [FK_PersontoOccupation_Occupation] FOREIGN KEY([OccupationID])
REFERENCES [dbo].[Occupation] ([OccupationID])
GO
ALTER TABLE [dbo].[PersontoOccupation] CHECK CONSTRAINT [FK_PersontoOccupation_Occupation]
GO
ALTER TABLE [dbo].[PersontoOccupation]  WITH CHECK ADD  CONSTRAINT [FK_PersontoOccupation_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoOccupation] CHECK CONSTRAINT [FK_PersontoOccupation_Person]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPerson_Person1ID] FOREIGN KEY([Person1ID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_Person1ID]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPerson_Person2ID] FOREIGN KEY([Person2ID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_Person2ID]
GO
ALTER TABLE [dbo].[PersontoPerson]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPerson_RelationshipType] FOREIGN KEY([RelationshipTypeID])
REFERENCES [dbo].[RelationshipType] ([RelationshipTypeID])
GO
ALTER TABLE [dbo].[PersontoPerson] CHECK CONSTRAINT [FK_PersontoPerson_RelationshipType]
GO
ALTER TABLE [dbo].[PersontoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPhoneNumber_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoPhoneNumber] CHECK CONSTRAINT [FK_PersontoPhoneNumber_Person]
GO
ALTER TABLE [dbo].[PersontoPhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_PersontoPhoneNumber_PhoneNumber] FOREIGN KEY([PhoneNumberID])
REFERENCES [dbo].[PhoneNumber] ([PhoneNumberID])
GO
ALTER TABLE [dbo].[PersontoPhoneNumber] CHECK CONSTRAINT [FK_PersontoPhoneNumber_PhoneNumber]
GO
ALTER TABLE [dbo].[PersontoProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersontoProperty_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoProperty] CHECK CONSTRAINT [FK_PersontoProperty_Person]
GO
ALTER TABLE [dbo].[PersontoProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersontoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PersontoProperty] CHECK CONSTRAINT [FK_PersontoProperty_Property]
GO
ALTER TABLE [dbo].[PersonToTravelCountry]  WITH CHECK ADD  CONSTRAINT [FK_PersonToTravelCountry_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[PersonToTravelCountry] CHECK CONSTRAINT [FK_PersonToTravelCountry_Country]
GO
ALTER TABLE [dbo].[PersonToTravelCountry]  WITH CHECK ADD  CONSTRAINT [FK_PersonToTravelCountry_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonToTravelCountry] CHECK CONSTRAINT [FK_PersonToTravelCountry_Person]
GO
ALTER TABLE [dbo].[PersonTravelNotes]  WITH CHECK ADD  CONSTRAINT [FK_PersonTravelNotes_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonTravelNotes] CHECK CONSTRAINT [FK_PersonTravelNotes_Person]
GO
ALTER TABLE [dbo].[PhoneNumber]  WITH CHECK ADD  CONSTRAINT [FK_PhoneNumber_PhoneNumber] FOREIGN KEY([PhoneNumberTypeID])
REFERENCES [dbo].[PhoneNumberType] ([PhoneNumberTypeID])
GO
ALTER TABLE [dbo].[PhoneNumber] CHECK CONSTRAINT [FK_PhoneNumber_PhoneNumber]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Area] FOREIGN KEY([AreaID])
REFERENCES [dbo].[Area] ([AreaID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Area]
GO
ALTER TABLE [dbo].[Property]  WITH NOCHECK ADD  CONSTRAINT [FK_Property_CleanupStatus] FOREIGN KEY([CleanUPStatusID])
REFERENCES [dbo].[CleanupStatus] ([CleanupStatusID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_CleanupStatus]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_ConstructionType] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionType] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_ConstructionType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Person] FOREIGN KEY([OwnerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Person]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_ReleaseStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReleaseStatus] ([ReleaseStatusID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_ReleaseStatus]
GO
ALTER TABLE [dbo].[PropertyNotes]  WITH CHECK ADD  CONSTRAINT [FK_PropertyNotes_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertyNotes] CHECK CONSTRAINT [FK_PropertyNotes_Property]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampleResults_SampleType] FOREIGN KEY([SampleTypeID])
REFERENCES [dbo].[SampleType] ([SampleTypeID])
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [FK_PropertySampleResults_SampleType]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampletResults_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [FK_PropertySampletResults_Property]
GO
ALTER TABLE [dbo].[PropertySampleResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampleResultsNotes_PropertySampleResults] FOREIGN KEY([PropertySampleResultsID])
REFERENCES [dbo].[PropertySampleResults] ([PropertySampleResultsID])
GO
ALTER TABLE [dbo].[PropertySampleResultsNotes] CHECK CONSTRAINT [FK_PropertySampleResultsNotes_PropertySampleResults]
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoCleanupStatus_CleanupStatus] FOREIGN KEY([CleanupStatusID])
REFERENCES [dbo].[CleanupStatus] ([CleanupStatusID])
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] CHECK CONSTRAINT [FK_PropertytoCleanupStatus_CleanupStatus]
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoCleanupStatus_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] CHECK CONSTRAINT [FK_PropertytoCleanupStatus_Property]
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead]  WITH CHECK ADD  CONSTRAINT [FK_HouseholdSourcesofLead_PropertytoHouseholdSourcesofLead] FOREIGN KEY([HouseholdSourcesofLeadID])
REFERENCES [dbo].[HouseholdSourcesofLead] ([HouseholdSourcesofLeadID])
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] CHECK CONSTRAINT [FK_HouseholdSourcesofLead_PropertytoHouseholdSourcesofLead]
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead]  WITH CHECK ADD  CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] CHECK CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead]
GO
ALTER TABLE [dbo].[PropertytoMedium]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoMedium_Medium] FOREIGN KEY([MediumID])
REFERENCES [dbo].[Medium] ([MediumID])
GO
ALTER TABLE [dbo].[PropertytoMedium] CHECK CONSTRAINT [FK_PropertytoMedium_Medium]
GO
ALTER TABLE [dbo].[PropertytoMedium]  WITH CHECK ADD  CONSTRAINT [FK_PropertytoMedium_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertytoMedium] CHECK CONSTRAINT [FK_PropertytoMedium_Property]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_Daycare] FOREIGN KEY([DaycareID])
REFERENCES [dbo].[Daycare] ([DaycareID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_Daycare]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_Person]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [FK_Questionnaire_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [FK_Questionnaire_ReviewStatus]
GO
ALTER TABLE [dbo].[QuestionnaireNotes]  WITH NOCHECK ADD  CONSTRAINT [FK_QuestionnaireNotes_Questionnaire] FOREIGN KEY([QuestionnaireID])
REFERENCES [dbo].[Questionnaire] ([QuestionnaireID])
GO
ALTER TABLE [dbo].[QuestionnaireNotes] CHECK CONSTRAINT [FK_QuestionnaireNotes_Questionnaire]
GO
ALTER TABLE [dbo].[Remediation]  WITH CHECK ADD  CONSTRAINT [FK_Remediation_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [FK_Remediation_Property]
GO
ALTER TABLE [dbo].[Remediation]  WITH CHECK ADD  CONSTRAINT [FK_Remediation_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [FK_Remediation_RemediationActionPlan]
GO
ALTER TABLE [dbo].[RemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_RemediationActionPlan_EnvironmentalInvestigation] FOREIGN KEY([EnvironmentalInvestigationID])
REFERENCES [dbo].[EnvironmentalInvestigation] ([EnvironmentalInvestigationID])
GO
ALTER TABLE [dbo].[RemediationActionPlan] CHECK CONSTRAINT [FK_RemediationActionPlan_EnvironmentalInvestigation]
GO
ALTER TABLE [dbo].[RemediationNotes]  WITH CHECK ADD  CONSTRAINT [FK_RemediationNotes_Remediation] FOREIGN KEY([RemediationID])
REFERENCES [dbo].[Remediation] ([RemediationID])
GO
ALTER TABLE [dbo].[RemediationNotes] CHECK CONSTRAINT [FK_RemediationNotes_Remediation]
GO
ALTER TABLE [dbo].[TravelNotes]  WITH CHECK ADD  CONSTRAINT [FK_TravelNotes_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[TravelNotes] CHECK CONSTRAINT [FK_TravelNotes_Family]
GO
ALTER TABLE [dbo].[BloodTestResults]  WITH CHECK ADD  CONSTRAINT [ck_BloodTestResults_SampleDate] CHECK  (([dbo].[udf_DateInThePast]([SampleDate])=(1)))
GO
ALTER TABLE [dbo].[BloodTestResults] CHECK CONSTRAINT [ck_BloodTestResults_SampleDate]
GO
ALTER TABLE [dbo].[MediumSampleResults]  WITH CHECK ADD  CONSTRAINT [ck_MediumSampleResults_MediumSampleDate] CHECK  (([dbo].[udf_DateInThePast]([MediumSampleDate])=(1)))
GO
ALTER TABLE [dbo].[MediumSampleResults] CHECK CONSTRAINT [ck_MediumSampleResults_MediumSampleDate]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_BirthDate] CHECK  (([dbo].[udf_DateInThePast]([BirthDate])=(1)))
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_BirthDate]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_MovedDate] CHECK  (([dbo].[udf_DateInThePast]([MovedDate])=(1) OR [MovedDate] IS NULL))
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_MovedDate]
GO
ALTER TABLE [dbo].[PropertySampleResults]  WITH CHECK ADD  CONSTRAINT [ck_PropertySampleResults_LabSubmissionDate] CHECK  (([dbo].[udf_DateInThePast]([LabSubmissionDate])=(1)))
GO
ALTER TABLE [dbo].[PropertySampleResults] CHECK CONSTRAINT [ck_PropertySampleResults_LabSubmissionDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_PaintDate] CHECK  (([dbo].[udf_DateInThePast]([PaintDate])=(1) OR [PaintDate] IS NULL))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_PaintDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_QuestionnaireDate] CHECK  (([dbo].[udf_DateInThePast]([QuestionnaireDate])=(1)))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_QuestionnaireDate]
GO
ALTER TABLE [dbo].[Questionnaire]  WITH NOCHECK ADD  CONSTRAINT [ck_Questionnaire_RemodelPropertyDate] CHECK  (([dbo].[udf_DateInThePast]([RemodelPropertyDate])=(1) OR [RemodelPropertyDate] IS NULL))
GO
ALTER TABLE [dbo].[Questionnaire] CHECK CONSTRAINT [ck_Questionnaire_RemodelPropertyDate]
GO
ALTER TABLE [dbo].[Remediation]  WITH CHECK ADD  CONSTRAINT [ck_Remediation_RemediationApprovalDate] CHECK  (([dbo].[udf_DateInThePast]([RemediationApprovalDate])=(1)))
GO
ALTER TABLE [dbo].[Remediation] CHECK CONSTRAINT [ck_Remediation_RemediationApprovalDate]
GO
ALTER TABLE [dbo].[RemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [ck_RemediationActionPlan_RemediationActionPlanApprovalDate] CHECK  (([dbo].[udf_DateInThePast]([RemediationActionPlanApprovalDate])=(1)))
GO
ALTER TABLE [dbo].[RemediationActionPlan] CHECK CONSTRAINT [ck_RemediationActionPlan_RemediationActionPlanApprovalDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreement', @level2type=N'COLUMN',@level2name=N'AccessPurposeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of access agreements' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreement'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreementNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreementNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly name for the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose', @level2type=N'COLUMN',@level2name=N'AccessPurposeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'a description of the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose', @level2type=N'COLUMN',@level2name=N'AccessPurposeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of purposes for access requests/agreements' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessPurpose'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Action status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ActionStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ActionStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'HistoricActionStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area', @level2type=N'COLUMN',@level2name=N'AreaID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly description/name of the area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area', @level2type=N'COLUMN',@level2name=N'AreaDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of areas and basic information' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Area'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the blood test results object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'BloodTestResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'isBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was taken' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'SampleDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated lead value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LeadValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated hemoglobin value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HemoglobinValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the associated hematocrit value categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HematocritValueCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the samples were submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the blood tests' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'BloodTestCosts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the type of sample; i.e. venus, capo, soil, water, nitton analyzer . . . ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - No, 1 - yes; was the blood sample taken after property remediation was completed.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'TakenAfterPropertyRemediationCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historic bloodpbresults id from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HistoricBloodTestResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic lab results id from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults', @level2type=N'COLUMN',@level2name=N'HistoricLabResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of blood test result values and categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BloodTestResultsNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the cleanup status object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of clean up status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Action status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition', @level2type=N'COLUMN',@level2name=N'ConditionDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition', @level2type=N'COLUMN',@level2name=N'ConditionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition', @level2type=N'COLUMN',@level2name=N'HistoricConditionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Condition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the construction type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType', @level2type=N'COLUMN',@level2name=N'ConstructionTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of the construction type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType', @level2type=N'COLUMN',@level2name=N'ConstructionTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of construction types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConstructionType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Action status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ContactTypeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ContactTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'HistoricContactTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of contact types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContactType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor started occuping the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date contractor ended property occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractor and occupied properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'building which the contractor occupies for purpose of business (contractor offices)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoProperty', @level2type=N'CONSTRAINT',@level2name=N'FK_ContractortoProperty_Contractor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor started working on the remidiation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the contractor stopped working on the remediation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - no, 1 - yes.  is this contractor a sub contractor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation', @level2type=N'COLUMN',@level2name=N'isSubContractor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractors and remediations' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractor and sampling plan' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediationActionPlan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Country', @level2type=N'COLUMN',@level2name=N'CountryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Country', @level2type=N'COLUMN',@level2name=N'CountryName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of countries' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Country'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'DataSourceDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'DataSourceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic data source ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'HistoricDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of contact types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare', @level2type=N'COLUMN',@level2name=N'DaycareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the daycare business' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare', @level2type=N'COLUMN',@level2name=N'DaycareDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of daycare facilities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'priority of this person in the contact list (1 being highest priority)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact', @level2type=N'COLUMN',@level2name=N'ContactPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the primary contact number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact', @level2type=N'COLUMN',@level2name=N'PrimaryPhoneNumberID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for daycare and person - identifying contact person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the daycare started occupying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the daycare stopped occupying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for daycare and property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycaretoProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Employer', @level2type=N'COLUMN',@level2name=N'EmployerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Employer', @level2type=N'COLUMN',@level2name=N'EmployerName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of employers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Employer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the employer started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the employer stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for employer and property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmployertoProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - no, 1 - yes; is an environmental investigation going to be conducted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'ConductEnvironmentalInvestigation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the workgroup decided whether to conduct an environmental investigation or not' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'ConductEnvironmentalInvestigationDecisionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the environmental investigation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'Cost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of ethnicities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity', @level2type=N'COLUMN',@level2name=N'EthnicityID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly shortname of ethnicity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity', @level2type=N'COLUMN',@level2name=N'Ethnicity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of ethnicities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the family object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'family name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'Lastname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'number of smokers in the family' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'NumberofSmokers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the families primary language; default = 1 (English)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'PrimaryLanguageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'does the family travel to foreign countries' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'ForeignTravel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Review status id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family', @level2type=N'COLUMN',@level2name=N'ReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of families' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Family'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for Family notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilyNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'order which this number should be used to contact the Family (1 being first, 2 being 2nd . . . )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoPhoneNumber', @level2type=N'COLUMN',@level2name=N'NumberPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for Family and phonenumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoPhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary family id mainly from legacy system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the Family started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the Family stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for Family and property - indicating when a Family occuppied a property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilytoProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the flag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag', @level2type=N'COLUMN',@level2name=N'FlagDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the flag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag', @level2type=N'COLUMN',@level2name=N'FlagName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic flg ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag', @level2type=N'COLUMN',@level2name=N'HistoricFlagID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of flag information' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of various foreign foods' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ForeignFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'foreign food and country linking table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ForeignFoodtoCountry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the frequency type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency', @level2type=N'COLUMN',@level2name=N'FrequencyDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the frequency type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency', @level2type=N'COLUMN',@level2name=N'FrequencyName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic frequency ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency', @level2type=N'COLUMN',@level2name=N'HistoricFrequencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of frequencies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Frequency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the gift certificate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard', @level2type=N'COLUMN',@level2name=N'GiftCardID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'value of the gift certificate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard', @level2type=N'COLUMN',@level2name=N'GiftCardValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of gift certificate objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GiftCard'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the historic contribution' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution', @level2type=N'COLUMN',@level2name=N'HistoricContributionDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the historic contribution name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution', @level2type=N'COLUMN',@level2name=N'HistoricContributionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic historic contribution ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution', @level2type=N'COLUMN',@level2name=N'HistoricHistoricContributionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of historic contribution classifications' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HistoricContribution'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of hobby objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby', @level2type=N'COLUMN',@level2name=N'HobbyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the hobby' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby', @level2type=N'COLUMN',@level2name=N'HobbyDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of hobbies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hobby'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of home remedies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HomeRemedy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'household items that may contribute to EBL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HouseholdSourcesofLead'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for insurance company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider', @level2type=N'COLUMN',@level2name=N'InsuranceProviderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the insurance company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider', @level2type=N'COLUMN',@level2name=N'InsuranceProviderName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of insurance companies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuranceProvider'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the lab object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lab', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of lab names and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LabNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LabNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of langauge object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LanguageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'spoken language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LanguageName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of spoken languages' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'mediumcode identifier from legacy database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'HistoricMediumCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of mediums that are tested' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'tested medium id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'value of the test result for the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumSampleValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'sample level category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the medium was tested' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'MediumSampleDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the sample was submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the sample was submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of test results for various medums' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResultsNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the method' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'MethodDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the method' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'MethodName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic method ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'HistoricMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of method classifications' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Method'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'OccupationDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of occupation objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OccupationNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for Occupation notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OccupationNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for each person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s first name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'FirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s middle name or initial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MiddleName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s last name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'LastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s date of birth' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'BirthDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s gender (i.e. male or femal)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person travel to foreign countries' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'ForeignTravel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; is the person living out of the lead study area.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'OutofSite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person eat foreign candy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'EatsForeignFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ChildID from the access db system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'HistoricChildID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date for the next scheduled test' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'RetestDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; has the person moved outside the lead study area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Moved'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person moved outside of the study area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MovedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; is the person''s lead study closed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isClosed'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; has the lead issue been resolved' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isResolved'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'personID of the person''s guardian' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'GuardianID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; does the person smoke' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isSmoker'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was last modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Calculated age of the person in years' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Age'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a participant in the lead study program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'isClient'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a nursing mother' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'NursingMother'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person pregnant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Pregnant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Person''s email address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'EmailAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No; 1 = Yes; Is the person a nursing infant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'NursingInfant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of people and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonHobbyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for person hobby notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonHobbyNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for person notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonReleaseNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for person release notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonReleaseNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the person status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'HistoricPersonStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the access agreement was signed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoAccessAgreement', @level2type=N'COLUMN',@level2name=N'AccessAgreementDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and access agreement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoAccessAgreement'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started attending the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped attending the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and daycare for people attending daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoDaycare'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started working for the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped working for the employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and employer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEmployer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and ethnicity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoEthnicity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the corresponding person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the corresponding family' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and family tables' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoFamily'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and foreign food (many to many)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoForeignFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and hobby' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoHobby'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for perosn and home remedy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoHomeRemedy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person started the insurance policy with the provider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the person stopped the insurance policy with the provider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'insurance company and policy group id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance', @level2type=N'COLUMN',@level2name=N'GroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and insurance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoInsurance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes; is this language the person''s primary language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoLanguage', @level2type=N'COLUMN',@level2name=N'isPrimaryLanguage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoLanguage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person ceased the occupation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and occupatoin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoOccupation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'relationshipType is how P1 relates to P2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'RelationshipTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'isGuardian is 1 if P1 is P2''s guardian' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'isGuardian'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'isPrimaryContact is 1 if P1 is P2''s primaryContact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'COLUMN',@level2name=N'isPrimaryContact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of relationships between people' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1st person in the relationship' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'CONSTRAINT',@level2name=N'FK_PersontoPerson_Person1ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'2nd person in the relationship' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'CONSTRAINT',@level2name=N'FK_PersontoPerson_Person2ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'how is person1 related to person2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPerson', @level2type=N'CONSTRAINT',@level2name=N'FK_PersontoPerson_RelationshipType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'order which this number should be used to contact the person (1 being first, 2 being 2nd . . . )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPhoneNumber', @level2type=N'COLUMN',@level2name=N'NumberPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and phonenumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoPhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person started occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person stopped occuppying the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary family id mainly from legacy system' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty', @level2type=N'COLUMN',@level2name=N'FamilyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and property - indicating when a person occuppied a property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person entered the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the person left the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and country traveled too' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonToTravelCountry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonTravelNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for person Travel notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonTravelNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'code for the country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PhoneNumber', @level2type=N'COLUMN',@level2name=N'CountryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'telephone number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PhoneNumber', @level2type=N'COLUMN',@level2name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of phone number objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the property object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification number from Assessor''s office' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'AssessorsOfficeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kids First identification number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'KidsFirstID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cleanup status id for the current property cleanup state' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'CleanUPStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'basic contact information for the property owner' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'OwnerContactInformation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of properties and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the property link type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'PropertyLinkTypeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the property link type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'PropertyLinkTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic flg ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'HistoricPropertyLinkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of property link types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyLinkType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for property test results' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'PropertySampleResultsID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is this a baseline test result for the property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'isBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the property to which the test results apply' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the proeprty test samples were submitted to the lab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'LabSubmissionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the lab to which the property samples were submitted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'LabID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of property test results' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResultsNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date of the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the cleanup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus', @level2type=N'COLUMN',@level2name=N'CostofCleanup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoCleanupStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and household sources of lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoHouseholdSourcesofLead'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - yes; 1 - no.  Has the medium been tested.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoMedium', @level2type=N'COLUMN',@level2name=N'MediumTested'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for property and media' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertytoMedium'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the questionnaire object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the patient the questionnaire is referring to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the questionnaire was completed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the person completing the questionnaire' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient frequently visited remodeled properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'VisitRemodeledProperty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  has the patient been exposed to peeling paint' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isExposedtoPeelingPaint'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  Is the patient taking vitamins regularly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isTakingVitamins'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient a mother nursing a child' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NursingMother'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient using a pacifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingPacifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient using a bottle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'isUsingBottle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient bite nails' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'BitesNails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient consume non food products' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodEating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient put non food items in mouth?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NonFoodinMouth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient eat outside?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'EatOutside'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient suck his/her thumb or suckle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Suckling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient frequently wash hands througout the day' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'FrequentHandWashing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the daycare the patient attends' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'DaycareID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was last modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Review Status ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'ReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the client mouth things frequently' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Mouthing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  does the patient visit older homes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'VisitsOldHomes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient a nursing infant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'NursingInfant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = no; 1 = yes.  is the patient pregnant' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire', @level2type=N'COLUMN',@level2name=N'Pregnant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of questionnaire questions and answers, typically only completed by flagged patients' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questionnaire'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the questionnaire data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source of the questionnaire data - enviornmental or blood lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'More details about the source of the questionnaire data - enviornmental or blood lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'source of the data (Environmental group or Blood Lead)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the RelationshipType object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RelationshipType', @level2type=N'COLUMN',@level2name=N'RelationshipTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of RelationshipType names and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RelationshipType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Release status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ReleaseStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the Release status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ReleaseStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic ReleaseStatus ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'HistoricReleaseStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of Release Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of remediation data' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Remediation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Meeting date between homeowner and workgroup to review the sampling plan' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationActionPlan', @level2type=N'COLUMN',@level2name=N'HomeOwnerConsultationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sampling plans' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationActionPlan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for remediation notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RemediationNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Review status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ReviewStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'status for the Review' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ReviewStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic status from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'HistoricReviewStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of potential status for Review' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReviewStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for sample level categorization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of sample level category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory', @level2type=N'COLUMN',@level2name=N'SampleLevelCategoryName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sample level categorizations' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleLevelCategory'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the sample purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose', @level2type=N'COLUMN',@level2name=N'SamplePurposeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the sample purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose', @level2type=N'COLUMN',@level2name=N'SamplePurposeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic SamplePurpose ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose', @level2type=N'COLUMN',@level2name=N'HistoricSamplePurposeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of sample purposes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SamplePurpose'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly name for the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'extended description of the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sample types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of status objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TargetStatus', @level2type=N'COLUMN',@level2name=N'StatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly name/description of status object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TargetStatus', @level2type=N'COLUMN',@level2name=N'StatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of status objects' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TargetStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TravelNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of family and travel notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TravelNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -75
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Q1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 138
               Left = 263
               Bottom = 268
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 25
         End
         Begin Table = "Q2"
            Begin Extent = 
               Top = 6
               Left = 310
               Bottom = 119
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1035
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vAdults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vAdults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -75
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Q1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 138
               Left = 263
               Bottom = 268
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 25
         End
         Begin Table = "Q2"
            Begin Extent = 
               Top = 6
               Left = 310
               Bottom = 119
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1035
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vNursingInfants'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vNursingInfants'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -75
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Q1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 138
               Left = 263
               Bottom = 268
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 25
         End
         Begin Table = "Q2"
            Begin Extent = 
               Top = 6
               Left = 310
               Bottom = 119
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1035
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vNursingMothers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vNursingMothers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -75
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Q1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 138
               Left = 263
               Bottom = 268
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 25
         End
         Begin Table = "Q2"
            Begin Extent = 
               Top = 6
               Left = 310
               Bottom = 119
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1035
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPregnant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPregnant'
GO
USE [master]
GO
ALTER DATABASE [LCCHPPublic] SET  READ_WRITE 
GO
