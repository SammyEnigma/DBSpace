USE LCCHPTestImport
GO

-- IMPORT Property attributes
  Insert Into Property (HistoricPropertyID,AssessorsOfficeID,AddressLine1,AddressLine2,City,[State],ZipCode
			,AreaID,YearBuilt,isOwnerOccuppied,ConstructionTypeID,KidsFirstID,CleanupStatusID
			,isRemodeled,isinHistoricDistrict,ReplacedPipesFaucets,County,ReviewStatusID)
  select PropertyID,ScheduleNumber,PropertyAddress,AptNumber,'Leadville','CO','80461'
			,AreaID
			,CASE
				WHEN YearBuilt = 0 THEN NULL
				ELSE YearBuilt
			END
			,OwnerOccupied,LTTCT.ConstructionTypeID,KidsFirstID,CS.CleanupStatusID
		 ,Remodeled,WithinHistDist,
		 CASE 
			 when ReplPipesFaucets <> 0 then 1
		 END,'Lake', RS.ReviewStatusID
  FROM TESTAccessImport..Properties as Prop
LEFT OUTER JOIN AREA AS LTTA ON Prop.Area = LTTA.HistoricAreaID
 LEFT OUTER JOIN ConstructionTYPE AS LTTCT on Prop.ConstTypeCode = LTTCT.HistoricConstructionTypeID
 LEFT OUTER JOIN CleanupStatus AS CS on Prop.CleanupStatusCode = CS.HistoricCleanupStatusID
 LEFT OUTER JOIN ReviewStatus AS RS on Prop.ReviewStatusCode = RS.HistoricReviewStatusID
order by Prop.YearBuilt

-- upate notes (ownernotes, propertynotes,remodnotes
  insert into PropertyNotes (PropertyID,Notes)
  SELECT LTTP.PropertyID, concat(isnull(OwnerNotes,''), ': ', isnull(PropertyNotes,''), ': ', isNull(RemodNotes,''))
   FROM TESTAccessImport..Properties as Prop
  join Property as LTTP on LTTP.HistoricPropertyID = Prop.PropertyID
  where OwnerNotes is not Null or PropertyNotes is not null or RemodNotes is not null

  --- update modified date
		update P set ModifiedDate = cast(TAIP.UpdateDate as datetime2)
		-- Select PersonID,ChildID,P.HistoricChildID,cast(UpdateDate as date)
		FROM Property AS P
		JOIN TestAccessImport..Properties AS TAIP ON P.HistoricPropertyID = TAIP.PropertyID

-- count properties with no updated/modified date
SELECT count(*) from Property where ModifiedDate is not null
select count(*) from TESTAccessImport..Properties where UpdateDate is not null

-- count of all properties
select count(*) from property
  select count(*) from TESTAccessImport..Properties