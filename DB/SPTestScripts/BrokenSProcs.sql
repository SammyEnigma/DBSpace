USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SLInsertedData]-- 'aardvark'

SELECT	'Return Value' = @return_value

GO

select * from family where LastName = 'Aardvark'
select * from Person where LastName = 'Aardvark'