USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPerson]    Script Date: 4/26/2015 8:29:36 PM ******/
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
