use LCCHPPublic
go
SET NOCOUNT ON;
-- ~ :50 seconds

select 'insering rows into questionnaire';
-- Update all columns less the ModifiedDate
insert into  Questionnaire (QuestionnaireDate
			, [QuestionnaireDataSourceID]
			, VisitRemodeledProperty
			, RemodelPropertyDate
			, PaintDate
			, isExposedtoPeelingPaint
			, isTakingVitamins, NursingInfant, NursingMother, isUsingPacifier, isUsingBottle, BitesNails, NonFoodEating, NonFoodInMouth
			, EatOutside, Suckling, FrequentHandWashing
			, DaycareID
			, PersonID
			, ReviewStatusID)
			SELECT QDate = cast(TQ.QuestDate as datetime2)
						, QDS.QuestionnaireDataSourceID
						, TQ.VisitRemodeled
						, RemodBldDate = case
											WHEN TQ.RemodBldgAge = 'Before 1960' THEN '19500101'
											WHEN TQ.RemodBldgAge = 'Before1960' THEN '19500101'
											WHEN TQ.RemodBldgAge = 'After 1960' THEN '19600101'
											WHEN TQ.RemodBldgAge = '1800''s' THEN '18500101'
										END
						, PaintBldgDate = case
											WHEN TQ.PaintBldgAge = 'Before 1960' THEN '19500101' 
											WHEN TQ.PaintBldgAge = 'Before1960' THEN '19500101' 
											WHEN TQ.PaintBldgAge = 'After 1960' THEN '19600101' 
											WHEN TQ.PaintBldgAge = '1800''s' THEN '18500101'
										END
						, TQ.PaintPeel
						, TQ.Vitamins
						, NursingInfant = CASE 
										WHEN dbo.udf_CalculateAge(P.BirthDate,cast(TQ.QuestDate as datetime)) < 10 THEN TQ.Nursing
									END
						, NursingMother = CASE
										WHEN P.Gender = 'F' AND dbo.udf_CalculateAge(P.BirthDate,cast(TQ.QuestDate as datetime)) > 15 THEN TQ.Nursing
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
					FROM LCCHPImport..Questionnaires AS TQ
					JOIN Person AS P on TQ.ChildID = P.HistoricChildID
					JOIN [QuestionnaireDataSource] AS QDS on TQ.Source = QDS.[QuestionnaireDataSourceName]
					JOIN ReviewStatus AS RS ON RS.HistoricReviewStatusID = TQ.ReviewStatusCode
					order by QuestDate;

select 'inserting questionnaire notes from Othernotes';
	-- INsert questionnaire notes
	Insert into QuestionnaireNotes (QuestionnaireID,Notes)
		select Q.QuestionnaireID
		,concat(TAIQ.OtherNotes, ' ', TAIQ.DaycareNotes, ' ' , TAIQ.RemodBldgAge)
		 from LCCHPImport..Questionnaires AS TAIQ
		 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
		 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
		 where TAIQ.OtherNotes is not null 
		 order by childID;

select 'inserting questoinnairenotes from daycare notes';
	-- INsert daycare notes
	Insert into QuestionnaireNotes (QuestionnaireID,Notes)
		select Q.QuestionnaireID
		,TAIQ.DayCareNotes
		 from LCCHPImport..Questionnaires AS TAIQ
		 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
		 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
		 where TAIQ.DayCareNotes is not null 
		 order by childID;

select 'adding remodel date to questionnairenotes';
		-- add RemodBldAge and PaintBldgAge to Questionnaire notes
		Insert into QuestionnaireNotes (QuestionnaireID,Notes)
			select Q.QuestionnaireID
			,concat('Building remodel date: ',TAIQ.RemodBldgAge)
			 from LCCHPImport..Questionnaires AS TAIQ
			 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
			 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
			 where TAIQ.RemodBldgAge is not null-- or TAIQ.PaintBldgAge is not null
			 order by childID;

select 'adding paint date to questionnaire notes';
		Update QuestionnaireNotes set Notes = concat(Notes,'. Building paint date: ',TAIQ.PaintBldgAge)
			 from LCCHPImport..Questionnaires AS TAIQ
			 JOIN Person AS P ON TAIQ.ChildID = P.HistoricChildID
			 JOIN Questionnaire AS Q on Q.QuestionnaireDate = TAIQ.QuestDate AND Q.PersonID = P.PersonID
			 where TAIQ.PaintBldgAge is not null;

select 'updating modified date'
		-- Update last modified date	
		update LQ
		SET LQ.ModifiedDate = cast(TQ.UpdateDate as datetime)
		from Questionnaire AS LQ
		JOIN LCCHPImport..Questionnaires AS TQ on LQ.QuestionnaireDate = TQ.QuestDate
		JOIN Person AS P on P.PersonID = LQ.PersonID AND P.HistoricChildID = TQ.ChildID;

select 'comparing questionnaire row count to questionnaires row count';
--- VALIDATIONS
-- ensure row counts match
select count(*) from Questionnaire;	
select count(*) from LCCHPImport..Questionnaires;

select 'comparing groupings by remodel date of questionnaire row count to questionnaires row count';
-- ensure groupings by remodel date counts match
select count(RemodelPropertyDate) from Questionnaire 
where RemodelPropertyDate is not null;
select count(*) from LCCHPImport..Questionnaires where RemodBldgAge is not null;

select 'comparing groupings by paint date of questionnaire row count to questionnaires row count';
-- ensure groupings by paint date counts match
select count(PaintDate) from Questionnaire 
where PaintDate is not null;
select count(*) from LCCHPImport..Questionnaires where PaintBldgAge is not null;

select 'list rows in questionnaires with a blank paintBldgAge'
Select LQ.ChildID,LQ.QuestDate,LQ.PaintBldgAge,Q.PaintDate from LCCHPImport..Questionnaires AS LQ
JOIN Person AS P on LQ.ChildID = P.HistoricChildID
JOIN Questionnaire AS Q on P.PersonID = Q.PersonID AND LQ.QuestDate = Q.QuestionnaireDate
where LQ.PaintBldgAge is not null
and Q.PaintDate is null