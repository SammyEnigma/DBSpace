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

DECLARE @Default_Data_Path VARCHAR(512)   
        , @Default_Log_Path VARCHAR(512)
		, @BaseBackupPath nvarchar(500)
		, @FullDBBackupFileName nvarchar(500)
		, @PublicBaseBackupPath nvarchar(500)
		, @PublicFullDBBackupFileName nvarchar(500)
		, @DiffDBBackupFileName nvarchar(500)
		, @LogDBBackupFileName nvarchar(500)
		, @BackupTimeStamp nvarchar(100)
		, @RestoreCommand nvarchar(4000)
		, @FileStreamPath nvarchar(500);

		SET @FileStreamPath = 'D:\MSSQL\Filestream\'
		SET @FullDBBackupFileName = 'FULLDBBackupPath';

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

Select @RestoreCommand = 'RESTORE DATABASE [LCCHPDEV] FROM DISK = ' + @FullDBBackupFileName + ' WITH  FILE = 1,  
	MOVE N''LCCHP'' TO N''' + @Default_Data_Path + 'LCCHPPublic.mdf'',  
	MOVE N''LCCHP_UData'' TO N''' + @Default_Data_Path + 'LCCHPPublic_UData.ndf'',  
	MOVE N''LCCHP_log'' TO N''' + @Default_Log_Path + 'LCCHPPublic_log.ldf'',  
	MOVE N''LCCHPAttachments'' TO N''' + @FileStreamPath + 'LCCHPAttachmentsPublic'',  NOUNLOAD,  RECOVERY, REPLACE,  STATS = 5';

SELECT @RestoreCommand

