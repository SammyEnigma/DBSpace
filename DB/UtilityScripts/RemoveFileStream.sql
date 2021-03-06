USE [master]
RESTORE DATABASE [LCCHPTestImportNoFileStream] FROM  
DISK = N'Y:\Backup\WIN-1M8NQQ69OEH\LCCHPTestImport\FULL\LCCHPTestImport_Full_20150525232254.bak' WITH  FILE = 1,  MOVE N'LCCHPAttachments' TO N'D:\MSSQL\TestRestore\LCCHPAttachmentsTestImport',  MOVE N'LCCHP' TO N'D:\MSSQL\TestRestore\LCCHPTestImport.mdf',  MOVE N'LCCHP_UData' TO N'D:\MSSQL\TestRestore\LCCHPTestImport_UData.ndf',  MOVE N'LCCHP_log' TO N'D:\MSSQL\TestRestore\LCCHPTestImport_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
, REPLACE
RESTORE LOG [LCCHPTestImportNoFileStream] FROM  
DISK = N'Y:\Backup\WIN-1M8NQQ69OEH\LCCHPTestImport\Diff\LCCHPTestImport_Diff_20150531163853.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
-- RESTORE LOG [LCCHPTestImportNoFileSteam] FROM  DISK = N'Y:\Backup\WIN-1M8NQQ69OEH\LCCHPTestImport_LogBackup_2015-05-01_15-08-01.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5


restore database LCCHPTestImportNoFileStream
GO

USE [master]
GO
ALTER DATABASE [LCCHPTestImportNoFileStream] SET FILESTREAM( DIRECTORY_NAME = N'LCCHPAttachmentDev' )
 WITH NO_WAIT
GO

/****** Object:  Table [dbo].[LCCHPAttachments]    Script Date: 5/1/2015 2:06:44 PM ******/
DROP TABLE LCCHPTestImportNoFileStream.[dbo].[LCCHPAttachments]
GO

ALTER DATABASE [LCCHPTestImportNoFileStream]  REMOVE FILE [LCCHPAttachments]
GO
ALTER DATABASE [LCCHPTestImportNoFileStream] REMOVE FILEGROUP [LCCHPAttachments]
GO