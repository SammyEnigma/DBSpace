DECLARE @MaxPersonIDtoReplace int, @CountNewNames int, @Count int

CREATE TABLE [dbo].[##names](
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[NameID] [int] NOT NULL
) ON [PRIMARY]



-- determine how many new names were generated
select @CountNewNames = (NameID) from ##names

-- find the max personID with a randomly generated garbage name
select PersonID,Firstname,lastName from person order by personID desc

SET @MaxPersonIDtoReplace = 3206

-- See if there are any duplicate names
select NameID, count(FirstName),count(Lastname) from Names..Names
group by NameID
Having count(FirstName) > 1 or count(LastName) > 1

SET @count = 1
while @count <= @MaxPersonIDtoReplace
BEGIN
	update person set FirstName = (select FirstName from ##Names as N where N.NameID = @count),
	 LastName = (select LastName from ##Names as N where N.NameID = @count)
	 where PersonID = @Count

	SET @count = @Count + 1
END


-- check for NULL names
select PersonID,LastName,FirstName from Person where FirstName is null or LastName is NULL
-- select PersonID,LastName,FirstName from Person where FirstName = 'Danielle'or LastName is NULL

