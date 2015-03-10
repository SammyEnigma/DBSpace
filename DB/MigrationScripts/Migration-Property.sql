USE LCCHPTest
GO

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [PropertyID]
      ,[PropertyType]
      ,[KidsFirstID]
      ,[ScheduleNumber]
      ,[StreetNumber]
      ,[StreetPrefix]
      ,[Street]
      ,[AptNumber]
      ,[Area]
      ,[YearBuilt]
      ,[Location_CX]
      ,[Location_CY]
      ,[OwnerFName]
      ,[OwnerLName]
      ,[OwnerAddress1]
      ,[OwnerAddress2]
      ,[OwnerAddress3]
      ,[OwnerAddress4]
      ,[OwnerState]
      ,[OwnerZipCode]
      ,[OwnerPhone]
      ,[OwnerOccupied]
      ,[OwnerNotes]
      ,[CleanupStatusCode]
      ,[HistContribCode]
      ,[HistContribDate]
      ,[WithinHistDist]
      ,[ConstTypeCode]
      ,[PlasticMiniBlinds]
      ,[Remodeled]
      ,[RemodNotes]
      ,[ReplPipesFaucets]
      ,[ArchPotential]
      ,[ArchDate]
      ,[PropertyNotes]
      ,[PropertyAddress]
      ,[OwnerName]
      ,[ReviewStatusCode]
      ,[UpdateDate]
      ,[Cost]
      ,[MHMovedDate]
      ,[EnvirTestedAdjacent]
      ,[AdjacentPropKFID]
  FROM [TESTAccessImport].[dbo].[Properties]

--  select * from PersontoProperty

  Insert Into Property (HistoricPropertyID,StreetNumber,Street,ApartmentNumber,City,[State],
			ZipCode,
			AreaID,
			YearBuilt,isOwnerOccuppied,
			ConstructionTypeID,
			isRemodeled,isinHistoricDistrict,ReplacedPipesFaucets,County,notes)
  select PropertyID,StreetNumber,
         Case  
		 when StreetPrefix is null then Street
		 else StreetPrefix + ' ' + Street
		 END
		 ,AptNumber,'Leadville','CO','80461',AreaID,
         YearBuilt,OwnerOccupied,ConstructionTypeID
		 ,Remodeled,WithinHistDist,
		 CASE 
		 when ReplPipesFaucets < 0 then 0
		 else 1
		 END,'Lake',OwnerNotes + ': ' + PropertyNotes + ': ' + RemodNotes
  FROM TESTAccessImport..Properties as Prop
  join Area as LTTA on LTTA.AreaName = Prop.Area
  join ConstructionType as LTTCT on LTTCT.ConstructionTypeDescription = Prop.ConstTypeCode
  order by StreetNumber
  /*
  select * from Area
  select * from TESTAccessImport..Properties where YearBuilt is not null
  select * from ConstructionType
   select * from TESTAccessImport..lkConstType
   select * from PersonToProperty

   */

   select * from Property
   select PropertyID,RemodNotes,OwnerNotes,PropertyNotes 
   from TESTAccessImport..Properties where RemodNotes is not null


   insert into Property (Notes)
   select    Coalesce(OwnerNotes,'') + ': ' + Coalesce(PropertyNotes,'')+ ': ' + Coalesce(RemodNotes,'')
  FROM TESTAccessImport..Properties as Prop
  join Property as LTTP on LTTP.HistoricPropertyID = Prop.PropertyID
  where OwnerNotes is not Null or PropertyNotes is not null or RemodNotes is not null