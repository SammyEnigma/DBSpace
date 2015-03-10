-- Insert Into [Source] (SourceName) Select distinct [Source] from TESTAccessImport..Questionnaires

--	update TESTAccessImport..Questionnaires set QuestDate = '19980601' where QuestDate = '0698-12-04 00:00:00.0000000'


use LCCHPDev
go

-- Update all columns less the ModifiedDate
insert into  Questionnaire (QuestionnaireDate,
			[Source]
			, VisitRemodeledProperty,RemodelPropertyDate
			, isExposedtoPeelingPaint
			, isTakingVitamins, isNursing, isUsingPacifier, isUsingBottle, BitesNails, NonFoodEating, NonFoodInMouth
			, EatOutside, Suckling, FrequentHandWashing
			, Daycare, Notes-- , ModifiedDate
			,PersonID)
	SELECT cast(TQ.QuestDate as date), 
	S.SourceID
			, TQ.VisitRemodeled, TQ.RemodBldgAge
			, TQ.PaintPeel
			, TQ.Vitamins, TQ.Nursing, TQ.Pacifier, TQ.Bottle, TQ.BiteNails, TQ.NonFoodEating, TQ.NonFoodInMouth
			, TQ.EatOutside, TQ.Sucking, CASE 
											WHEN TQ.HandWashPerDay = 0 THEN 0
											WHEN TQ.HandWashPerDay > 0 THEN 1
										END
			, TQ.Daycare, TQ.OtherNotes-- , cast(TQ.UpdateDate as datetime) 
			, P.personID 
		FROM TESTAccessImport..Questionnaires AS TQ
		JOIN LCCHPDev..Person AS P on TQ.ChildID = P.PersonCode
		JOIN LCCHPDev..Source AS S on TQ.[Source] = S.SourceName
		
		-- Update last modified date
		update LQ
		SET LQ.ModifiedDate = cast(TQ.UpdateDate as date)
		from LCCHPDev..Questionnaire AS LQ
		JOIN TestAccessImport..Questionnaires AS TQ on LQ.QuestionnaireDate = TQ.QuestDate
		JOIN LCCHPDev..Person AS P on P.PersonID = LQ.PersonID AND P.PersonCode = TQ.ChildID


		select TQ.UpdateDate, TQ.QuestDate, LQ.QuestionnaireDate, LQ.QuestionnaireID
		from TESTAccessImport..Questionnaires AS TQ
		JOIN LCCHPDev..Questionnaire AS LQ 
			on LQ.QuestionnaireDate = TQ.QuestDate
		JOIN LCCHPDev..Person AS P on P.PersonID = LQ.PersonID AND P.PersonCode = TQ.ChildID
		order by LQ.QuestionnaireID desc

		
		select ModifiedDate,CreatedDate,* from Questionnaire where cast(CreatedDate as Date) = '20150201'