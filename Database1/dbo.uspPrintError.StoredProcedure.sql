USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[uspPrintError]    Script Date: 4/26/2015 8:29:36 PM ******/
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
