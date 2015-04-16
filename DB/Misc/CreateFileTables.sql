USE [master]
GO
ALTER DATABASE [LCCHPDev] ADD FILEGROUP [LCCHPAttachments] CONTAINS FILESTREAM 
GO
USE [LCCHPDev]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'LCCHPAttachments')
	ALTER DATABASE [LCCHPDev] MODIFY FILEGROUP [LCCHPAttachments] DEFAULT
GO

ALTER DATABASE LCCHPDev
    SET FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'LCCHPAttachments' );
GO

ALTER DATABASE [LCCHPDev]
ADD FILE
(
    NAME= 'LCCHPAttachments',
    FILENAME = 'D:\MSSQL\Filestream\LCCHPAttachments'
)
TO FILEGROUP LCCHPAttachments;


USE [LCCHPDev]
GO

SELECT DB_NAME ( database_id ), directory_name
    FROM sys.database_filestream_options;
GO


-- =========================================
-- Create FileTable template
-- =========================================
USE LCCHPDev
GO

IF OBJECT_ID('dbo.LCCHPAttachments', 'U') IS NOT NULL
  DROP TABLE dbo.LCCHPAttachments
GO

CREATE TABLE dbo.LCCHPAttachments AS FILETABLE
  WITH
  (
    FILETABLE_DIRECTORY = 'LCCHPAttachments',
    FILETABLE_COLLATE_FILENAME = database_default
  )
GO
