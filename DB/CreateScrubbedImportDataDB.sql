use master
Go


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
	        @Default_Log_Path VARCHAR(512),
			@CREATEDBSQL VARCHAR(4096);
	
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
	
	/****** Object:  Database [DBATools]    Script Date: 2/1/2013 9:22:09 AM ******/
	set @CREATEDBSQL = 'CREATE DATABASE [TESTAccessImport] ON  PRIMARY 
	 
	( NAME = N''TESTAccessImport'', FILENAME = N''' + @Default_Data_Path + 'TESTAccessImport.mdf'' , SIZE = 262144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 524288KB ), 
	FILEGROUP [UData] DEFAULT
	( NAME = N''TESTAccessImport_UData'', FILENAME = N''' + @Default_Data_Path + 'TESTAccessImport_UData.mdf'' ,  SIZE = 2097152KB , MAXSIZE = UNLIMITED, FILEGROWTH = 524288KB )
	 LOG ON 
	( NAME = N''TESTAccessImport_log'', FILENAME = N''' + @Default_Log_Path + 'TESTAccessImport_log.ldf'' , SIZE = 4000000KB , MAXSIZE = 2048GB , FILEGROWTH = 262144KB )
	'
	
	exec (@CREATEDBSQL);
	USE [master]
	GO

ALTER DATABASE [TESTAccessImport-Scrubbed] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TESTAccessImport-Scrubbed].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ARITHABORT OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET RECOVERY FULL 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET  MULTI_USER 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TESTAccessImport-Scrubbed]
GO
/****** Object:  Table [dbo].[activityLog]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[activityLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](20) NULL,
	[ActivityDate] [datetime2](7) NULL,
	[SelectedSite] [nvarchar](50) NULL,
	[ActivityDescription] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BloodPbResults]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BloodPbResults](
	[ChildID] [int] NULL,
	[SampleDate] [datetime2](7) NULL,
	[AnalysisID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[Area] [nvarchar](2) NULL,
	[LabDate] [datetime2](7) NULL,
	[LeadValue] [float] NULL,
	[FlagCode] [nvarchar](1) NULL,
	[ValueCategory] [smallint] NULL,
	[SampleType] [nvarchar](1) NULL,
	[Hematocrit] [real] NULL,
	[LabName] [nvarchar](25) NULL,
	[LabID] [nvarchar](10) NULL,
	[Baseline] [bit] NULL,
	[ChildStatusCode] [nvarchar](1) NULL,
	[MouthingIndex] [tinyint] NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[ExcludeResult] [bit] NULL,
	[UpdateDate] [datetime2](7) NULL,
	[Cost] [money] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChildFamilyLink]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChildFamilyLink](
	[ChildID] [int] NULL,
	[FamilyID] [int] NULL,
	[PrimaryLink] [bit] NULL,
	[CFLinkStartDate] [datetime2](7) NULL,
	[CFLinkEndDate] [datetime2](7) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Children]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Children](
	[ChildID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](20) NULL,
	[FirstName] [nvarchar](15) NULL,
	[BirthDate] [datetime2](7) NULL,
	[Sex] [nvarchar](1) NULL,
	[SavingsBonds] [tinyint] NULL,
	[EthnicCode] [nvarchar](1) NULL,
	[ChildNotes] [ntext] NULL,
	[ReleaseCode] [nvarchar](1) NULL,
	[ReleaseNotes] [nvarchar](50) NULL,
	[OutOfSite] [bit] NULL,
	[Moved] [bit] NULL,
	[ForeignTravel] [bit] NULL,
	[TravelNotes] [nvarchar](255) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CleanupStatus]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CleanupStatus](
	[CleanupStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[MediumCode] [nvarchar](1) NULL,
	[StartDate] [datetime2](7) NULL,
	[CompDate] [datetime2](7) NULL,
	[Clearance] [bit] NULL,
	[Description] [nvarchar](100) NULL,
	[ActionStatusCode] [nvarchar](1) NULL,
	[ActionStatusDate] [datetime2](7) NULL,
	[UpdateDate] [datetime2](7) NULL,
	[Cost] [money] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConfidentialNotes]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfidentialNotes](
	[ChildID] [int] NULL,
	[ChildNotes] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Control]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Control](
	[ChildID] [smallint] NULL,
	[Name] [nvarchar](30) NULL,
	[FamilyID] [int] NULL,
	[PropertyID] [int] NULL,
	[WhereToGo] [nvarchar](10) NULL,
	[ID] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EnvirPbResults]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnvirPbResults](
	[AnalysisID] [int] IDENTITY(1,1) NOT NULL,
	[SampleID] [int] NULL,
	[Value] [float] NULL,
	[DetLim] [float] NULL,
	[MethodCode] [nvarchar](1) NULL,
	[UnitsCode] [nvarchar](1) NULL,
	[FlagCode] [nvarchar](4) NULL,
	[DataSourceCode] [nvarchar](1) NULL,
	[Comments] [nvarchar](50) NULL,
	[Validated] [bit] NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExportControl]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportControl](
	[DataType] [nvarchar](20) NULL,
	[LastExport] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Families]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Families](
	[FamilyID] [int] IDENTITY(1,1) NOT NULL,
	[P1FirstName] [nvarchar](50) NULL,
	[P1LastName] [nvarchar](50) NULL,
	[P2FirstName] [nvarchar](50) NULL,
	[P2LastName] [nvarchar](50) NULL,
	[OFirstName] [nvarchar](50) NULL,
	[OLastName] [nvarchar](50) NULL,
	[P1SameName] [bit] NULL,
	[PrimLanguageCode] [nvarchar](1) NULL,
	[Hobby] [bit] NULL,
	[HobbyNotes] [nvarchar](255) NULL,
	[Occupation] [bit] NULL,
	[OccupNotes] [nvarchar](255) NULL,
	[HomePhone] [nvarchar](12) NULL,
	[WorkPhone] [nvarchar](12) NULL,
	[PhoneCode] [nvarchar](1) NULL,
	[OtherNotes] [nvarchar](255) NULL,
	[MailingAddr1] [nvarchar](50) NULL,
	[MailingAddr2] [nvarchar](50) NULL,
	[MailingCity] [nvarchar](30) NULL,
	[MailingState] [nvarchar](2) NULL,
	[MailingZip] [nvarchar](10) NULL,
	[NumSmokers] [tinyint] NULL,
	[InOutPets] [bit] NULL,
	[LeadDishware] [bit] NULL,
	[Medicaid] [bit] NULL,
	[GiftCertificate] [bit] NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FamilyPropertyLink]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FamilyPropertyLink](
	[PropertyID] [varchar](50) NULL,
	[FamilyID] [varchar](50) NULL,
	[FPLinkStart] [varchar](50) NULL,
	[FPLinkEnd] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Revision] [varchar](50) NULL,
	[Updated] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkActionStatus]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkActionStatus](
	[ActionStatusCode] [nvarchar](1) NULL,
	[ActionStatus] [nvarchar](30) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkChildStatus]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkChildStatus](
	[ChildStatusCode] [nvarchar](1) NULL,
	[ChildStatus] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkCleanupStatus]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkCleanupStatus](
	[CleanupStatusCode] [nvarchar](1) NULL,
	[CleanupStatus] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkCondition]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkCondition](
	[ConditionCode] [nvarchar](1) NULL,
	[Condition] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkConstType]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkConstType](
	[ConstTypeCode] [nvarchar](1) NULL,
	[ConstType] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkContactType]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkContactType](
	[ContactTypeCode] [nvarchar](1) NULL,
	[ContactType] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkDataReview]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkDataReview](
	[ReviewStatusCode] [nvarchar](1) NULL,
	[ReviewStatus] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkDataSource]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkDataSource](
	[DataSourceCode] [nvarchar](1) NULL,
	[DataSource] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkDescription]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkDescription](
	[Description] [nvarchar](30) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkEthnicBackground]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkEthnicBackground](
	[EthnicCode] [nvarchar](1) NULL,
	[EthnicBackground] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkFlag]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkFlag](
	[FlagCode] [nvarchar](1) NULL,
	[Flag] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkFPLinkType]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkFPLinkType](
	[FPLinkTypeCode] [nvarchar](1) NULL,
	[FPLinkType] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkFrequency]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkFrequency](
	[FrequencyCode] [tinyint] NULL,
	[Frequency] [nvarchar](25) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkHistoricContrib]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkHistoricContrib](
	[HistContribCode] [nvarchar](1) NULL,
	[HistContrib] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkLocation]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkLocation](
	[Location] [nvarchar](30) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkMedia]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkMedia](
	[MediumCode] [nvarchar](1) NULL,
	[Medium] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkMethod]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkMethod](
	[MethodCode] [nvarchar](1) NULL,
	[Method] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkObject]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkObject](
	[Object] [nvarchar](30) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkPrimLanguage]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkPrimLanguage](
	[PrimLanguageCode] [nvarchar](1) NULL,
	[PrimLanguage] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkReleaseStatus]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkReleaseStatus](
	[ReleaseCode] [nvarchar](1) NULL,
	[ReleaseStatus] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkSamplePurpose]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkSamplePurpose](
	[SamplePurposeCode] [nvarchar](1) NULL,
	[SamplePurpose] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkSampleType]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkSampleType](
	[SampleTypeCode] [nvarchar](1) NULL,
	[SampleType] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[lkUnits]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkUnits](
	[UnitsCode] [nvarchar](1) NULL,
	[Units] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OtherPropertyLinks]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OtherPropertyLinks](
	[ChildID] [int] NULL,
	[PropertyID] [int] NULL,
	[VisitNotes] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Properties]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Properties](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyType] [nvarchar](15) NULL,
	[KidsFirstID] [nvarchar](20) NULL,
	[ScheduleNumber] [nvarchar](20) NULL,
	[StreetNumber] [nvarchar](10) NULL,
	[StreetPrefix] [nvarchar](2) NULL,
	[Street] [nvarchar](25) NULL,
	[AptNumber] [nvarchar](4) NULL,
	[Area] [nvarchar](2) NULL,
	[YearBuilt] [nvarchar](4) NULL,
	[Location_CX] [float] NULL,
	[Location_CY] [float] NULL,
	[OwnerFName] [nvarchar](50) NULL,
	[OwnerLName] [nvarchar](50) NULL,
	[OwnerAddress1] [nvarchar](33) NULL,
	[OwnerAddress2] [nvarchar](33) NULL,
	[OwnerAddress3] [nvarchar](33) NULL,
	[OwnerAddress4] [nvarchar](33) NULL,
	[OwnerState] [nvarchar](2) NULL,
	[OwnerZipCode] [nvarchar](9) NULL,
	[OwnerPhone] [nvarchar](50) NULL,
	[OwnerOccupied] [bit] NULL,
	[OwnerNotes] [nvarchar](50) NULL,
	[CleanupStatusCode] [nvarchar](1) NULL,
	[HistContribCode] [nvarchar](1) NULL,
	[HistContribDate] [datetime2](7) NULL,
	[WithinHistDist] [bit] NULL,
	[ConstTypeCode] [nvarchar](1) NULL,
	[PlasticMiniBlinds] [bit] NULL,
	[Remodeled] [bit] NULL,
	[RemodNotes] [nvarchar](50) NULL,
	[ReplPipesFaucets] [bit] NULL,
	[ArchPotential] [bit] NULL,
	[ArchDate] [datetime2](7) NULL,
	[PropertyNotes] [nvarchar](255) NULL,
	[PropertyAddress] [nvarchar](33) NULL,
	[OwnerName] [nvarchar](33) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL,
	[Cost] [money] NULL,
	[MHMovedDate] [datetime2](7) NULL,
	[EnvirTestedAdjacent] [bit] NULL,
	[AdjacentPropKFID] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PropertiesImport]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertiesImport](
	[ScheduleNumber] [nvarchar](20) NULL,
	[Import] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PropertyContact]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyContact](
	[PropertyID] [int] NULL,
	[ContactDate] [datetime2](7) NULL,
	[ContactTypeCode] [nvarchar](50) NULL,
	[ContactNotes] [nvarchar](255) NULL,
	[YoungKids] [nvarchar](1) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questionnaires]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaires](
	[ChildID] [int] NULL,
	[QuestDate] [datetime2](7) NULL,
	[Source] [nvarchar](50) NULL,
	[VisitRemodeled] [bit] NULL,
	[RemodBldgAge] [nvarchar](10) NULL,
	[PaintPeel] [bit] NULL,
	[PaintBldgAge] [nvarchar](10) NULL,
	[Vitamins] [bit] NULL,
	[MouthingIndex] [tinyint] NULL,
	[Nursing] [bit] NULL,
	[Pacifier] [bit] NULL,
	[Bottle] [bit] NULL,
	[BiteNails] [bit] NULL,
	[NonFoodEating] [bit] NULL,
	[NonFoodInMouth] [tinyint] NULL,
	[EatOutside] [bit] NULL,
	[Sucking] [tinyint] NULL,
	[HandWashPerDay] [tinyint] NULL,
	[Daycare] [bit] NULL,
	[DaycareNotes] [nvarchar](255) NULL,
	[OtherNotes] [nvarchar](255) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SampleEvents]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleEvents](
	[SampleEventID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[SampleDate] [datetime2](7) NULL,
	[SamplePurposeCode] [nvarchar](1) NULL,
	[MediumCode] [nvarchar](1) NULL,
	[Comments] [nvarchar](255) NULL,
	[Clearance] [bit] NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SampleLocations]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleLocations](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[SampleEventID] [int] NULL,
	[Location] [nvarchar](50) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Samples]    Script Date: 9/27/2014 4:51:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Samples](
	[SampleID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NULL,
	[KidsFirstSampleID] [nvarchar](50) NULL,
	[SampleTypeCode] [nvarchar](1) NULL,
	[Object] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[ConditionCode] [nvarchar](1) NULL,
	[ReviewStatusCode] [nvarchar](1) NULL,
	[UpdateDate] [datetime2](7) NULL
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [TESTAccessImport-Scrubbed] SET  READ_WRITE 
GO
