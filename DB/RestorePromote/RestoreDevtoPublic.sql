USE [master]

DECLARE @BaseBackupPath nvarchar(500)
		, @FullDBBackupFileName nvarchar(500)
		, @DiffDBBackupFileName nvarchar(500)
		, @LogDBBackupFileName nvarchar(500);

SET @BaseBackupPath = N'Y:\Backup\WIN-1M8NQQ69OEH\LCCHPDev\';
SET @FullDBBackupFileName = @BaseBackupPath + N'LCCHPDevPromotetoLCCHPPublic.bak';
SET @DiffDBBackupFileName = NULL;
SET @LogDBBackupFileName = NULL;

BACKUP DATABASE [LCCHPDev] TO  DISK = @FullDBBackupFileName
 WITH  COPY_ONLY, NOFORMAT, INIT,  NAME = N'LCCHPDev-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

ALTER DATABASE [LCCHPPublic] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [LCCHPPublic] FROM  
DISK = @FullDBBackupFileName
WITH  FILE = 1,  MOVE N'LCCHP' TO N'D:\MSSQL\Data\LCCHPPublic.mdf',  
MOVE N'LCCHP_UData' TO N'D:\MSSQL\Data\LCCHPPublic_UData.ndf',  
MOVE N'LCCHP_log' TO N'D:\MSSQL\Log\LCCHPPublic_log.ldf',  
MOVE N'LCCHPAttachments' TO N'D:\MSSQL\Filestream\LCCHPAttachmentsPublic',  NOUNLOAD,  NORECOVERY, REPLACE,  STATS = 5

IF (@DiffDBBackupFileName IS NOT NULL)
	RESTORE DATABASE [LCCHPPublic] FROM 
	DISK = @DiffDBBackupFileName WITH STATS = 5

IF (@LogDBBackupFileName IS NOT NULL)
	RESTORE DATABASE [LCCHPPublic] FROM 
	DISK = @LogDBBackupFileName

RESTORE DATABASE LCCHPPublic

USE [master]
GO
ALTER DATABASE [LCCHPPublic] SET FILESTREAM( DIRECTORY_NAME = N'LCCHPAttachmentsPublic' ) WITH NO_WAIT
GO


ALTER DATABASE [LCCHPPublic] SET MULTI_USER
GO







select count(*) from LCCHPPublic..BloodTestResults

select count(*) from LCCHPDev..BloodTestResults