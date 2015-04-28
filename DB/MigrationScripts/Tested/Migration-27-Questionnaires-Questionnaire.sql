-- Insert Into [Source] (SourceName) Select distinct [Source] from TESTAccessImport..Questionnaires

--	update TESTAccessImport..Questionnaires set QuestDate = '19980601' where QuestDate = '0698-12-04 00:00:00.0000000'

use LCCHPTestImport
go

-- Update all columns less the ModifiedDate
insert into  Questionnaire (QuestionnaireDate,
			[QuestionnaireDataSourceID]
			, VisitRemodeledProperty
			, RemodelPropertyDate
			, isExposedtoPeelingPaint
			, isTakingVitamins, isNursing, isUsingPacifier, isUsingBottle, BitesNails, NonFoodEating, NonFoodInMouth
			, EatOutside, Suckling, FrequentHandWashing
			, Daycare
			, PersonID
			, ReviewStatusID)
	SELECT cast(TQ.QuestDate as date),  
			QDS.QuestionnaireDataSourceID
			, TQ.VisitRemodeled
			, TQ.RemodBldgAge
			, TQ.PaintPeel
			, TQ.Vitamins, TQ.Nursing, TQ.Pacifier, TQ.Bottle, TQ.BiteNails, TQ.NonFoodEating, TQ.NonFoodInMouth
			, TQ.EatOutside, TQ.Sucking, CASE 
											WHEN TQ.HandWashPerDay = 0 THEN 0
											WHEN TQ.HandWashPerDay > 0 THEN 1
										END
			, TQ.Daycare
			, P.personID 
			, RS.ReviewStatusID
		FROM TESTAccessImport..Questionnaires AS TQ
		JOIN Person AS P on TQ.ChildID = P.HistoricChildID
		JOIN [QuestionnaireDataSource] AS QDS on TQ.Source = QDS.[QuestionnaireDataSourceName]
		JOIN ReviewStatus AS RS ON RS.HistoricReviewStatusID = TQ.ReviewStatusCode



select count(*) from TESTAccessImport..Questionnaires
select count(*) from Questionnaire	


	-- INsert questionnaire notes
	Insert into QuestionnaireNotes (QuestionnaireID,Notes)
		select Q.QuestionnaireID
		,TAIQ.OtherNotes
		, TAIQ.DaycareNotes
		 from TESTAccessImport..Questionnaires AS TAIQ
		 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
		 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
		 where TAIQ.OtherNotes is not null 
		 order by childID

	Select * from QuestionnaireNotes

	-- INsert daycare notes
	Insert into QuestionnaireNotes (QuestionnaireID,Notes)
		select Q.QuestionnaireID
		,TAIQ.DayCareNotes
		 from TESTAccessImport..Questionnaires AS TAIQ
		 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
		 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
		 where TAIQ.DayCareNotes is not null 
		 order by childID


		-- add RemodBldAge and PaintBldgAge to Questionnaire notes
		Insert into QuestionnaireNotes (QuestionnaireID,Notes)
			select Q.QuestionnaireID
			,concat(isnull(TAIQ.RemodBldgAge,''),'. ',isnull(TAIQ.PaintBldgAge,''))
			 from TESTAccessImport..Questionnaires AS TAIQ
			 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
			 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
			 where TAIQ.RemodBldgAge is not null or TAIQ.PaintBldgAge is not null
			 order by childID

		-- Update last modified date	
		update LQ
		SET LQ.ModifiedDate = cast(TQ.UpdateDate as date)
		from Questionnaire AS LQ
		JOIN TestAccessImport..Questionnaires AS TQ on LQ.QuestionnaireDate = TQ.QuestDate
		JOIN Person AS P on P.PersonID = LQ.PersonID AND P.HistoricChildID = TQ.ChildID


select QuestDate,RemodBldgAge,PaintBldgAge
--,RemodBlgDate = DateAdd(yy,cast(RemodBldgAge as int),cast(QuestDate as date))
--, PaintBldDate = DateAdd(yy,cast(PaintBldgAge as int),cast(QuestDate as Date))
from TESTAccessImport..Questionnaires