 DECLARE @OUTPUTData int, @FID int, @return_value int;
 
 set @FID = -1

-- 10000 is an invalid family id, so will return an error aka -1
EXEC @return_value = [usp_InsertNewClientWebScreen]
	@Family_ID = @FID,
	@First_Name = 'Beth',
	@Last_Name = 'Crocker',
	@Birth_Date = '20101215',
	@Gender_ = 'F',
	@Language_ID = 2,
	-- @Ethnicity,
	@Moved_ = 0,
	@Travel = 0,
	@Travel_Notes = NULL,
	@Out_of_Site = 0,
	@Hobby_ID = '8',
	-- @HobbyNotes = NULL,
	@Child_Notes = 'splashes in puddles',
	@is_Smoker = 0,
	@ClientID = @OUTPUTData OUTPUT;

select @return_value '@Return_value';

select * from errorlog

 set @FID = 2667
-- 2667 is a valid family id return value is 0
EXEC @return_value = [usp_InsertNewClientWebScreen]
	@Family_ID = @FID,
	@First_Name = 'Beth',
	@Last_Name = 'Crocker',
	@Birth_Date = '20101212',
	@Gender_ = 'F',
	@Language_ID = 2,
	-- @Ethnicity,
	@Moved_ = 0,
	@Travel = 0,
	@Travel_Notes = NULL,
	@Out_of_Site = 0,
	@Hobby_ID = '8',
	-- @HobbyNotes = NULL,
	@Child_Notes = 'splashes in puddles',
	@is_Smoker = 0,
	@ClientID = @OUTPUTData OUTPUT;

select @return_value '@Return_value';

select top 5 * from person order by personID desc