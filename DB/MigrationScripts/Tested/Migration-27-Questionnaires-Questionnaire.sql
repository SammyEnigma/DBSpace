use LCCHPTestImport
go

-- ~ :50 seconds

-- Update all columns less the ModifiedDate
insert into  Questionnaire (QuestionnaireDate
			, [QuestionnaireDataSourceID]
			, VisitRemodeledProperty
			, RemodelPropertyDate
			, isExposedtoPeelingPaint
			, isTakingVitamins, NursingInfant, NursingMother, isUsingPacifier, isUsingBottle, BitesNails, NonFoodEating, NonFoodInMouth
			, EatOutside, Suckling, FrequentHandWashing
			, DaycareID
			, PersonID
			, ReviewStatusID)
			SELECT QDate = cast(TQ.QuestDate as date)
						, QDS.QuestionnaireDataSourceID
						, TQ.VisitRemodeled
						, RemodBldAge = case
											WHEN TQ.RemodBldgAge = 'Before 1960' THEN '19500101'
											WHEN TQ.RemodBldgAge = 'After 1960' THEN '19600101'
											WHEN TQ.RemodBldgAge = '1800''s' THEN '18500101'
										END
						, PaintBldgAge = case
											WHEN TQ.PaintBldgAge = 'Before 1960' THEN '19500101'
											WHEN TQ.PaintBldgAge = 'After 1960' THEN '19600101'
											WHEN TQ.PaintBldgAge = '1800''s' THEN '18500101'
										END
						, TQ.PaintPeel
						, TQ.Vitamins
						, NursingInfant = CASE 
										WHEN dbo.udf_CalculateAge(P.BirthDate,cast(TQ.QuestDate as date)) < 10 THEN TQ.Nursing
									END
						, NursingMother = CASE
										WHEN P.Gender = 'F' AND dbo.udf_CalculateAge(P.BirthDate,cast(TQ.QuestDate as date)) > 15 THEN TQ.Nursing
									END	
						, TQ.Pacifier, TQ.Bottle, TQ.BiteNails, TQ.NonFoodEating, TQ.NonFoodInMouth
						, TQ.EatOutside, TQ.Sucking, FreqHandWash = CASE 
														WHEN TQ.HandWashPerDay = 0 THEN 0
														WHEN TQ.HandWashPerDay > 0 THEN 1
													END
						, DayCareID = Case 
										WHEN TQ.DaycareNotes like '%morning star%' THEN (select daycareID from Daycare where DaycareName = 'Morning Star')
										WHEN TQ.DaycareNotes like '%Headstart%' THEN (select daycareID from Daycare where DaycareName = 'HeadStart')
										WHEN TQ.DaycareNotes like '%daycare%' THEN (select daycareID from Daycare where DaycareName = 'Daycare')
										WHEN TQ.DaycareNotes like '%Preschool%' THEN (select daycareID from Daycare where DaycareName = 'Preschool')
										WHEN TQ.DaycareNotes IS NULL THEN NULL
										ELSE (select daycareID from Daycare where DaycareName = 'Other')
									END
						, P.personID 
						, RS.ReviewStatusID
					FROM TESTAccessImport..Questionnaires AS TQ
					JOIN Person AS P on TQ.ChildID = P.HistoricChildID
					JOIN [QuestionnaireDataSource] AS QDS on TQ.Source = QDS.[QuestionnaireDataSourceName]
					JOIN ReviewStatus AS RS ON RS.HistoricReviewStatusID = TQ.ReviewStatusCode
					order by QuestDate

	-- INsert questionnaire notes
	Insert into QuestionnaireNotes (QuestionnaireID,Notes)
		select Q.QuestionnaireID
		,concat(TAIQ.OtherNotes, ' ', TAIQ.DaycareNotes, ' ' , TAIQ.RemodBldgAge)
		 from TESTAccessImport..Questionnaires AS TAIQ
		 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
		 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
		 where TAIQ.OtherNotes is not null 
		 order by childID


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
			,concat('Building remodel date: ',TAIQ.RemodBldgAge)
			 from TESTAccessImport..Questionnaires AS TAIQ
			 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
			 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
			 where TAIQ.RemodBldgAge is not null-- or TAIQ.PaintBldgAge is not null
			 order by childID

		Update QuestionnaireNotes set Notes = concat(Notes,'. Building paint date: ',TAIQ.PaintBldgAge)
			 from TESTAccessImport..Questionnaires AS TAIQ
			 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
			 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
			 where TAIQ.PaintBldgAge is not null
			-- order by childID

		-- Update last modified date	
		update LQ
		SET LQ.ModifiedDate = cast(TQ.UpdateDate as datetime2)
		from Questionnaire AS LQ
		JOIN TestAccessImport..Questionnaires AS TQ on LQ.QuestionnaireDate = TQ.QuestDate
		JOIN Person AS P on P.PersonID = LQ.PersonID AND P.HistoricChildID = TQ.ChildID


--- VALIDATIONS
-- ensure row counts match
select count(*) from Questionnaire	
select count(*) from TESTAccessImport..Questionnaires

-- ensure groupings by remodel date counts match
select count(RemodelPropertyDate) from Questionnaire 
where RemodelPropertyDate is not null
select count(*) from TESTAccessImport..Questionnaires where RemodBldgAge is not null

-- ensure groupings by remodel date counts match
select count(PaintDate) from Questionnaire 
where PaintDate is not null
select count(*) from TESTAccessImport..Questionnaires where PaintBldgAge is not null

