USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertQuestionnaire]    Script Date: 4/26/2015 8:29:36 PM ******/
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
	@isNursing bit = Null,
	@isUsingPacifier bit = NULL,
	@isUsingBottle bit = NULL,
	@BitesNails bit = NULL,
	@NonFoodEating bit = NULL,
	@NonFoodinMouth bit = NULL,
	@EatOutside bit = NULL,
	@Suckling bit = NULL,
	@Mouthing bit = NULL,
	@FrequentHandWashing bit = NULL,
	@Daycare bit = NULL,
	@New_Notes varchar(3000) = NULL,
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
		                             isExposedtoPeelingPaint, isTakingVitamins, isNursing, isUsingPacifier, isUsingBottle,
									 Bitesnails, NonFoodEating, NonFoodinMouth, EatOutside, Suckling, Mouthing,  FrequentHandWashing,
									 Daycare )
					 Values ( @PersonID, @QuestionnaireDate, @QuestionnaireDataSourceID, @VisitRemodeledProperty, @PaintDate, @RemodelPropertyDate,
		                      @isExposedtoPeelingPaint, @isTakingVitamins, @isNursing, @isUsingPacifier, @isUsingBottle,
							  @Bitesnails, @NonFoodEating, @NonFoodinMouth, @EatOutside, @Suckling, @Mouthing, @FrequentHandWashing,
							  @Daycare );
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
