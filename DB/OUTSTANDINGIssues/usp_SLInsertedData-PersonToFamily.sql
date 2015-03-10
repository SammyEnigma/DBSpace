SELECT [P].[PersonID] 
		, 'P2FPersonID' = [P2F].[PersonID]
		, 'FamilyLastName' = [F].[Lastname]
		, [F].[FamilyID]
		, 'P2FFamilyID' = [P2F].[FamilyID]
		, [P].[LastName]
		, [P].[MiddleName]
		, [P].[FirstName]
		, [P].[BirthDate]
		, [P].[Gender]
		--, 'StreetAddress' = cast([Prop].[StreetNumber] as varchar)
		--	+ ' '+ cast([Prop].[Street] as varchar) + ' ' 
		--	+ cast([Prop].[StreetSuffix] as varchar)
		--, [Prop].[ApartmentNumber]
		--, [Prop].[City]
		--, [Prop].[State]
		--, [Prop].[Zipcode]
		--, 'PrimaryPhoneNumber' = [Ph].[PhoneNumber]
		--, [L].[LanguageName]
		, [F].[NumberofSmokers]
		, [F].[Pets]
		, [F].[inandout]
		, [F].[Notes]

	FROM [Person] AS [P]
	FULL OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
	FULL OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
--	FULL OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
--	FULL OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
	-- where [P2F].FamilyID is NULL
	--  People to families: 3470

	-- 137 null p2f Family IDs (people and families with no counterpart people/families)

	--- 4764  --> people and family relationships including people with no family and families with no people
	SELECT 
		--- How many persontofamily relationshiops: 3326
		(Select count(*) from persontoFamily) 
		-- + People w/o family 
		+ (select count(PersonID) from Person where PersonID not in (select distinct PersonID from PersontoFamily))
		-- + family w/o people  
		+ (select count(FamilyID) from Family where FamilyID not in (select distinct FamilyID from PersontoFamily))

	-- Person and properties = 14684
	SELECT 
		--- How many person to properties? -- 4764
		(select count(*) from PersontoProperty)

		-- how many properties w/o people -- 9476
		+ (Select count(*) from property where PropertyID not in (Select distinct propertyID from PersontoProperty))
		-- how many people w/o property -- 444
		+ (select count(*) from person where personID not in (Select distinct personID from PersontoProperty))


	-- person to property - select 4764 + 9476 + 444 = 14684 (14845) 150?
